apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{.Release.Name}}
  namespace: {{.Release.Namespace}}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{.Release.Name}}
  template:
    metadata:
      labels:
        app: {{.Release.Name}}
    spec:
      containers:
        - name: n8n
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: 5678
          env:
            {{- range .Values.env }}
            - name: {{ .name }}
              value: "{{ .value }}"
            {{- end }}