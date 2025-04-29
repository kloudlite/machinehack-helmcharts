apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{.Release.Name}}-apache
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
