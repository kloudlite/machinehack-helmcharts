# templates/_helpers.tpl
{{/*
Expand the name of the chart.
*/}}
{{- define "chroma.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a fullname
*/}}
{{- define "chroma.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "chroma.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}
