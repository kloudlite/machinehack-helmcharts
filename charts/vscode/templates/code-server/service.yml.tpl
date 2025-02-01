apiVersion: v1
kind: Service
metadata:
  name: {{ include "code-server.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{ include "code-server.name" .}}
  ports:
  - protocol: TCP
    port: 80
    targetPort: {{ include "code-server.port" . | int }}
  type: ClusterIP

