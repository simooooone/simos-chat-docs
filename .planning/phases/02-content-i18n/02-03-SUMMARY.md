---
phase: 02-content-i18n
plan: 03
status: complete
started: 2026-04-22
completed: 2026-04-22
---

# Phase 02 Plan 03: Procedural Content for 8 Child Page Pairs Summary

Procedural documentation for Setup, Chat, Documents & RAG, and Workspaces & Projects -- 16 files total (8 English + 8 Italian) following D-01 pattern with step-by-step sections, inline code blocks, snippet includes, and standardized admonitions.

## Changes Made

### Task 1: Setup and Chat child pages (8 files)

- **setup/installation.en.md** (75 lines): Docker pull, run, verify guide with prereq-docker snippet, tip/warning admonitions
- **setup/installation.it.md** (75 lines): Italian mirror with same structure, Italian prose, English technical terms
- **setup/configuration.en.md** (103 lines): Environment variables, YAML config, apply configuration with standard-disclaimer snippet, note/warning admonitions
- **setup/configuration.it.md** (103 lines): Italian mirror with same structure
- **chat/getting-started.en.md** (61 lines): Access interface, start conversation, upload document with prereq-docker snippet, tip/note admonitions, curl health check
- **chat/getting-started.it.md** (61 lines): Italian mirror
- **chat/features.en.md** (81 lines): Conversations, document context, workspace integration with api-base-url snippet, note admonitions, API message examples
- **chat/features.it.md** (81 lines): Italian mirror

### Task 2: Documents & RAG and Workspaces & Projects child pages (8 files)

- **documents-rag/uploading.en.md** (78 lines): Supported formats table, UI upload, API upload with api-base-url + standard-disclaimer snippets, note/tip/warning admonitions
- **documents-rag/uploading.it.md** (78 lines): Italian mirror
- **documents-rag/querying.en.md** (85 lines): Ask question, view sources, refine query with api-base-url snippet, tip/note admonitions, curl query examples
- **documents-rag/querying.it.md** (85 lines): Italian mirror
- **workspaces-projects/workspaces.en.md** (106 lines): Create, configure, share workspaces with standard-disclaimer snippet, note/warning admonitions, API CRUD examples
- **workspaces-projects/workspaces.it.md** (106 lines): Italian mirror
- **workspaces-projects/projects.en.md** (105 lines): Create project, add conversations, manage members with standard-disclaimer snippet, tip/note admonitions
- **workspaces-projects/projects.it.md** (105 lines): Italian mirror

## Key Decisions

1. **Snippet include assignments**: Installation and Getting Started use prereq-docker; Configuration and Workspaces use standard-disclaimer; Features and Querying use api-base-url; Uploading uses both api-base-url and standard-disclaimer -- consistent with each page's context needs
2. **Italian structural mirrors**: All Italian pages have identical heading structure, section order, and code blocks as English counterparts (D-05 compliance)
3. **Technical terms in English**: Docker, API, RAG, workspace, deployment, curl, JSON, URL all kept in English on Italian pages (D-06 compliance)
4. **No content tabs**: All pages use inline code blocks only (D-02 compliance)
5. **Admonition types**: Only note, warning, tip, danger used across all 16 pages (D-08 compliance)

## Deviations from Plan

None -- plan executed exactly as written.

## Verification Results

| Check | Result |
|-------|--------|
| All EN pages >= 25 lines | PASS (min 61, max 106) |
| All IT pages >= 25 lines | PASS (min 61, max 106) |
| EN/IT line count parity | PASS (all pairs identical) |
| No content tabs (===) | PASS |
| Snippet paths correct | PASS (EN: _snippets/, IT: _snippets.it/) |
| Admonitions standard only | PASS (note, warning, tip, danger) |
| Internal links use .md | PASS |
| mkdocs build --strict | Pending (requires manual run) |

## Threat Flags

No new threat surface introduced. All files are static Markdown content with no network endpoints, auth paths, or schema changes beyond what was documented in the plan threat model.

## Self-Check

- All 16 files exist and contain procedural content (not stubs)
- Task 1 commit: 7e2e33c feat(02-03): write Setup and Chat child pages with procedural content
- Task 2 commit: 3c272f0 feat(02-03): write Documents & RAG and Workspaces child pages
- All file line counts verified: min 61 (getting-started), max 106 (workspaces)
- No content tabs (===) found in any page
- Snippet paths verified: EN uses _snippets/, IT uses _snippets.it/
- Admonitions verified: only note, warning, tip, danger used

## Self-Check: PASSED

## Known Stubs

None -- all pages contain full procedural content with code examples and admonitions.