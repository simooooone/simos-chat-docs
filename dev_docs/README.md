# Simos Chat

Enterprise-grade, local-first, privacy-first AI chat workspace with RAG, RBAC, and full air-gap capability.

> AI ChatBot and RAG for strict data residency, offline operation, and fine-grained access control.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Local-First & Air-Gapped** | Runs fully offline with Ollama, LanceDB, and Xenova embeddings — no cloud dependencies required |
| **RAG Pipeline** | Upload PDF/MD/CSV/DOCX/XLSX/PPTX, YouTube transcripts; auto-chunk, embed, and query with hybrid search (vector + FTS5) with source citations |
| **ReAct Agent** | Reason-then-act agent with built-in skills (`rag_search`, `workspace_memory`, `document_temp_process`) and pluggable MCP tools |
| **Streaming Chat** | SSE token-by-token streaming with abort support, status messages during tool execution, and citation badges |
| **RBAC** | Role-Based Access Control with admin/user roles, custom permissions, and workspace-level access grants |
| **Registration Gating** | `ALLOW_REGISTRATION` env var: open signup or admin-only user creation |
| **System Settings with ENV Override** | Configure via UI or ENV — ENV values are always `readOnly` in the API |
| **Document Status Tracking** | Real-time upload progress: pending → processing → completed/failed |
| **Workspace Templates** | Industry vertical presets (Legal, Medical, General) with constraint enforcement |
| **MCP Integration** | Bidirectional: expose RAG via MCP for IDEs, or connect external MCP servers as agent skills |
| **Embed Widget** | Iframe or script-based embeddable chat widgets for external websites — workspace-based (no pre-existing chat required) or chat-based |
| **API Keys** | Programmatic access with `sk-` prefixed keys, expiry, and revocation |
| **Event Logging** | Audit trail for all significant actions with webhook auto-dispatch |
| **Analytics** | Token usage dashboards: daily usage, by model, top users |
| **Backups** | Scheduled (Bree) and on-demand backups with database, documents, and vectors components |
| **Webhooks & Push Notifications** | Real-time event delivery via HMAC-signed HTTP webhooks and VAPID Web Push API |
| **Enterprise License** | Feature-flagged tier system (Community vs. Enterprise) — enforced: SSO, webhooks, push notifications, immutable audit logs, white-label branding, custom agent config, workspace/project limits |
| **OCR Support** | Tesseract.js for image-based PDFs and scanned documents |
| **i18n** | Multi-language UI: English, Italian, Russian |

---

## Architecture

```text
simos-chat-improved/
├── packages/
│   ├── server/       Express API — auth, RBAC, agent orchestration, settings, webhooks, push, backups, analytics, embed (chat + workspace)
│   ├── frontend/     Vite + React 19 SPA — Tailwind CSS, no SSR
│   ├── collector/    Document ingestion microservice — parse, chunk, embed, store
│   └── shared/       TypeScript interfaces, Zod schemas, constants
├── docker/           Docker Compose + multi-stage Dockerfiles + Nginx config
└── prisma/           Database schema (SQLite default, PostgreSQL enterprise)
```

**Data flow:**

```text
Frontend ──► Server API ──► Agent Orchestrator ──► LLM (Ollama/OpenAI/Anthropic)
                │                   │
                │                   ├── rag_search ──► Vector DB + FTS5 (hybrid RRF)
                │                   ├── workspace_memory ──► SQLite
                │                   ├── document_temp_process ──► Collector
                │                   └── MCP tools ──► External servers
                │
                ├──► Collector ──► Parse ──► Chunk ──► Embed ──► Store
                ├──► SSE Stream ──► Frontend (token-by-token)
                ├──► Webhook ──► External HTTP (HMAC-SHA256 signed)
                └──► Push ──► Browser (VAPID Web Push)
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Node.js, Express, Prisma ORM |
| **Frontend** | React 19, Vite 6, Tailwind CSS 3, react-router-dom |
| **State Management** | Zustand 5 (6 stores) |
| **Database** | SQLite (default, air-gapped) / PostgreSQL (enterprise) |
| **Vector DB** | LanceDB (local) / Qdrant (enterprise) |
| **Embeddings** | Xenova/Transformers (local) / OpenAI (cloud) |
| **LLM** | Ollama (local) / OpenAI / Anthropic |
| **Auth** | JWT with bcrypt, API keys (`sk-` prefix), RBAC middleware |
| **Validation** | Zod (shared schemas across server + collector) |
| **Streaming** | SSE via `@microsoft/fetch-event-source` |
| **Rendering** | markdown-it + highlight.js + DOMPurify |
| **Monorepo** | pnpm workspaces + Turborepo |
| **Desktop** | Tauri (optional) |

---

## Quick Start

### Prerequisites

- **Node.js** >= 24.0.0
- **pnpm** 9.15.5 (`corepack enable && corepack prepare pnpm@9.15.5 --activate`)
- **Ollama** for local LLMs — install from https://ollama.com, then `ollama pull llama3`
- **Docker** (optional, for production)

### 1. Install

```bash
git clone <repo-url> && cd simos-chat-improved
pnpm install
```

### 2. Configure

```bash
cp .env.example .env
# Edit .env — at minimum, set JWT_SECRET:
#   JWT_SECRET=$(openssl rand -hex 32)
```

> **Note:** Server loads `.env` from `packages/server/`, not the monorepo root. For local dev, create `packages/server/.env`.

### 3. Initialize Database

```bash
pnpm db:generate   # Generate Prisma client
pnpm db:migrate    # Create SQLite DB and apply schema
pnpm db:seed       # (Optional) Seed demo data + default roles
```

### 4. Start

```bash
# All services in one terminal:
pnpm dev

# Or start individually:
pnpm --filter server dev     # http://localhost:3000
pnpm --filter collector dev  # http://localhost:3210
pnpm --filter frontend dev  # http://localhost:5173
```

### 5. Use

Open **http://localhost:5173** — register your admin account (registration is open by default), then start chatting.

---

## Docker Deployment

```bash
# Production (single command)
docker compose -f docker/docker-compose.yml up --build -d

# Development with hot-reload
docker compose -f docker/docker-compose.yml -f docker/docker-compose.dev.yml up --build

# Enterprise mode (PostgreSQL)
docker compose -f docker/docker-compose.yml --profile enterprise up --build -d
```

Set `DATABASE_URL=postgresql://simoschat:simoschat@postgres:5432/simoschat` for PostgreSQL.

In Docker, use `COLLECTOR_URL=http://collector:3210` and `OLLAMA_BASE_URL=http://host.docker.internal:11434`.

---

## Configuration

Environment variables and database settings are resolved based on key type:

```text
Infrastructure keys (JWT_SECRET, DATABASE_URL, etc.): ENV (readOnly) > Default
All other keys: DB setting (editable via UI) > ENV > Default
```

| Variable | Default | Description |
|----------|---------|-------------|
| `JWT_SECRET` | **required** | Token signing key |
| `SESSION_EXPIRY` | `86400000` (24h) | JWT session expiry in milliseconds |
| `SERVER_PORT` | `3000` | API server port |
| `COLLECTOR_URL` | `http://localhost:3210` | Collector endpoint |
| `DATABASE_URL` | `file:./storage/data/simos-chat.db` | SQLite or PostgreSQL URL |
| `LLM_PROVIDER` | `ollama` | `ollama`, `openai`, or `anthropic` |
| `LLM_MODEL` | `llama3` | Model identifier |
| `LLM_API_KEY` | — | API key for cloud providers |
| `LLM_TEMPERATURE` | `0.7` | Model creativity (0–2) |
| `LLM_MAX_TOKENS` | `4096` | Max response tokens |
| `EMBEDDING_PROVIDER` | `local` | `local` (Xenova) or `openai` |
| `EMBEDDING_MODEL` | `Xenova/all-MiniLM-L6-v2` | Embedding model |
| `VECTOR_DB_PROVIDER` | `lancedb` | `lancedb` or `qdrant` |
| `ALLOW_REGISTRATION` | `true` | Allow open sign-ups |
| `LICENSE_KEY` | — | JWT Enterprise license key |
| `LICENSE_SECRET` | — | Separate signing secret for JWT license verification (recommended) |

See [.env.example](.env.example) for the full list.

---

## Project Structure

```text
packages/
├── server/
│   ├── src/
│   │   ├── routes/          # Express route handlers (auth, users, roles, projects, workspaces, documents, agent, chat, apiKeys, eventLogs, analytics, backups, webhooks, push, license, sso, templates, settings, mcpConnections, embed, health)
│   │   ├── services/        # Business logic (auth, apiKey, backup, eventLog, fts, hybridSearch, license, systemConfig, template, webhook)
│   │   ├── middleware/      # Auth (JWT + API key), RBAC (+ IDOR prevention), rate limit, license/feature flags
│   │   ├── agent/          # ReAct orchestrator, builtin skills, LLM streaming (3 providers), MCP client/server
│   │   └── config/         # Zod-validated env vars
│   └── prisma/
│       ├── schema.prisma    # Full data model (RBAC + domain + agent + enterprise)
│       └── seed.ts          # Default roles, templates, config
├── frontend/
│   └── src/
│       ├── components/      # React components (LoginPage, ChatPanel, DocumentsPage, SettingsPage, etc.)
│       ├── stores/          # Zustand stores (auth, chat, settings, toast, license, theme)
│       ├── hooks/           # useChat (SSE streaming), useFeature (license gating)
│       ├── i18n/            # Translations (en, it, ru)
│       └── utils/           # API client, helpers
├── collector/
│   └── src/
│       ├── routes/          # Ingest endpoints (upload, query, YouTube)
│       ├── services/        # Parser (PDF, DOCX, XLSX, PPTX, YouTube, OCR), chunker, embeddings, vector store
│       └── config/          # Environment config
└── shared/
    └── src/
        ├── types/            # TypeScript interfaces
        ├── schemas/          # Zod validation schemas
        └── constants/        # Permissions, defaults, feature flags
```

---

## Document Formats

| Format | Extensions | Processing |
|--------|-----------|------------|
| PDF | `.pdf` | Text extraction + OCR (Tesseract.js, if template requires) |
| Markdown | `.md` | Direct parsing |
| Plain Text | `.txt` | Direct parsing |
| CSV | `.csv` | Tabular parsing |
| Word | `.docx` | mammoth library |
| Excel | `.xlsx` | node-xlsx library |
| PowerPoint | `.pptx` | officeparser library |
| YouTube | URL | Transcript extraction via youtube-transcript-plus |

Max file size: **100 MB**.

---

## Documentation

| Document | Description |
|----------|-------------|
| [STARTUP_GUIDE.md](docs/STARTUP_GUIDE.md) | Installation, Docker, environment variables, troubleshooting |
| [USAGE_GUIDE.md](docs/USAGE_GUIDE.md) | Full feature guide — auth, workspaces, RAG, RBAC, API reference |
| [API_USAGE_GUIDE.md](docs/API_USAGE_GUIDE.md) | API reference and usage examples |

---

## Common Commands

```bash
pnpm dev           # Start all services in dev mode
pnpm build         # Production build for all packages
pnpm typecheck     # TypeScript type checking
pnpm lint          # ESLint across all packages
pnpm test          # Run test suites
pnpm db:generate   # Regenerate Prisma client
pnpm db:migrate    # Apply database migrations
pnpm db:seed       # Seed default data (roles, templates, config)
```

---

## License

This project is licensed under the terms described in [LICENSE](LICENSE).