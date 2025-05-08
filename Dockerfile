FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    gnupg2 \
    gpg \
    lsb-release \
    apt-transport-https \
    git

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Helm Secrets plugin
RUN helm plugin install https://github.com/jkroepke/helm-secrets

# Install SOPS
RUN curl -L https://github.com/mozilla/sops/releases/latest/download/sops-linux-amd64 -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops

# Optional: Add kubectl if you need it in the same image
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

ENTRYPOINT ["/bin/bash"]
