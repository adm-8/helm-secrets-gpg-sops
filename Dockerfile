FROM ubuntu:24.04

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    gpg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update && apt-get install -y helm \
    && rm -rf /var/lib/apt/lists/*

# Install Helm Secrets plugin
RUN helm plugin install https://github.com/jkroepke/helm-secrets

# Install SOPS
RUN curl -L https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.linux.amd64 -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops

# Verify installations (optional)
RUN kubectl version --client && helm version && sops --version && gpg --version

CMD [ "bash" ]
