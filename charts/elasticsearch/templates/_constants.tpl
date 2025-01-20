{{- define "kibana.ingress.host" -}} kibana-{{.Release.Name}}.{{required "A valid DNS Hostname must be provided, when ingress is enabled" .Values.ingress.hostSuffix }} {{- end -}}

