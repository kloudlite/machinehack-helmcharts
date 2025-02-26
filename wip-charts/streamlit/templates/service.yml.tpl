apiVersion: v1
kind: Service
metadata:
  name: streamlit
  labels:
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
spec:
  selector:
    app: streamlit
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
    name: http