FROM node:22-bookworm

# Install developer tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    curl \
    wget \
    jq \
    tree \
    htop \
    tmux \
    ripgrep \
    fd-find \
    git \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw
RUN npm install -g openclaw@latest

# Copy config and entrypoint
COPY config/ /opt/openclaw-config/
COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

# Create data directory for volume mount
RUN mkdir -p /home/node/.openclaw && chown -R node:node /home/node/.openclaw

EXPOSE 18789

ENTRYPOINT ["/opt/start.sh"]
