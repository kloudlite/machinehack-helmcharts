FROM ghcr.io/kloudlite/hub/coder-with-mongosh:latest
RUN sudo apt update
RUN sudo apt install -y python3 python3-pip python3.11-venv
RUN touch /home/coder/.bashrc
RUN echo "alias python=python3" >> /home/coder/.bashrc