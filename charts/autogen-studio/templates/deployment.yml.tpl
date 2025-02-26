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
      hostname: "autogen-studio"

      nodeSelector: {{ .Values.nodeSelector | toJson }}
      tolerations: {{ .Values.tolerations | toJson  }}

      securityContext:
        fsGroup: 1000

      containers:
        - name: autogen-studio
          image: ghcr.io/kloudlite/hub/autogen-studio:latest
          args:
          - --port 
          - {{ include "autogen-studio.port" .  | squote }}
          - --appdir
          - /app
          workingDir: /app
          env:
            - name: OPENAI_API_KEY
              value: {{ .Values.OPENAI_API_KEY | squote }}

          resources: {{ .Values.resources | toJson }}
          volumeMounts:
          - name: storage
            mountPath: /app # saving home because we also need extensions and everything

      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: {{include "autogen-studio.pvc.name" .}}

