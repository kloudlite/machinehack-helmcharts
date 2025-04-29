# templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "chroma.fullname" . }}
  labels:
    app: {{ include "chroma.name" . }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "chroma.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "chroma.name" . }}
    spec:
      containers:
        - name: chroma
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}
          volumeMounts:
            {{- if .Values.persistence.enabled }}
            - mountPath: /chroma/chroma
              name: chroma-storage
            {{- end }}
      volumes:
        {{- if .Values.persistence.enabled }}
        - name: chroma-storage
          persistentVolumeClaim:
            claimName: {{ include "chroma.fullname" . }}-pvc
        {{- end }}
