{{- define "autogen-studio.name" -}} autogen-studio {{- end -}}
{{- define "autogen-studio.port" -}} 8080 {{- end -}}
{{- define "autogen-studio.secret.name" -}} code-creds {{- end -}}
{{- define "autogen-studio.secret.keys.password" -}} PASSWORD {{- end -}}
{{- define "autogen-studio.pvc.name" -}} code-storage {{- end -}}
{{- define "autogen-studio.ingress.host" -}} {{required "A valid DNS Hostname must be provided, when ingress is enabled" .Values.codeServer.ingress.host }} {{- end -}}
