apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{.Release.Name}}-nginx
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
  type: ClusterIP
