apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
 # Playground Secrets
  PLAYGROUND_TOKEN: '{{ include "variables.playground-server-token" . }}'
  {{- if .Values.playground.ingress.enabled }}
  PLAYGROUND_URL: 'https://{{ include "playground.ingress.host" . }}'
  {{- end }}