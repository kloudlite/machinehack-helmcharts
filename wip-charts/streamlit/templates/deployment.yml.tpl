apiVersion: apps/v1
kind: Deployment
metadata:
  name: streamlit
  labels:
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
spec:
  selector:
    matchLabels:
      app: streamlit
  replicas: 1
  template:
    metadata:
      labels:
        app: streamlit
    spec:
      containers:
      - name: streamlit
        image: "{{ .Values.image }}"
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080