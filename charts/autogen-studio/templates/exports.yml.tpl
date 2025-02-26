apiVersion: v1
kind: Secret
metadata:
  name: "{{.Release.Name}}-exports"
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  USERNAME: {{ include "autogen-studio.ingress.basic-auth.secret.data.username" . }}
  PASSWORD: {{ include "autogen-studio.ingress.basic-auth.secret.data.password" . }}
  URL: https://{{ include "autogen-studio.ingress.basic-auth.secret.data.username" . }}:{{ include "autogen-studio.ingress.basic-auth.secret.data.password" . }}@{{ include "autogen-studio.ingress.host" . }}
