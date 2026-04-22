# CLAUDE.md — Root

Enterprise-grade, local-first, privacy-first AI chat workspace with RAG, RBAC, and full air-gap capability. Monorepo: `pnpm` + Turborepo.

## Commands

```bash
pnpm dev                  # Start all services (server :3000, frontend :5173, collector :3210)
pnpm build                # Production build all packages
pnpm typecheck            # TypeScript checking across all packages
pnpm lint                 # ESLint across all packages
pnpm test                 # Jest test suites
pnpm db:generate          # Regenerate Prisma client
pnpm db:migrate           # Apply migrations (interactive)
pnpm db:seed              # Seed default roles, permissions, templates, config
docker compose -f docker/docker-compose.yml up --build -d
docker compose -f docker/docker-compose.yml --profile enterprise up --build -d  # PostgreSQL
```

## Architecture

### Package Dependency Graph

```text
shared ← server
shared ← collector
shared ← frontend
```

**Strict modularity**: Never import `server` code into `collector` or vice versa. Communicate via HTTP APIs or use `shared` for types. The dependency graph is unidirectional — `shared` is the only cross-package import.

### Data Flow

```text
Frontend → :5173 → Vite proxy /api → Server :3000
Server → Agent Orchestrator → LLM (Ollama/OpenAI/Anthropic)
Server → Agent → rag_search → Vector DB + FTS5 (hybrid RRF)
Server → Agent → workspace_memory → SystemConfig (SQLite)
Server → Agent → document_temp_process → Collector :3210
Server → Agent → MCP tools → External MCP servers
Server → Collector :3210 → Parse → Chunk → Embed → Store
Server → SSE stream → Frontend (token-by-token chat)
Server → Webhook dispatch → External HTTP endpoints
Server → Push notification → Browser (VAPID Web Push)
```

## Global Coding Standards

- **Validation**: Define request schemas in `packages/shared/src/schemas/` using Zod. Validate in both server and collector.
- **No phantom dependencies**: If a package is used, it must be declared in that module's `package.json`. pnpm strictness enforces this.
- **API responses**: Consistent `{ error: string }` for errors, entity objects for success.
- **Streaming responses**: SSE format (`text/event-stream`). Events: `token`, `status`, `citations`, `done`, `error`.
- **Soft deletes**: Projects, workspaces, and documents use soft deletes (boolean flag), not hard deletes.
- **`.env` location**: Server and collector load `.env` from `process.cwd()`, NOT the monorepo root. Create `packages/server/.env` and `packages/collector/.env` for local dev.

## RBAC & Security (Cross-Cutting)

- **Admin role**: All 16 permissions + all menu sections.
- **Superuser role**: All 16 permissions + all menu sections except `settings`.
- **User role**: Limited permissions (`workspace:read`, `chat:read`, `chat:write`, `document:read`, `project:create`, `workspace:create`) + menu sections: `chat`, `documents`, `createWorkspace`.
- **Menu sections**: 7 sections control sidebar visibility: `chat`, `documents`, `createWorkspace`, `projects`, `eventLog`, `analytics`, `settings`. Per-role via `RoleMenuSection` model.
- **Registration gating**: `ALLOW_REGISTRATION` env var — `true` for open signup, `false` for admin-only creation.
- **Feature flags**: `license.ts` middleware gates enterprise features behind `LICENSE_KEY` + `LICENSE_SECRET`. Enforced features: SSO (`sso_enabled`), webhooks (`webhooks`), push notifications (`push_notifications`), immutable audit logs (`audit_log_immutable`), custom agent config (`custom_agents`), white-label branding (`white_label` — enforced at settings level by rejecting `BRANDING_*` keys). Numeric limits: `max_workspaces` (default 3) and `max_projects` (default 3) enforced on creation routes via `requireFeatureLimit`. Graceful degradation: expired Enterprise licenses automatically revert to Community at runtime.

## Package-Specific Directives

See each package's own `CLAUDE.md` for domain-specific rules:
- [`packages/server/CLAUDE.md`](packages/server/CLAUDE.md) — Backend: Express, Prisma, Agent, Auth, RBAC
- [`packages/frontend/CLAUDE.md`](packages/frontend/CLAUDE.md) — Frontend: React, Vite, Tailwind, SSE streaming
- [`packages/collector/CLAUDE.md`](packages/collector/CLAUDE.md) — Document ingestion: parse, chunk, embed, store
- [`packages/shared/CLAUDE.md`](packages/shared/CLAUDE.md) — Shared kernel: types, schemas, constants