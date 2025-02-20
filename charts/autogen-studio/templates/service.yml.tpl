apiVersion: v1
kind: Service
metadata:
  name: {{ include "autogen-studio.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{ include "autogen-studio.name" .}}
  ports:
  - protocol: TCP
    port: 80
    targetPort: {{ include "autogen-studio.port" . | int }}
  type: ClusterIP

