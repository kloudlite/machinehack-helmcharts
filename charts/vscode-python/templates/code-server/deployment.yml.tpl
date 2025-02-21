---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "code-server.secret.name" . }}
  namespace: {{.Release.Namespace}}
type: Opaque
data:
  {{ include "code-server.secret.keys.password" . }}: {{ include "variables.code-server-password" . | b64enc }}

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: &name {{ include "code-server.name" . }}
  namespace: {{.Release.Namespace}}
  labels:
    app: *name
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: *name
  template:
    metadata:
      labels:
        app: *name
    spec:
      hostname: "workspace"

      nodeSelector: {{ .Values.codeServer.nodeSelector | toJson }}
      tolerations: {{ .Values.codeServer.tolerations | toJson  }}

      securityContext:
        fsGroup: 1000

      initContainers:
        - name: clone-code
          image: alpine/git:latest
          imagePullPolicy: IfNotPresent
            command:
            - sh
            - -c
            - |
              if [ ! -d /home/coder/workspace ]; then
                git clone --depth=1 --branch={{ .Values.codeServer.branch }} {{ .Values.codeServer.repository }} /home/coder/workspace;
              else
                echo "Directory /home/coder/workspace already exists, skipping clone.";
              fi
          volumeMounts:
            - name: storage
              mountPath: /home/coder
        - name: setup-python
          image: python:3.9
          imagePullPolicy: IfNotPresent
          command:
            - bash
            - -c
            - |
              python3 -m venv /home/coder/workspace/.venv
              source /home/coder/workspace/.venv/bin/activate
              pip install -U pip
              pip install -r /home/coder/workspace/requirements.txt
          volumeMounts:
            - name: storage
              mountPath: /home/coder
        - name: install-plugins
          image: ghcr.io/kloudlite/hub/coder-with-mongosh:latest
          imagePullPolicy: IfNotPresent
          env:
            # INFO: these 2 env vars are needed for plugins to be installed
            - name: SERVICE_URL
              value: https://open-vsx.org/vscode/gallery

            - name: ITEM_URL
              value: https://open-vsx.org/vscode/item
          command:
            - bash
            - -c
            - |
              pids=()
              {{- range .Values.codeServer.extensions }}
              code-server --install-extension {{.}} &
              pids+=($!)
              {{- end }}
              wait ${pids[@]}
          volumeMounts:
            - name: storage
              mountPath: /home/coder

      containers:
        - name: code-server
          image: ghcr.io/kloudlite/hub/coder-with-mongosh:latest
          command:
            - bash
            - -c
            - |
              apt install -y python3
              source /home/coder/workspace/.venv/bin/activate
              code-server --auth password
          workingDir: /home/coder/workspace

          args:
          - --auth 
          - password
          workingDir: /home/coder/workspace
          env:
            # INFO: these 2 env vars are needed for plugins to be installed
            - name: SERVICE_URL
              value: https://open-vsx.org/vscode/gallery

            - name: ITEM_URL
              value: https://open-vsx.org/vscode/item

            - name: PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{include "code-server.secret.name" .}}
                  key: {{ include "code-server.secret.keys.password" . }}
          resources: {{ .Values.codeServer.resources | toJson }}
          volumeMounts:
          - name: storage
            mountPath: /home/coder # saving home because we also need extensions and everything

      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: {{include "code-server.pvc.name" .}}

