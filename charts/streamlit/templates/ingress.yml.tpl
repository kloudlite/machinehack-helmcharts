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
  ingressClassName: nginx
  rules:
    - host: {{ .Values.ingress.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: streamlit
                port:
                  name: http
  tls:
  - hosts:
    secretName: {{ .Values.ingress.host }}-tls
  