{{- define "notebook.name" -}} notebook {{- end -}}
{{- define "notebook.port" -}} 8888 {{- end -}}
{{- define "notebook.secret.name" -}} notebook-creds {{- end -}}
{{- define "notebook.secret.keys.jupyter-token" -}} JUPYTER_TOKEN {{- end -}}
{{- define "notebook.pvc.name" -}} notebook-storage {{- end -}}
{{- define "notebook.ingress.host" -}} {{required "A valid DNS Hostname must be provided, when ingress is enabled" .Values.notebook.ingress.host }} {{- end -}}

{{- define "mongodb.name" -}} mongodb {{- end -}}
{{- define "mongodb.pvc.name" -}} mongodb-storage {{- end -}}
