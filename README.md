# OpenClaw — iota.uz AI Gateway

Self-hosted AI gateway deployed on Railway. Serves as a shared engineering assistant across Discord, Telegram, and WebUI.

## Quick Start

### 1. Fork / Clone

```bash
gh repo clone iota-uz/openclaw
```

### 2. Configure

Edit `config/openclaw.json` and fill in:
- Discord Guild ID and user allowlist IDs
- Telegram group chat IDs and user allowlist IDs

### 3. Deploy to Railway

1. Create a new project on [Railway](https://railway.com)
2. Connect the `iota-uz/openclaw` GitHub repo
3. Add a **volume**:
   - Name: `openclaw-data`
   - Mount path: `/home/node/.openclaw`
4. Set **environment variables** (see below)
5. Push to `main` — Railway auto-deploys via GitHub webhook

### 4. Set Environment Variables

| Variable | Required | Description |
|---|---|---|
| `OPENROUTER_API_KEY` | Yes | OpenRouter API key |
| `DISCORD_BOT_TOKEN` | Yes | Discord bot token |
| `TELEGRAM_BOT_TOKEN` | Yes | Telegram bot token |
| `OPENCLAW_GATEWAY_TOKEN` | Yes | Gateway auth token (`openssl rand -hex 32`) |
| `GH_TOKEN` | Yes | GitHub PAT scoped to `iota-uz` org |
| `AUTH_USERNAME` | Recommended | WebUI login username |
| `AUTH_PASSWORD` | Recommended | WebUI login password |
| `CLAUDE_CODE_OAUTH_TOKEN` | Optional | OAuth token from Claude Max subscription |

## Architecture

```
Railway
├── OpenClaw Gateway (port 18789)
│   ├── WebUI (browser access with auth)
│   ├── Discord channel (bot in guild + DMs)
│   └── Telegram channel (groups + DMs)
├── Volume: /home/node/.openclaw
│   ├── openclaw.json (config)
│   ├── SOUL.md, USER.md, AGENTS.md
│   └── SQLite (memory, sessions, state)
└── OpenRouter API (model provider)
```

## Configuration

All config lives in `config/` and gets seeded to the volume on first boot. After that, the volume copy is authoritative — redeploys won't overwrite your runtime config.

### Changing Config After Deploy

SSH into the Railway service or use the Railway CLI:
```bash
railway shell
# Edit config directly on the volume
vi ~/.openclaw/openclaw.json
# Restart the service to apply
```

Or update `config/openclaw.json` in the repo, delete the volume, and redeploy to re-seed.

## Getting IDs

### Discord Guild ID
Server Settings → Widget → Server ID, or run:
```bash
# With the bot token
curl -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
  https://discord.com/api/v10/users/@me/guilds | jq '.[].id'
```

### Telegram Chat IDs
Add the bot to your group, send a message, then:
```bash
curl "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates" | jq '.result[].message.chat.id'
```

### Telegram User IDs
Message the bot directly, then use the same `getUpdates` call.

## Development

Build locally:
```bash
docker build -t openclaw .
docker run --env-file .env -p 18789:18789 -v openclaw-data:/home/node/.openclaw openclaw
```
