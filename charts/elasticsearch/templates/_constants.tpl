{{- define "kibana.ingress.host" -}}{{required "A valid DNS Hostname must be provided, when ingress is enabled" .Values.ingress.host }} {{- end -}}

