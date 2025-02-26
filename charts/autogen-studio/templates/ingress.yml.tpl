{{- if .Values.ingress.enabled }}

---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "autogen-studio.ingress.basic-auth.secret.name" . }}
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  {{- $username := include "autogen-studio.ingress.basic-auth.secret.data.username" . }}
  {{- $password := include "autogen-studio.ingress.basic-auth.secret.data.password" . }}
  USERNAME: {{ $username }}
  PASSWORD: {{ $password }}
  auth: {{ (htpasswd $username $password) | squote }}

---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "autogen-studio.name" .}}
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.ingress.clusterIssuer}}

    {{- if .Values.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ .Values.ingress.cors.origins | join "," | quote }}
    {{- end }}

    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: {{ include "autogen-studio.ingress.basic-auth.secret.name" . }}
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required - ok"

spec:
  ingressClassName: {{ required "a valid ingress class name must be provided" .Values.ingress.className}}
  rules:
  - host: {{ .Values.ingress.host | squote }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ include "autogen-studio.name" .}}
            port:
              number: 80
  tls:
  - hosts:
    - {{ .Values.ingress.host | squote }}
    secretName: {{ .Values.ingress.host }}-tls
{{- end }}
