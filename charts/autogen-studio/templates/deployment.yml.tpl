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
  name: &name {{ include "autogen-studio.name" . }}
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

      containers:
        - name: code-server
          image: ghcr.io/kloudlite/hub/autogen-studio:latest
          args:
          - --port 
          - {{ include "autogen-studio.port" .  | squote }}
          - appdir
          - /app
          workingDir: /app
          env:
            # INFO: these 2 env vars are needed for plugins to be installed
            - name: OPENAI_API_KEY
              value: {{ .Values.OPENAI_API_KEY | squote }}

          resources: {{ .Values.resources | toJson }}
          volumeMounts:
          - name: storage
            mountPath: /home/coder # saving home because we also need extensions and everything

      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: {{include "code-server.pvc.name" .}}

