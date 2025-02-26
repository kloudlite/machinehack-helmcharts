apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: streamlit
  labels:
    app: streamlit
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
spec:
  rules:
    - host: {{ .Values.ingress.host }}
      http:
        paths:
          - path: /
            backend:
              serviceName: streamlit
              servicePort: 8080