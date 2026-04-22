# Phase 1: Foundation - Context

**Gathered:** 2026-04-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Initialize MkDocs project with Material theme, pinned dependencies, bilingual directory structure, and core rendering features. The project must start and render locally with `mkdocs serve`, all plugins configured and working, and placeholder content files in place for both languages.

This phase delivers the skeleton — not the content (Phase 2), not the deployment (Phase 3), not the offline build (Phase 4).

</domain>

<decisions>
## Implementation Decisions

### Navigation structure
- **D-01:** Feature-area-based organization — sections organized by product area (Setup, Chat, Documents & RAG, Workspaces & Projects, Administration, API, Deployment, Security)
- **D-02:** 8 top-level nav sections, 2-3 levels deep maximum
- **D-03:** Navigation structure defined in mkdocs.yml `nav` with bilingual labels via `nav_translations`

### Theme & appearance
- **D-04:** Dark mode as default palette, with light mode toggle (suits developer/ops audience)
- **D-05:** Text/SVG logo placeholder in header — asset to be provided later
- **D-06:** Default Material theme (no custom brand colors beyond dark/light palette)

### Plugin configuration
- **D-07:** Explicit plugin load order in mkdocs.yml: i18n → search → (offline/privacy conditioned on `!ENV`). Prevents PIT-13 load-order conflicts.
- **D-08:** Separate per-language search indexes (en + it) with Italian stemming and `reconfigure_search: true`
- **D-09:** Print-to-PDF support enabled via Material `print` feature
- **D-10:** Announcement bar enabled (Material `announce` block) — placeholder content for Phase 2
- **D-11:** TOC sidebar on right for long pages (Material `toc` feature)
- **D-12:** Footer navigation with previous/next links enabled
- **D-13:** `!ENV [OFFLINE, false]` conditionals for privacy and offline plugins (NOT Insiders-only `group` plugin)
- **D-14:** `navigation.instant` explicitly excluded from mkdocs.yml (Fetch API fails on file:// protocol — PIT-03)

### Placeholder content
- **D-15:** Minimal stubs for .en.md/.it.md files: title + one-line description + "Content coming soon" note
- **D-16:** Each English stub must have a corresponding Italian stub (bilingual pairing enforced)

### Claude's Discretion
- Exact nav section labels and ordering (as long as they follow the feature-area pattern)
- Specific heading structure within minimal stubs
- Exact dark palette colors (Material defaults are fine)
- Plugin version pins beyond the requirements already specified

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project requirements
- `.planning/REQUIREMENTS.md` — 17 v1 requirements with REQ-IDs, Phase 1 covers FDN-01 through FDN-04
- `.planning/PROJECT.md` — Project vision, constraints, key decisions table
- `.planning/ROADMAP.md` — Phase 1 goal, success criteria, dependencies

### Pitfalls and constraints
- `.planning/research/PITFALLS.md` — 23 documented pitfalls; Phase 1 must address PIT-01 through PIT-05 and PIT-13
- `CLAUDE.md` — Technical constraints: MkDocs >=1.6,<2.0, mkdocs-static-i18n (not mkdocs-i18n), !ENV conditionals, no navigation.instant

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `docs/README.md` — Existing project README with feature descriptions (source for nav section naming)
- `docs/CLAUDE.md` — Architecture documentation (useful for API/admin section planning)
- `docs/packages/*/CLAUDE.md` — Package-specific docs (server, frontend, collector, shared)

### Established Patterns
- No existing MkDocs configuration — this is a greenfield setup
- No existing theme or style patterns to maintain consistency with

### Integration Points
- `mkdocs.yml` at project root — single config for both online and offline builds
- `requirements.txt` at project root — Python dependencies for both local dev and Netlify build
- `netlify.toml` at project root — Phase 3 will configure this
- `build-offline.sh` at project root — Phase 4 will create this
- `runtime.txt` at project root — Python version for Netlify (Phase 3)

</code_context>

<specifics>
## Specific Ideas

- Feature-area-based navigation matches how users of the chatbot would look up information: "I'm setting up workspaces" → Workspaces section, "I'm configuring RBAC" → Administration section
- Dark mode default aligns with developer/DevOps audience expectations
- 8 sections at 2-3 levels keeps the nav scannable without excessive nesting

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-foundation*
*Context gathered: 2026-04-22*