---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "notebook.secret.name" . }}
  namespace: {{.Release.Namespace}}
type: Opaque
data:
  {{ include "notebook.secret.keys.jupyter-token" . }}: {{ include "variables.notebook-server-token" . | b64enc }}
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: &name {{include "notebook.name" .}}
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
      securityContext:
        fsGroup: 1000

      nodeSelector: {{.Values.notebook.nodeSelector | toJson }}
      tolerations: {{.Values.notebook.tolerations | toJson }}

      hostname: "workspace"
      containers:
        - name: notebook
          image: jupyter/base-notebook:latest
          env:
            - name: JUPYTER_TOKEN
              valueFrom:
                secretKeyRef:
                  name: {{include "notebook.secret.name" .}}
                  key: {{ include "notebook.secret.keys.jupyter-token" . }}

          resources: {{ .Values.notebook.resources | toJson }}

          volumeMounts:
          - name: storage
            mountPath: /home/jovyan/work
      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: {{include "notebook.pvc.name" .}}

---

apiVersion: v1
kind: Service
metadata:
  name: {{include "notebook.name" .}}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{ include "notebook.name" .}}
  ports:
  - protocol: TCP
    port: 80
    targetPort: {{ include "notebook.port" . | int }}
  type: ClusterIP

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "notebook.pvc.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: {{.Values.notebook.storage.size}}

  {{- if .Values.notebook.storage.className }}
  storageClassName: {{.Values.notebook.storage.className}}
  {{- end }}
  
---

{{- if .Values.notebook.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "notebook.name" .}}
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.notebook.ingress.clusterIssuer}}

    {{- if .Values.notebook.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ .Values.notebook.ingress.cors.origins | join "," | quote }}
    {{- end }}

spec:
  ingressClassName: {{ required "a valid ingress classname must be set" .Values.notebook.ingress.className }}
  rules:
  - host: {{include "notebook.ingress.host" .}}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ include "notebook.name" .}}
            port:
              number: 80
  tls:
  - hosts:
    - {{include "notebook.ingress.host" .}}
    secretName: {{include "notebook.ingress.host" .}}-tls
{{- end }}

