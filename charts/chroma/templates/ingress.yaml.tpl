apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: 
  labels:
    app: chromadb
spec:
  ingressClassName: nginx
  rules:
    - host: {{ .Values.ingress.host }}
      http:
        paths:
          - path: /
            backend:
              serviceName: {{ Release.Name }}-chromadb
              servicePort: 8080