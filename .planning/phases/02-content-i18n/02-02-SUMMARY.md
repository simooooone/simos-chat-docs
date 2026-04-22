---
phase: 02-content-i18n
plan: 02
subsystem: content
tags: [content, i18n, home-page, section-indexes, bilingual]
requires: [02-01]
provides: [home-pages, section-indexes, content-complete]
affects: [docs/index.en.md, docs/index.it.md, docs/*/index.en.md, docs/*/index.it.md]
tech_stack:
  added: []
  patterns: [inline-code-blocks, snippet-includes, admonition-tip, section-index-prose]
key_files:
  created: []
  modified:
    - docs/index.en.md
    - docs/index.it.md
    - docs/setup/index.en.md
    - docs/setup/index.it.md
    - docs/chat/index.en.md
    - docs/chat/index.it.md
    - docs/documents-rag/index.en.md
    - docs/documents-rag/index.it.md
    - docs/workspaces-projects/index.en.md
    - docs/workspaces-projects/index.it.md
    - docs/administration/index.en.md
    - docs/administration/index.it.md
    - docs/api/index.en.md
    - docs/api/index.it.md
    - docs/deployment/index.en.md
    - docs/deployment/index.it.md
    - docs/security/index.en.md
    - docs/security/index.it.md
decisions:
  - Home pages use inline code blocks and prose paragraphs instead of content tabs per D-02
  - Section indexes use 2-3 introductory paragraphs plus bulleted child links per D-03
  - Italian section titles follow nav_translations mapping (e.g., Setup becomes Installazione e configurazione)
  - Technical terms remain in English on Italian pages per D-06 (Docker, RAG, RBAC, API, workspace, deployment, GDPR)
metrics:
  duration: 11m
  completed: 2026-04-22
  tasks_completed: 2
  files_modified: 18
---

# Phase 2 Plan 02: Home Pages & Section Indexes Summary

Home pages rewritten with quick-start code, feature highlights, and section links; all 8 section index pairs completed with introductory prose and child-page links in both English and Italian.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Write home pages in English and Italian | b51fb38 | docs/index.en.md, docs/index.it.md |
| 2 | Write section index pages in English and Italian | 60253f1 | 16 section index files (8 EN + 8 IT) |

## Key Changes

### Home Pages (Task 1)

- Replaced stub content in both `docs/index.en.md` and `docs/index.it.md` with complete project overview
- Removed content tabs (`=== "Self-Hosted"` / `=== "Air-Gapped"` / `=== "RAG-Powered"`) per D-02
- Added quick-start code block inside `!!! tip` admonition
- Added 4 feature descriptions as prose paragraphs (self-hosted, air-gapped, RAG, workspace)
- Added 8 section links linking to each top-level section
- Included `--8<-- "_snippets/prereq-docker.md"` (EN) and `--8<-- "_snippets.it/prereq-docker.md"` (IT)
- Italian page mirrors English structure exactly per D-05

### Section Index Pages (Task 2)

All 8 section index pairs completed with 2-3 introductory paragraphs plus bulleted child-page links:

| Section | EN Title | IT Title | Children |
|---------|----------|----------|----------|
| Setup | Setup | Installazione e configurazione | Installation, Configuration |
| Chat | Chat | Chat | Getting Started, Features |
| Documents & RAG | Documents & RAG | Documenti e RAG | Uploading, Querying |
| Workspaces & Projects | Workspaces & Projects | Aree di lavoro e Progetti | Workspaces, Projects |
| Administration | Administration | Amministrazione | RBAC, Settings |
| API | API | API | Endpoints, Authentication |
| Deployment | Deployment | Distribuzione | Docker, Air-Gap Setup |
| Security | Security | Sicurezza | Overview, Compliance |

## Verification Results

- `mkdocs build --strict`: PASS (exit code 0)
- `bash scripts/check-bilingual-pairs.sh`: PASS (all pairs complete)
- No content tabs (`===`) in home pages: PASS
- All section indexes have introductory prose (not bare listings): PASS
- All internal links use `.md` extension: PASS
- Italian pages mirror English structure: PASS
- Technical terms stay in English on Italian pages (Docker, RAG, RBAC, API, workspace, deployment, GDPR): PASS

## Deviations from Plan

None -- plan executed exactly as written.

## Known Stubs

The following files still contain stub content (`*Content coming soon.*` or `*Contenuto in arrivo.*`), but these are child pages that are NOT in scope for this plan. They will be completed in Plans 02-03 and 02-04:

- `docs/setup/installation.{en,it}.md`
- `docs/setup/configuration.{en,it}.md`
- `docs/chat/getting-started.{en,it}.md`
- `docs/chat/features.{en,it}.md`
- `docs/documents-rag/uploading.{en,it}.md`
- `docs/documents-rag/querying.{en,it}.md`
- `docs/workspaces-projects/workspaces.{en,it}.md`
- `docs/workspaces-projects/projects.{en,it}.md`
- `docs/administration/rbac.{en,it}.md`
- `docs/administration/settings.{en,it}.md`
- `docs/api/endpoints.{en,it}.md`
- `docs/api/authentication.{en,it}.md`
- `docs/deployment/docker.{en,it}.md`
- `docs/deployment/air-gap.{en,it}.md`
- `docs/security/overview.{en,it}.md`
- `docs/security/compliance.{en,it}.md`

## Threat Flags

No new security-relevant surface introduced beyond what was in the plan's threat model.

## Self-Check: PASSED

- All 18 modified files exist on disk: VERIFIED
- Both task commits exist in git history (b51fb38, 60253f1): VERIFIED
- `mkdocs build --strict` passes with exit code 0: VERIFIED
- `bash scripts/check-bilingual-pairs.sh` reports PASS: VERIFIED