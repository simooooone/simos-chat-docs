# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-22)

**Core value:** Users in air-gapped environments must be able to consult complete, searchable documentation without any internet dependency
**Current focus:** Phase 2: Content & i18n

## Current Position

Phase: 2 of 4 (Content & i18n) — In Progress
Plan: 2 of 4 in current phase
Status: Plan 02-02 completed — home pages and section indexes written
Last activity: 2026-04-22 -- Plan 02-02 completed

Progress: [#####.....] 50%

## Performance Metrics

**Velocity:**
- Total plans completed: 2
- Average duration: --
- Total execution time: 0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 2 | 2 | 11m | 5.5m |

**Recent Trend:**
- Last 5 plans: 02-01, 02-02
- Trend: Steady

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- MkDocs >=1.6,<2.0 pin enforced (v2 breaks Material plugin system)
- !ENV conditionals for offline/privacy plugins instead of Insiders-only group plugin
- navigation.instant excluded (Fetch API fails on file:// protocol)
- mkdocs-static-i18n==1.3.1 for bilingual (not mkdocs-i18n)
- Netlify over GitHub Pages (richer deploy features, branch previews)
- Home pages use inline code blocks and prose paragraphs instead of content tabs (D-02)
- Section indexes use 2-3 introductory paragraphs plus bulleted child links (D-03)
- Italian section titles follow nav_translations mapping (Setup -> Installazione e configurazione)
- Technical terms remain in English on Italian pages (Docker, RAG, RBAC, API, workspace, deployment, GDPR)

### Pending Todos

None yet.

### Blockers/Concerns

- Phase 4 (Offline Distribution): offline plugin iframe-worker shim and file:// protocol compatibility varies across browsers -- requires hands-on validation during execution
- Phase 4 (Offline Distribution): privacy plugin must be audited to confirm it captures ALL external assets, not just Google Fonts
- Phase 2 (Content & i18n): nav_translations mechanism needs testing with actual nav structure to confirm all labels are translated

## Deferred Items

| Category | Item | Status | Deferred At |
|----------|------|--------|-------------|
| *(none)* | | | |

## Session Continuity

Last session: 2026-04-22
Stopped at: Completed 02-02-PLAN.md
Resume file: .planning/phases/02-content-i18n/02-02-SUMMARY.md