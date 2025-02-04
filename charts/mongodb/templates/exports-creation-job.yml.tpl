apiVersion: batch/v1
kind: Job
metadata:
  name: {{.Release.Name}}-exports-create-job-{{randAlpha 5 | lower}}
  namespace: "kloudlite"
  annotations:
    "helm.sh/hook": post-install, post-upgrade
    {{- /* "helm.sh/hook-weight": "999999"  # Ensures it runs after lower-weight hooks */}}
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
              root_password=$(kubectl get secrets/{{.Release.Name}} -n {{.Release.Namespace}} -o json | jq -r '.data."mongodb-root-password"' | base64 -d)

              port=$(kubectl get svc/{{.Release.Name}}-nodeport -n {{.Release.Namespace}} -o json | jq '.spec.ports[] | select (.name == "{{.Release.Name}}") | .nodePort')

              cat <<EOF | kubectl apply -f -
              apiVersion: v1
              kind: Secret
              metadata:
                name: {{.Release.Name}}-exports
                namespace: {{.Release.Namespace}}
              stringData:
                MONGODB_USERNAME: "root"
                MONGODB_PASSWORD: "$root_password"
                MONGODB_URL: "mongodb://root:$root_password@{{.Values.mongodb.expose.host}}:$port"
              EOF
