apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
 # ElasticSearch Secrets
  ELASTIC_PASSWORD: '{{ .Values.security.elasticPassword | default "changeme" }}'
  {{- if .Values.elasticsearch.ingress.enabled }}
  ELASTICSEARCH_URL: 'https://{{ include "elasticsearch.ingress.host" . }}'
  {{- end }}