apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{.Release.Name}}
  namespace: {{.Release.Namespace}}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{.Release.Name}}-apache
  template:
    metadata:
      labels:
        app: {{.Release.Name}}-apache
    spec:
      containers:
      - name: apache
        image: httpd:latest
        ports:
        - containerPort: 80
