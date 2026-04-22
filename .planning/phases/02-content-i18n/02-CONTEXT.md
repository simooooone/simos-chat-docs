# Phase 2: Content & i18n - Context

**Gathered:** 2026-04-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Write all documentation pages in both English and Italian, configure the language switcher with stay-on-page behavior, per-language search with Italian stemming, navigation with translated labels, and ensure all Material features (admonitions, content tabs, code copy) render identically in both languages.

This phase delivers the content — not the foundation (Phase 1, done), not the deployment (Phase 3), not the offline build (Phase 4).

</domain>

<decisions>
## Implementation Decisions

### Content depth & style
- **D-01:** Procedural guides — step-by-step instructions with code examples. Each page covers one task end-to-end. Target: thorough enough to accomplish the task, not so deep it becomes a reference manual.
- **D-02:** Inline code blocks for examples — not tabbed alternatives. Show one approach per code snippet. Users copy-paste and adapt. This halves the translation burden vs. tabbed alternatives.
- **D-03:** Section index pages serve as introductory landing pages — 2-3 paragraphs introducing the topic, plus links to child pages. Not bare link listings.
- **D-04:** Home page (index.en.md / index.it.md) remains the project overview with quick-start code, feature highlights, and links into each section.

### Translation approach
- **D-05:** Strict structural mirror — Italian pages mirror English exactly: same headings, same sections, same order. Differences only where Italian grammar requires rephrasing. This keeps parity easy to verify.
- **D-06:** Technical terms kept in English in Italian pages (API, Docker, RBAC, RAG, workspace, deployment, etc.). Standard practice in Italian tech documentation — readers expect these terms untranslated.

### Announce bar
- **D-07:** Bilingual version notice — English shows "v1 Documentation — Getting started with AirGap AI Chatbot" linking to Chat/Getting Started. Italian shows "Documentazione v1 — Inizia con AirGap AI Chatbot" linking to the Italian equivalent. Must be implemented in `docs/overrides/main.html` with `{% block announce %}` and `i18n_current_language` conditional (Material theme uses a block, not a partial include).

### Content patterns & reuse
- **D-08:** Standardized admonition set across all pages: `!!! note` for information, `!!! warning` for cautions, `!!! tip` for recommendations, `!!! danger` for destructive actions. Consistent use makes pages predictable and easier to translate.
- **D-09:** Shared snippets via `pymdownx.snippets` for repeated content (prerequisite steps, common API base URLs, standard disclaimers). Define once in a `docs/_snippets/` directory, include via `--8<--` syntax. Translated snippets go in `docs/_snippets.it/` (or suffix convention matching i18n pattern).

### Claude's Discretion
- Exact wording and tone of procedural steps (as long as they follow the procedural-guide pattern)
- Specific code examples and their content (as long as they're inline blocks showing one approach)
- Exact Italian translations of non-technical prose (as long as they mirror English structure)
- Snippet file organization within `docs/_snippets/`
- Section index page introductory content specifics

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project requirements
- `.planning/REQUIREMENTS.md` — 17 v1 requirements; Phase 2 covers CNT-01 through CNT-05
- `.planning/PROJECT.md` — Project vision, constraints, key decisions table
- `.planning/ROADMAP.md` — Phase 2 goal, success criteria, dependencies

### Prior phase context
- `.planning/phases/01-foundation/01-CONTEXT.md` — Phase 1 decisions that constrain Phase 2 (nav structure, i18n config, plugin order, suffix convention)

### Technical constraints
- `CLAUDE.md` — MkDocs >=1.6,<2.0, mkdocs-static-i18n (not mkdocs-i18n), !ENV conditionals, no navigation.instant
- `mkdocs.yml` — Current configuration with plugin settings, nav structure, extensions

### Pitfalls
- `.planning/research/PITFALLS.md` — 23 documented pitfalls; Phase 2 must address search-related and i18n pitfalls

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `mkdocs.yml` — Fully configured with i18n plugin, search, nav structure, extensions. Phase 2 only needs content changes and announce bar update.
- `docs/overrides/partials/announce.html` — Placeholder announce bar; needs bilingual content.
- All 20 bilingual page pairs exist as stubs in `docs/` — ready for content replacement.
- `pymdownx.snippets` extension already configured in mkdocs.yml — ready for shared snippet use.

### Established Patterns
- `.en.md`/`.it.md` suffix convention for bilingual pages (established in Phase 1)
- Navigation structure: 8 sections (Setup, Chat, Documents & RAG, Workspaces & Projects, Administration, API, Deployment, Security) — defined in mkdocs.yml nav
- `nav_translations` already has Italian labels for all 8 sections — may need child-page label additions

### Integration Points
- `docs/_snippets/` — New directory for shared content snippets (not yet created)
- `mkdocs.yml` → `extra.alternate` — Language switcher links (already configured but may need refinement for stay-on-page behavior)
- `mkdocs.yml` → `plugins.i18n.languages[1].nav_translations` — May need additional Italian labels for new sub-nav items

</code_context>

<specifics>
## Specific Ideas

- Procedural guide pattern matches the chatbot's audience: admins and devs who need to accomplish specific tasks (install, configure, deploy, secure)
- Strict structural mirror between English and Italian minimizes sync drift — when English gets updated, it's obvious what the Italian page needs
- Keeping tech terms in English is the Italian tech-doc standard — readers would find translated terms like "spazio di lavoro" confusing when the product UI says "Workspace"
- Shared snippets reduce translation cost: translate a prerequisite block once, include it in 5 pages

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 02-content-i18n*
*Context gathered: 2026-04-22*