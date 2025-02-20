{{- if .Values.ingress.enabled }}

---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "autogen-studio.name" . }}-basic-auth
  namespace: {{.Release.Namespace}}
type: Opaque
stringData:
  USERNAME: "autogenstudio"
  {{- $password := include "variables.kibana-basic-auth-password" . }}
  PASSWORD: {{ $password }}
  auth: {{ (htpasswd "kibana" $password) | squote }}

---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "autogen-sutdio.name" .}}
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
