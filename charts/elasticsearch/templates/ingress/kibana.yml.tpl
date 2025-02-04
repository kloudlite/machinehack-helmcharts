---
apiVersion: v1
kind: Secret
metadata:
  name: kibana-basic-auth
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  USERNAME: "kibana"
  {{- if not .Release.IsUpgrade }}
  {{- $password := randAlphaNum 29 }}
  PASSWORD: {{ $password | squote }}
  auth: {{ (htpasswd "kibana" $password) | squote }}
  {{- else }}
  PASSWORD:  {{ index (lookup "v1" "Secret" .Release.Namespace "kibana-basic-auth").data "PASSWORD" | b64dec }}
  auth:  {{ index (lookup "v1" "Secret" .Release.Namespace "kibana-basic-auth").data "auth" | b64dec }}
  {{- end }}

---

{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kibana
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    {{- if .Values.ingress.tls.enabled }}
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.ingress.tls.clusterIssuer}}
    {{- end }}

    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: kibana-basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required - ok"

    {{- if .Values.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ .Values.ingress.cors.origins | join "," | quote }}
    {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{.Values.ingress.className}}
  {{- end }}
  rules:
  - host: {{include "kibana.ingress.host" .}}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: "{{.Release.Name}}-kibana"
            port:
              number: 5601
  tls:
  - hosts:
    - {{include "kibana.ingress.host" .}}
    secretName: {{include "kibana.ingress.host" .}}-tls
{{- end }}
