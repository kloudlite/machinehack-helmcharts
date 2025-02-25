apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "code-server.pvc.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  accessModes:
  - ReadWriteOnce

  resources:
    requests:
      storage: {{.Values.codeServer.storage.size}}

  {{- if .Values.codeServer.storage.className }}
  storageClassName: {{.Values.codeServer.storage.className}}
  {{- end }}
  
