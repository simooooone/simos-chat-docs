# AirGap AI Chatbot — Documentation Portal

## What This Is

A static documentation website for "AirGap AI Chatbot", built with MkDocs and the Material theme. The portal provides navigable, searchable documentation for the chatbot's procedures and APIs. Content is written in Markdown and distributed in two ways: online via Netlify for general consultation, and as a self-contained offline build for air-gapped infrastructure users who cannot access the internet.

## Core Value

Users in air-gapped environments must be able to consult complete, searchable documentation without any internet dependency — the offline build must be 100% equivalent to the online experience.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] MkDocs project initialized with Material theme and required plugins
- [ ] Bilingual documentation (English + Italian) via mkdocs-material[i18n] plugin
- [ ] Full navigation structure (tabs, sections, search, syntax-highlighted code blocks for APIs)
- [ ] Netlify deployment configured via netlify.toml
- [ ] CI/CD pipeline (GitHub Actions) for automatic deploy on push
- [ ] Offline build script producing a self-contained /site directory
- [ ] Clear instructions for building and deploying the offline (air-gapped) version

### Out of Scope

- Dynamic content or server-side rendering — static site only
- User authentication or access control on the documentation site — publicly accessible
- CMS or headless CMS integration — content lives in .md files in the repo
- Custom plugin development — use existing MkDocs/Material plugins only

## Context

- The AirGap AI Chatbot is an enterprise-grade, local-first, privacy-first AI chat workspace with RAG, RBAC, and full air-gap capability
- Documentation content will be created as new .md files (not converted from existing CLAUDE.md developer docs)
- The chatbot runs in a monorepo (pnpm + Turborepo) with server, frontend, collector, and shared packages
- Users in air-gapped environments cannot reach the internet, so the offline build must include search index and all assets

## Constraints

- **Tech Stack**: MkDocs + Material for MkDocs — mandatory, user-specified
- **Search**: Built-in MkDocs-Material search only (works offline without external service)
- **Bilingual**: English + Italian with i18n plugin — every page needs both language versions
- **Deploy**: Netlify for online — user-specified over GitHub Pages
- **Offline**: Static build (`mkdocs build`) producing portable /site directory — must work on file:// protocol
- **No external dependencies at runtime**: The offline site must not call CDNs, external fonts, or APIs

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| MkDocs over Docusaurus/Sphinx | Simpler setup, Material theme is best-in-class for search + offline, Python toolchain aligns with air-gap scripting | — Pending |
| Netlify over GitHub Pages | Richer deploy features, branch previews, simpler DNS | — Pending |
| i18n plugin for bilingual | Native Material theme integration, per-language search index, language switcher built-in | — Pending |
| Default Material theme | Clean, professional, no brand colors needed, works well offline | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-22 after initialization*