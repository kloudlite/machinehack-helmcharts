apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}-nodeport
  namespace: {{.Release.Namespace}}
spec:
  type: NodePort
  ports:
  - name: {{.Release.Name}}
    port: 3306
    protocol: TCP
    targetPort: mysql
  selector:
    app.kubernetes.io/instance: {{.Release.Name}}
    app.kubernetes.io/name: {{.Release.Name}}

