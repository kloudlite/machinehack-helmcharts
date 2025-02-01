apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  NOTEBOOK_TOKEN: '{{ include "variables.notebook-server-token" . }}'
  {{- if .Values.notebook.ingress.enabled }}
  NOTEBOOK_URL: 'https://{{ include "notebook.ingress.host" . }}'
  {{- end }}
