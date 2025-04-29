apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
  labels:
    app: {{ .Release.Name }}
spec:
  type: {{ .Values.service.type }}
  selector:
    app: {{ .Release.Name }}
  ports:
  {{- range .Values.service.ports }}
    - name: {{ .name }}
      protocol: TCP
      port: {{ .port }}
      targetPort: {{ .targetPort }}
  {{- end }}
