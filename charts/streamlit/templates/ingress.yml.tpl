apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: streamlit
  labels:
    app: streamlit
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.ingress.clusterIssuer}}
    {{- if .Values.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
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
    - {{ .Values.ingress.host }}
    secretName: {{ .Values.ingress.host }}-tls
  