{{- if .Values.airflow.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "airflow.name" .}}
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.airflow.ingress.clusterIssuer}}

    {{- if .Values.airflow.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ .Values.airflow.ingress.cors.origins | join "," | quote }}
    {{- end }}

spec:
  ingressClassName: {{ required "a valid ingress class name must be provided" .Values.airflow.ingress.className}}
  rules:
  - host: {{ .Values.airflow.ingress.host }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ include "airflow.name" .}}
            port:
              number: 80
  tls:
  - hosts:
    - {{ .Values.airflow.ingress.host }}
    secretName: {{ .Values.airflow.ingress.host }}-tls
{{- end }}
