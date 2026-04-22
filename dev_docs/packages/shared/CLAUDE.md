# CLAUDE.md — Shared

TypeScript types, Zod schemas, constants. No runtime dependencies. Both `server` and `collector` import from here.

## Structure

- **Types**: `src/types/index.ts` — shared TypeScript interfaces and type definitions
- **Schemas**: `src/schemas/` — Zod validation schemas: auth, project, workspace, chat, document, config, role, license, entity
- **Constants**: `src/constants/` — `permissions.ts` (RBAC permission definitions), `license.ts` (feature flags, tier defaults, license payload schema), `index.ts`

## Key Rules

### No Business Logic
- This package contains **only** types, schemas, and constants.
- Never add business logic, runtime dependencies, or side effects here.
- If it needs to `import` anything beyond `zod`, it probably doesn't belong in shared.

### Schema Design
- All request/response validation schemas must be defined here, not in server or collector.
- Both server and collector import schemas from this package for validation consistency.

### No Circular Dependencies
- Shared is the leaf node in the dependency graph — it must not import from server, collector, or frontend.
- The dependency direction is always: `server → shared`, `collector → shared`, `frontend → shared`.

### Feature Flags
- `license.ts` exports `FEATURE_FLAGS` (readonly tuple of all 9 flag keys), `FeatureFlag` type, `COMMUNITY_FEATURE_DEFAULTS`, `ENTERPRISE_FEATURE_DEFAULTS`, `LICENSE_TIERS`, `LicenseTier` type, and `licensePayloadSchema` (Zod schema for JWT payload validation).
- Complete flag list: `sso_enabled`, `audit_log_immutable`, `white_label`, `max_workspaces`, `max_projects`, `priority_support`, `custom_agents`, `webhooks`, `push_notifications`.
- Boolean flags: all except `max_workspaces` and `max_projects` (which are numeric).
- Community defaults: all booleans `false`, numerics `3`. Enterprise defaults: all booleans `true`, numerics `Infinity`.