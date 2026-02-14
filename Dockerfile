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
RUN npm install -g openclaw@2026.2.13

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code@2.1.42

# Install Playwright CLI + Chromium with system deps + skills
RUN npm install -g @playwright/cli@0.1.0 \
    && npx playwright install chromium --with-deps \
    && playwright-cli install --skills

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
