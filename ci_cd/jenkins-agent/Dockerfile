FROM jenkins/agent:jdk11

USER root
RUN apt update && apt install --no-install-recommends -y gettext jq && \
    curl -fsSL https://get.docker.com/ | sh && \
    usermod -aG docker jenkins && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    rm -rf /var/lib/apt/lists/*
USER jenkins
