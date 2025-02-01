{{- define "code-server.name" -}} code {{- end -}}
{{- define "code-server.port" -}} 8080 {{- end -}}
{{- define "code-server.secret.name" -}} code-creds {{- end -}}
{{- define "code-server.secret.keys.password" -}} PASSWORD {{- end -}}
{{- define "code-server.pvc.name" -}} code-storage {{- end -}}
{{- define "code-server.ingress.host" -}} {{required "A valid DNS Hostname must be provided, when ingress is enabled" .Values.codeServer.ingress.host }} {{- end -}}

{{- define "mongodb.name" -}} mongodb {{- end -}}
{{- define "mongodb.pvc.name" -}} mongodb-storage {{- end -}}
