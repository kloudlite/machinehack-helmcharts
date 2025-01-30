{{- define "variables.code-server-password" }}
{{- include "secret.get_or_generate_value" (list . .Release.Namespace (include "code-server.secret.name" .) (include "code-server.secret.keys.password" .)) }}
{{- end }}
