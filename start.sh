#!/bin/bash
set -euo pipefail

OPENCLAW_HOME="/home/node/.openclaw"

# Fix volume permissions (Railway volumes mount as root)
chown -R node:node "$OPENCLAW_HOME"

# First-boot: seed config if not present
if [ ! -f "$OPENCLAW_HOME/openclaw.json" ]; then
    echo "[openclaw] First boot detected — seeding config from /opt/openclaw-config/"
    gosu node cp -rn /opt/openclaw-config/* "$OPENCLAW_HOME/"
    echo "[openclaw] Config seeded successfully."
else
    echo "[openclaw] Existing config found — skipping seed."
fi

# Map Railway's PORT env var to OpenClaw's gateway port
export OPENCLAW_GATEWAY_PORT="${PORT:-18789}"
export OPENCLAW_GATEWAY_HOST="0.0.0.0"

# Configure GitHub CLI auth if token is available
if [ -n "${GH_TOKEN:-}" ]; then
    echo "[openclaw] Configuring GitHub CLI auth..."
    gosu node bash -c "echo '$GH_TOKEN' | gh auth login --with-token 2>/dev/null || true"
fi

echo "[openclaw] Starting gateway on ${OPENCLAW_GATEWAY_HOST}:${OPENCLAW_GATEWAY_PORT}"

# Drop to node user and start gateway
exec gosu node openclaw gateway
