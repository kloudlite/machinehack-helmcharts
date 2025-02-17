apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  # ElasticSearch Secrets
  {{- if .Values.elasticsearch.ingress.enabled }}
  {{- /* ELASTICSEARCH_URL: 'https://{{ include "elasticsearch.ingress.host" . }}' */}}

  KIBANA_URL: 'https://{{ include "elasticsearch.ingress.host" . }}'
  {{- end }}
