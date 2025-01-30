---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "code-server.secret.name" . }}
  namespace: {{.Release.Namespace}}
type: Opaque
data:
  {{ include "code-server.secret.keys.password" . }}: {{ include "variables.code-server-password" . | b64enc }}

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: &name {{ include "code-server.name" . }}
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

      nodeSelector: {{ .Values.codeServer.nodeSelector | toJson }}
      tolerations: {{ .Values.codeServer.tolerations | toJson  }}

      securityContext:
        fsGroup: 1000

      {{- if .Values.codeServer.extensions }}
      initContainers:
        - name: install-plugins
          image: ghcr.io/kloudlite/hub/coder-with-mongosh:latest
          imagePullPolicy: IfNotPresent
          env:
            # INFO: these 2 env vars are needed for plugins to be installed
            - name: SERVICE_URL
              value: https://open-vsx.org/vscode/gallery

            - name: ITEM_URL
              value: https://open-vsx.org/vscode/item
          command:
            - bash
            - -c
            - |
              mkdir -p /home/coder/workspace

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
          workingDir: /home/coder/workspace
          env:
            # INFO: these 2 env vars are needed for plugins to be installed
            - name: SERVICE_URL
              value: https://open-vsx.org/vscode/gallery

            - name: ITEM_URL
              value: https://open-vsx.org/vscode/item

            - name: PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{include "code-server.secret.name" .}}
                  key: {{ include "code-server.secret.keys.password" . }}
          resources: {{ .Values.codeServer.resources | toJson }}
          volumeMounts:
          - name: storage
            mountPath: /home/coder # saving home because we also need extensions and everything

      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: {{include "code-server.pvc.name" .}}

