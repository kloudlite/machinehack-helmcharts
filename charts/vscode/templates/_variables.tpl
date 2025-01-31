{{- /* info must be extracted into a library */}}
{{- define "secret.get_or_generate_value" }}
{{- $global := (index .  0)}}
{{- $secretNamespace := index . 1}}
{{- $secretName := (index . 2) }}
{{- $secretKey := (index . 3) }}

{{- if not $global.Values.variables }}
{{- $_ := set $global.Values "variables" dict }}
{{- end }}

{{- $varName := printf "%s/%s" $secretNamespace $secretName }}

{{- $val := (index $global.Values.variables $varName) }}
{{- if $val }}
  {{- $val }}
{{- else}}
  {{- if not $global.Release.IsUpgrade }}
    {{- $val := (randAlphaNum 29) }}
    {{- $_ := set $global.Values.variables $varName $val }}
    {{- $val }}
  {{- else }}
    {{- $data := (lookup "v1" "Secret" $secretNamespace $secretName).data }}
    {{- if not $data }}
      {{- $val := (randAlphaNum 29) }}
      {{- $_ := set $global.Values.variables $varName $val }}
      {{- $val }}
    {{- else }}
      {{- $val := index $data $secretKey | b64dec }}
      {{- $_ := set $global.Values.variables $varName $val }}
      {{- $val }}
    {{- end }}
  {{- end }}
{{- end }}

{{- end }}

{{- define "variables.code-server-password" }}
{{- include "secret.get_or_generate_value" (list . .Release.Namespace (include "code-server.secret.name" .) (include "code-server.secret.keys.password" .)) }}
{{- end }}
