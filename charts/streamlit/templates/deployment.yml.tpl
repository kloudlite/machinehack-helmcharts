apiVersion: apps/v1
kind: Deployment
metadata:
  name: streamlit
spec:
  selector:
    matchLabels:
      app: streamlit
  replicas: 1
  template:
    metadata:
      labels:
        app: streamlit
    spec:
      initContainers:
        - name: git
          image: alpine/git:latest
          imagePullPolicy: IfNotPresent
          securityContext:
            runAsUser: 1000
          command:
            - sh
            - -c
            - |
              if [ ! -d /app/ws/.git ]; then
                git clone --depth=1 --branch={{ .Values.streamlit.branch }} {{ .Values.streamlit.repository }} /app/ws;
              else
                echo "Directory /app/ws already exists, skipping clone.";
              fi
          volumeMounts:
          - name: storage
            mountPath: /app/ws
      containers:
      - name: streamlit
        image: ghcr.io/kloudlite/hub/streamlit-main:latest
        imagePullPolicy: Always
        {{ if .Values.streamlit.env }}
        env:
          {{- range .Values.streamlit.env }}
          - name: {{ .name }}
            value: {{ .value }}
          {{- end }}
        {{- end }}
        command:
          - bash
          - -c
          - |
            source /app/.venv/bin/activate
            pip install -r /app/ws/{{ .Values.streamlit.requirements }}
            streamlit run /app/ws/{{ .Values.streamlit.script }} --server.port 8080
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: storage
          mountPath: /app/ws
      volumes:
      - name: storage
        emptyDir: {}