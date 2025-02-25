{{- if .Values.codeServer.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "code-server.name" .}}
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.codeServer.ingress.clusterIssuer}}

    {{- if .Values.codeServer.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ .Values.codeServer.ingress.cors.origins | join "," | quote }}
    {{- end }}

spec:
  ingressClassName: {{ required "a valid ingress class name must be provided" .Values.codeServer.ingress.className}}
  rules:
  - host: {{include "code-server.ingress.host" .}}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ include "code-server.name" .}}
            port:
              number: 80
  tls:
  - hosts:
    - {{include "code-server.ingress.host" .}}
    secretName: {{include "code-server.ingress.host" .}}-tls
{{- end }}
