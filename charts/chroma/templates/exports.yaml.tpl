apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  CHROMA_DB_URL: 'https://{{ .Release.Name }}.{{ .Values.base_host }}'
