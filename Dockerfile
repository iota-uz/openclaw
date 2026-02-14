FROM node:22-bookworm

# Install system tools
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
    neovim \
    && rm -rf /var/lib/apt/lists/*

# Install Go 1.24.10 (matches iota-sdk go.mod)
RUN curl -fsSL https://go.dev/dl/go1.24.10.linux-amd64.tar.gz | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"
ENV GOPATH="/root/go"

# Install Go dev tools (versions from iota-sdk)
RUN go install github.com/a-h/templ/cmd/templ@v0.3.857 \
    && go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.6.2 \
    && go install golang.org/x/tools/cmd/goimports@latest \
    && go install github.com/99designs/gqlgen@v0.17.57

# Install yq 4.52.4
RUN curl -fsSL https://github.com/mikefarah/yq/releases/download/v4.52.4/yq_linux_amd64 -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

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
RUN npm install -g openclaw@2026.2.13

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code@2.1.42

# Install pnpm 9.15.0 (matches iota-sdk package.json)
RUN npm install -g pnpm@9.15.0

# Install Railway CLI
RUN npm install -g @railway/cli@4.30.2

# Install Playwright CLI + Chromium with system deps + skills
RUN npm install -g @playwright/cli@0.1.0 \
    && npx playwright install chromium --with-deps \
    && playwright-cli install --skills

# Make Go tools available to node user
RUN cp /root/go/bin/* /usr/local/bin/

# Create Claude Code config directory for node user
RUN mkdir -p /home/node/.claude && chown -R node:node /home/node/.claude

# Copy config and entrypoint
COPY config/ /opt/openclaw-config/
COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

# Create data directory for volume mount
RUN mkdir -p /home/node/.openclaw && chown -R node:node /home/node/.openclaw

EXPOSE 18789

ENTRYPOINT ["/opt/start.sh"]
