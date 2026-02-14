# Organization: IOTA

Website: https://www.iota.uz/

Software development company based in Tashkent, Uzbekistan. Builds ERP and CRM systems for Finance, Insurance, Logistics, Healthcare, Retail, and Manufacturing sectors.

## Projects

### 1. IOTA-SDK (`iota-uz/iota-sdk`)

Open-source modular ERP framework — an alternative to SAP, Oracle, and Odoo.

- **Backend:** Go 1.23.2, Templ (Go templating), GraphQL (gqlgen)
- **Frontend:** HTMX, Alpine.js, Tailwind CSS
- **Database:** PostgreSQL (jmoiron/sqlx), Redis
- **Auth:** JWT, OAuth2
- **Architecture:** Module-based — core, finance, warehouse, CRM, HRM modules
- **Features:** i18n support, file uploads, WebSocket, Excel export/import

### 2. EuroAsiaInsurance (EAI) Platform (`iota-uz/eai`)

Complete digital solution for insurance company operations. Monorepo structure:

- **`back/`** — Backend API and admin panel
  - Go 1.23.2, GraphQL, Templ, HTMX
  - Integrations: Twilio (SMS), PostHog (analytics), OpenAI
  - Infrastructure: PostgreSQL, Redis, Docker

- **`app/`** — Customer-facing web application
  - Next.js 15, TypeScript, React 19
  - State: Apollo Client (GraphQL), TanStack Query
  - UI: Tailwind CSS, Radix UI, Tiptap editor
  - Analytics: PostHog, Google Analytics

- **`iota-uz/eai-mobile`** — Mobile app
  - React Native, TypeScript (iOS + Android)

### 3. Shy ELD (`iota-uz/shy-eld`)

ERP for transportation and fleet management companies.

- **Backend:** Go 1.23.2, uses IOTA-SDK as dependency
- **Frontend:** Templ, HTMX, Tailwind CSS
- **Database:** PostgreSQL
- **Payments:** Stripe integration
- **Modules:** Logistics management, driver tracking, ELD integration, billing
- **Features:** Excel import/export, multi-tenant support

## Tech Stack Summary

| Layer | Technologies |
|---|---|
| Backend | Go (primary), GraphQL (gqlgen), REST APIs |
| Frontend (admin) | HTMX, Alpine.js, Tailwind CSS |
| Frontend (customer) | Next.js, React, TypeScript |
| Templating | Templ (Go), JSX (React) |
| Databases | PostgreSQL, Redis |
| Infrastructure | Docker, Kubernetes, Railway |
| Integrations | Stripe, Twilio, OpenAI, PostHog |
| Auth | JWT, OAuth2 |

## Coding Standards

- Go code follows standard `gofmt` formatting
- Error handling: always check and propagate errors, no silent swallowing
- SQL: use parameterized queries, never string concatenation
- Commits: conventional commits format (`feat:`, `fix:`, `chore:`, etc.)
- GraphQL schemas defined with gqlgen, code-first approach

## Glossary

- **TG** — Telegram
- **GM** — Google Meet
- **GH** — GitHub
- **CC** — Claude Code
