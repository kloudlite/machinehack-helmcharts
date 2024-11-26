{{- define "code-server.name" -}} code {{- end -}}
{{- define "code-server.port" -}} 8080 {{- end -}}
{{- define "code-server.secret.name" -}} code-creds {{- end -}}
{{- define "code-server.pvc.name" -}} code-storage {{- end -}}
{{- define "code-server.ingress.host" -}} {{.Release.Name}}.{{required "A valid DNS Hostname must be provided, when ingress is enabled" .Values.codeServer.ingress.hostSuffix }} {{- end -}}
