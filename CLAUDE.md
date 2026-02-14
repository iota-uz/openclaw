# OpenClaw — IOTA AI Gateway

## Project Purpose

This repo is a **Railway deployment template** for [OpenClaw](https://openclaw.ai), an open-source AI gateway. It provides the IOTA team with a shared AI engineering assistant accessible via:

- **Discord** — company server (mention-based in channels, DM allowlist)
- **Telegram** — group chats and DMs for team members
- **WebUI** — browser access with basic auth

### Goals

1. **Developer productivity** — code review, debugging, architecture guidance, repo navigation across all `iota-uz/*` repos
2. **Ops & monitoring** — deployment help, incident response, infrastructure troubleshooting on Railway/Docker/K8s
3. **Issue triage** — categorize, prioritize, and provide initial analysis on GitHub issues
4. **Onboarding** — help new team members understand the codebase, conventions, and module boundaries
5. **Architecture Q&A** — answer questions about system design, data flow, and module interactions across IOTA projects

### Non-goals

- This is NOT a customer-facing bot — it's internal tooling for the IOTA engineering team
- It does not run application code or serve production traffic

---

## Repository Structure

```
├── Dockerfile              # node:22-bookworm image with openclaw + dev tools
├── railway.toml            # Railway build/deploy configuration
├── start.sh                # Entrypoint: volume perms → first-boot seed → gateway launch
├── .dockerignore
├── config/                 # Seeded to volume on first boot only
│   ├── openclaw.json       # Gateway config (channels, auth, agents, model)
│   ├── .env.example        # Documents all required Railway secrets
│   ├── SOUL.md             # AI personality, guardrails, language rules
│   ├── USER.md             # IOTA org context, projects, tech stack
│   └── AGENTS.md           # OpenClaw agent definitions (separate from this file)
├── CLAUDE.md               # ← You are here (Claude Code project instructions)
├── AGENTS.md               # Symlink → CLAUDE.md
└── README.md               # Setup & deployment guide for humans
```

### Key files and what they control

| File | Purpose | When it changes |
|---|---|---|
| `Dockerfile` | Image build — openclaw install, dev tools, gh CLI | Adding/removing tools |
| `start.sh` | Runtime entrypoint — boot logic, env mapping | Changing startup behavior |
| `config/openclaw.json` | Channel config, model selection, auth | Adding channels, changing model, updating allowlists |
| `config/SOUL.md` | AI personality and guardrails | Tuning bot behavior |
| `config/USER.md` | Org context fed to the AI | Projects/stack changes |
| `railway.toml` | Railway deploy settings | Infra config changes |

---

## How It Works

1. **Build:** Railway builds the Docker image from `Dockerfile`
2. **First boot:** `start.sh` detects no config on the volume, copies `config/*` → `/home/node/.openclaw/`
3. **Subsequent boots:** Existing volume config is preserved — redeploys don't overwrite
4. **Runtime:** `openclaw gateway` binds to `0.0.0.0:$PORT`, connects to Discord/Telegram/WebUI
5. **Model:** Requests go to OpenRouter API (configured via `OPENROUTER_API_KEY`)

### Volume mount

- Path: `/home/node/.openclaw`
- Contains: `openclaw.json`, prompt files, SQLite (memory/sessions/state)
- **Persists across redeploys** — this is the source of truth at runtime

### Environment variables

All secrets are set in Railway dashboard, never in code. See `config/.env.example` for the full list.

---

## Working on This Repo

### Common tasks

- **Change the AI model:** Edit `config/openclaw.json` → `agents.default.model`
- **Add a Discord/Telegram user to allowlist:** Edit `config/openclaw.json` → channel allowlists
- **Update AI personality:** Edit `config/SOUL.md`
- **Update org context:** Edit `config/USER.md`
- **Add dev tools to the image:** Edit `Dockerfile` apt-get line
- **Change startup behavior:** Edit `start.sh`

### After editing config files

Config changes require either:
1. **Delete the Railway volume and redeploy** (re-seeds from `config/`)
2. **Edit directly on the volume** via `railway shell` (no redeploy needed, just restart)

### Conventions

- Keep `config/openclaw.json` free of actual secrets — use `${ENV_VAR}` references
- Placeholder IDs use `YOUR_*` prefix (e.g., `YOUR_DISCORD_GUILD_ID`)
- Shell scripts use `set -euo pipefail`
- Dockerfile follows node:22-bookworm base, runs as `node` user via `gosu`

---

## IOTA Organization Context

Full details are in `config/USER.md`, but here's what matters for navigation:

- **All repos live under `iota-uz/` on GitHub** — the bot has org-wide access via `GH_TOKEN`
- **Primary language is Go** with HTMX/Alpine.js frontends and PostgreSQL
- **IOTA-SDK** (`iota-uz/iota-sdk`) is the core framework — other projects depend on it
- **EAI** (`iota-uz/eai`) is a monorepo with Go backend (`back/`) and Next.js frontend (`app/`)
- **Shy ELD** (`iota-uz/shy-eld`) uses IOTA-SDK as a Go dependency
