apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
# MongoDB Secrets
  MONGODB_USERNAME: '{{ .Values.mongodb.auth.username | default "admin" }}'
  MONGODB_PASSWORD: '{{ .Values.mongodb.auth.password | default "changeme" }}'
  {{- if .Values.mongodb.ingress.enabled }}
  MONGODB_URL: 'mongodb://{{ include "mongodb.ingress.host" . }}'
  {{- end }}