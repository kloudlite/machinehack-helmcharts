{{- define "variables.notebook-server-token" }}
{{- include "secret.get_or_generate_value" (list . .Release.Namespace (include "notebook.secret.name" .) (include "notebook.secret.keys.jupyter-token" .)) }}
{{- end }}
