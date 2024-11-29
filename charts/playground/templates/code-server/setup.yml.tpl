---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "code-server.secret.name" . }}
  namespace: {{.Release.Namespace}}
type: Opaque
data:
  {{- if not .Release.IsUpgrade }}
  PASSWORD: {{ randAlphaNum 29 | b64enc }}
  {{- else }}
  PASSWORD:  {{ index (lookup "v1" "Secret" .Release.Namespace (include "code-server.secret.name" .)).data "PASSWORD" }}
  {{- end }}
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: &name {{include "code-server.name" .}}
  namespace: {{.Release.Namespace}}
  labels:
    app: *name
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: *name
  template:
    metadata:
      labels:
        app: *name
    spec:
      hostname: "workspace"

      {{- if .Values.codeServer.extensions }}
      initContainers:
        - name: install-plugins
          image: ghcr.io/kloudlite/hub/coder-with-mongo:latest
          imagePullPolicy: IfNotPresent
          env:
            - name: SERVICE_URL
              value: https://open-vsx.org/vscode/gallery
            - name: ITEM_URL
              value: https://open-vsx.org/vscode/item
          command:
            - bash
            - -c
            - |
              pids=()
              {{- range .Values.codeServer.extensions }}
              code-server --install-extension {{.}} &
              pids+=($!)
              {{- end }}
              wait ${pids[@]}
          volumeMounts:
            - name: storage
              mountPath: /home/coder
      {{- end }}

      containers:
        - name: code-server
          image: ghcr.io/kloudlite/hub/coder-with-mongosh:latest
          args:
          - --auth 
          - password
          env:
          - name: PASSWORD
            valueFrom:
              secretKeyRef:
                name: {{include "code-server.secret.name" .}}
                key: PASSWORD
          volumeMounts:
          - name: storage
            mountPath: /home/coder # saving home because we also need extensions and everything
      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: {{include "code-server.pvc.name" .}}

---

apiVersion: v1
kind: Service
metadata:
  name: {{include "code-server.name" .}}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{ include "code-server.name" .}}
  ports:
  - protocol: TCP
    port: 80
    targetPort: {{ include "code-server.port" . | int }}
  type: ClusterIP

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "code-server.pvc.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: {{.Values.codeServer.storage.size}}

  {{- if .Values.codeServer.storage.className }}
  storageClassName: {{.Values.codeServer.storage.className}}
  {{- end }}
  
---

{{- if .Values.codeServer.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "code-server.name" .}}
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    {{- if .Values.codeServer.ingress.tls.enabled }}
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.codeServer.ingress.tls.clusterIssuer}}
    {{- end }}
spec:
  {{- if .Values.codeServer.ingress.className }}
  ingressClassName: {{.Values.codeServer.ingress.className}}
  {{- end }}
  rules:
  - host: {{include "code-server.ingress.host" .}}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ include "code-server.name" .}}
            port:
              number: 80
  tls:
  - hosts:
    - {{include "code-server.ingress.host" .}}
    secretName: {{include "code-server.ingress.host" .}}-tls
{{- end }}

