{{- if .Values.mongodb.enabled }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "mongodb.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .Values.mongodb.storage.size }}

  {{- if .Values.mongodb.storage.className }}
  storageClassName: {{.Values.mongodb.storage.className}}
  {{- end }}

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: &name {{ include "mongodb.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    matchLabels:
      mongodb: *name
  replicas: 1
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        mongodb: *name
    spec:
      nodeSelector: {{.Values.mongodb.nodeSelector | toJson }}
      tolerations: {{.Values.mongodb.tolerations | toJson }}
      securityContext:
        fsGroup: 1000
      containers:
        - name: mongodb
          image: mongo:4.4
          imagePullPolicy: IfNotPresent
          resources: {{ .Values.mongodb.resources | toJson }}
          ports:
          - containerPort: 27017
          volumeMounts:
          - name: mongodb
            mountPath: /data/db

      volumes:
      - name: mongodb
        persistentVolumeClaim:
          claimName: {{ include "mongodb.pvc.name" . }}

---

apiVersion: v1
kind: Service
metadata:
  name: {{ include "mongodb.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    mongodb: {{ include "mongodb.name" . }}
  ports:
    - name: mongodb
      protocol: TCP
      port: 27017
      targetPort: 27017
{{- end }}
