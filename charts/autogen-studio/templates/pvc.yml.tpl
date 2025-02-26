apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "autogen-studio.pvc.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: {{.Values.storage.size}}