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
      - name: crewai
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        ports:
        - containerPort: 8000