# CLAUDE.md — Server

Express API (port 3000). Auth, RBAC, agent orchestration, settings, webhooks, push notifications, backups, analytics, embed widget. Uses Prisma ORM.

## Structure

- **Routes**: `src/routes/` — one file per domain: auth (with `/auth/users` admin listing), users, roles (with `/roles/me/menu-sections`, `/roles/:id/menu-sections`), projects, workspaces, documents, agent, chat (streaming + rename + delete), apiKeys, eventLogs, analytics, backups, webhooks, push, license, sso, templates, settings, mcpConnections, embed (chat-based + workspace-based), health
- **Middleware**: `src/middleware/` — `auth.ts` (JWT + API key), `rbac.ts` (role/permission checks + IDOR prevention), `rateLimit.ts` (200/min general, 10/min auth), `license.ts` (feature flag gating: `requireFeature` for booleans, `requireFeatureLimit` for numeric limits)
- **Services**: `src/services/` — authService, apiKeyService, backupService (Bree scheduler), eventLogService (with webhook dispatch), ftsService (FTS5 full-text search), hybridSearchService (RRF merge), licenseService, systemConfigService, templateService, webhookService (HMAC-SHA256, retry with backoff, auto-disable)
- **Agent**: `src/agent/` — orchestrator (ReAct loop), builtinSkills (rag_search, workspace_memory, document_temp_process), llmStreaming (Ollama/OpenAI/Anthropic), mcpClient (outbound), mcpServer (inbound for IDEs)
- **Config**: `src/config/env.ts` — Zod-validated env vars via `getEnv()`

## Key Rules

### Prisma
- Always import from `../utils/prisma` (singleton), never `new PrismaClient()` directly.
- Prisma migrate reset requires `PRISMA_USER_CONSENT_FOR_DANGEROUS_AI_ACTION="yes"` in CI/automated contexts.

### Auth
- JWT tokens stored in localStorage on the frontend. `authMiddleware` validates Bearer tokens on server.
- `apiKeyMiddleware` validates `X-Api-Key` header with `sk-` prefix. Uses bcrypt prefix-based comparison for timing-attack resistance.

### RBAC & IDOR Prevention
- `requireProjectAccess` and `requireWorkspaceAccess` middleware verify the authenticated user owns or has been granted access to project/workspace resources. Applied on every relevant route.

### Rate Limiting
- General API: 200 req/min (prod) / 2000 req/min (dev).
- Auth endpoints: 10 req/min (prod) / 100 req/min (dev).

### Agent
- ReAct pattern in `src/agent/orchestrator.ts`. Skills registered in `builtinSkills.ts`.
- Skills are sandboxed — no arbitrary code execution. Only registered skills can be invoked.
- All skill execution goes through the RBAC-verified workspace context.

### Config Resolution
- **ALWAYS_READONLY keys** (`JWT_SECRET`, `DATABASE_URL`, `SERVER_PORT`, `COLLECTOR_PORT`, `SERVER_URL`, `COLLECTOR_URL`): ENV > Default, always `readOnly: true`
- **All other keys**: **DB > ENV > Default**, always `readOnly: false` (editable from UI). UI changes write to DB and take effect immediately.
- PUT `/api/system/settings` always returns 200 with `{ updated: [...], rejected: [...] }`. Even when some keys are rejected (readOnly), the successful ones are applied.

### Enterprise License
- JWT license key system signed with HS256. Verification uses `LICENSE_SECRET` if set (recommended), otherwise falls back to `LICENSE_KEY` (backward compat).
- Missing/invalid/expired key falls back to Community tier.
- **Graceful degradation**: `getLicenseInfo()` checks expiration at runtime. If an Enterprise license expires during server operation, it automatically degrades to Community tier — no restart needed.
- `requireFeature(flag)` middleware gates boolean enterprise features with HTTP 402. Currently enforced: `sso_enabled`, `webhooks`, `push_notifications`, `audit_log_immutable`, `custom_agents`.
- `requireFeatureLimit(flag, model)` middleware gates numeric limits with HTTP 402 when count >= limit. Currently enforced: `max_workspaces` on workspace creation, `max_projects` on project creation. Enterprise (Infinity) always passes. Fail-open on DB errors.
- `systemConfigService.updateSettings()` rejects `BRANDING_*` keys when `white_label` feature flag is false.
- Frontend `useFeature` hook and `useFeatureLimit` hook gate corresponding UI.

### Embed Widget
- **Chat-based**: `/api/embed/:chatId.js` (JS loader) + `/api/embed/:chatId` (self-contained HTML)
- **Workspace-based**: `/api/embed/workspace/:workspaceId.js` (JS loader) + `/api/embed/workspace/:workspaceId` (self-contained HTML with `?color=` param). Starts a new chat, no pre-existing chat required.

### Database
- SQLite (default) or PostgreSQL via Prisma. Schema in `prisma/schema.prisma`. Migrations in `prisma/migrations/`.
- The root `.env.example` has both SQLite and PostgreSQL `DATABASE_URL` examples. For local dev, create `packages/server/.env` with SQLite: `DATABASE_URL=file:./storage/data/simos-chat.db`

### RAG
- Hybrid search combining vector (LanceDB/Qdrant) + FTS5 keyword search, merged via Reciprocal Rank Fusion (k=60). Results tagged as `vector`, `fts`, or `both`.

### Chat Endpoints
- Two endpoints: `/api/workspaces/:id/chat` (non-streaming JSON) and `/api/workspaces/:id/chat/stream` (SSE streaming). Frontend uses the streaming endpoint by default.