{{- define "autogen-studio.name" -}} autogen-studio {{- end -}}
{{- define "autogen-studio.port" -}} 8080 {{- end -}}
{{- define "autogen-studio.pvc.name" -}} code-storage {{- end -}}
{{- define "autogen-studio.ingress.host" -}} {{required "A valid DNS Hostname must be provided, when ingress is enabled" .Values.ingress.host }} {{- end -}}
{{- define "autogen-studio.ingress.basic-auth.secret.name" -}} {{ include "autogen-studio.name" . }}-basic-auth {{- end -}}
{{- define "autogen-studio.ingress.basic-auth.secret.keys.password" -}} PASSWORD {{- end -}}

{{- define "autogen-studio.ingress.basic-auth.secret.data.username" -}} autogen-studio {{- end -}}

{{- define "autogen-studio.ingress.basic-auth.secret.data.password" }}
{{- include "secret.get_or_generate_value" 
  (list 
    .
    .Release.Namespace
    (include "autogen-studio.ingress.basic-auth.secret.name" .)
    (include "autogen-studio.ingress.basic-auth.secret.keys.password" .)
  ) 
}}
{{- end }}
