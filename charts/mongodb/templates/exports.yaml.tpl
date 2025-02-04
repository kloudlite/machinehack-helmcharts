apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  MONGODB_USERNAME: 'root'
  MONGODB_PASSWORD: {{ .Values.mongodb.auth.rootPassword | squote}}
