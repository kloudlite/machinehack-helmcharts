apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  # Grafana Secrets
  GRAFANA_ADMIN_USER: '{{ .Values.grafana.adminUser | default "admin" }}'
  GRAFANA_ADMIN_PASSWORD: '{{ .Values.grafana.adminPassword | default "changeme" }}'
  {{- if .Values.grafana.ingress.enabled }}
  GRAFANA_URL: 'https://{{ include "grafana.ingress.host" . }}'
  {{- end }}