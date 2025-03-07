apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: 
  labels:
    app: chromadb
spec:
  ingressClassName: nginx
  rules:
    - host: {{ .Release.Name }}.{{ .Values.base_host }}
      http:
        paths:
          - path: /
            backend:
              serviceName: {{ Release.Name }}-chromadb
              servicePort: 8080