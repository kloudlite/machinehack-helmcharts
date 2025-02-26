apiVersion: batch/v1
kind: Job
metadata:
  name: {{.Release.Name}}-exports-delete-job-{{randAlpha 5 | lower }}
  namespace: "kloudlite"
  annotations:
    "helm.sh/hook": post-delete
    "helm.sh/hook-delete-policy": before-hook-creation, hook-succeeded
spec:
  template:
    spec:
      restartPolicy: Never
      serviceAccountName: kloudlite-cluster-admin
      containers:
        - name: post-job
          image: ghcr.io/kloudlite/hub/kubectl:latest
          command: ["bash", "-c"]
          args:
            - |+
              kubectl delete secret/{{.Release.Name}}-exports -n {{.Release.Namespace}}
