apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}-nodeport
  namespace: {{.Release.Namespace}}
spec:
  type: NodePort
  ports:
  - name: {{.Release.Name}}
    port: 5432
    protocol: TCP
    targetPort: tcp-{{.Release.Name}}
  selector:
    app.kubernetes.io/instance: {{.Release.Name}}
    app.kubernetes.io/name: {{.Release.Name}}
