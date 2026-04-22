---
phase: 2
slug: content-i18n
status: draft
shadcn_initialized: false
preset: none
created: 2026-04-22
---

# Phase 2 -- UI Design Contract

> Visual and interaction contract for the Content & i18n phase. This is an MkDocs Material static documentation site -- the contract covers content patterns, i18n template logic, and theme configuration rather than custom components. Phase 1 UI-SPEC established the foundation; this contract extends it with content authoring and i18n specifics.

---

## Design System

| Property | Value |
|----------|-------|
| Tool | none (MkDocs Material theme -- not a component library project) |
| Preset | not applicable |
| Component library | none (Material theme provides all UI primitives) |
| Icon library | Material Icons (bundled with mkdocs-material) |
| Font | Roboto (text), Roboto Mono (code) -- Material defaults |

Inherits from Phase 1 UI-SPEC: indigo primary/accent palette, slate/default dark/light schemes, Material theme spacing and typography defaults. No changes to the design system foundation.

**Changes from Phase 1:**
- Adds `custom_dir: overrides` to theme config (enables announce bar template override)
- Adds `admonition_translations` for Italian
- Adds complete `nav_translations` (8 section + 16 child-page labels)
- Adds `base_path: docs` to pymdownx.snippets
- Removes redundant `extra.alternate` block
- Replaces `partials/announce.html` with `overrides/main.html`

---

## Spacing Scale

Unchanged from Phase 1. Material theme 8px base grid applies. No custom spacing.

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Icon gaps, inline padding |
| sm | 8px | Compact element spacing |
| md | 16px | Default element spacing |
| lg | 24px | Section padding |
| xl | 32px | Layout gaps |
| 2xl | 48px | Major section breaks |
| 3xl | 64px | Page-level spacing |

Exceptions: None.

---

## Typography

Unchanged from Phase 1. Material theme type scale applies.

| Role | Size | Weight | Line Height |
|------|------|--------|-------------|
| Body | 16px | 400 (regular) | 1.5 |
| Label | 14px | 500 (medium) | 1.4 |
| Heading | 20px | 700 (bold) | 1.2 |
| Display | 28px | 700 (bold) | 1.2 |

### Content Author Heading Rules

Content authors must use Markdown heading levels consistently:
- `#` (h1) -- Page title only, one per page
- `##` (h2) -- Major sections (step headings, topic sections)
- `###` (h3) -- Sub-sections within steps

Do not use h4-h6 in documentation content. Break content into separate pages instead.

### Code Blocks

Code blocks use Roboto Mono at 13.6px, regular weight (400), line-height 1.6. Language annotation is mandatory on all fenced code blocks. Code copy button is enabled via `content.code.copy` theme feature.

---

## Color

Unchanged from Phase 1. Indigo primary/accent on slate/default schemes.

| Role | Value | Usage |
|------|-------|-------|
| Dominant (60%) | #ffffff (light) / #1a1a2e (slate) | Background, content surfaces |
| Secondary (30%) | #f5f5f5 (light) / #2d2d44 (slate) | Sidebar, cards, navigation |
| Accent (10%) | #3f51b5 (indigo 500 light) / #536dfe (indigo A200 dark) | Links, active tabs, search highlight, code copy, CTA borders |
| Destructive | #ff1744 (red A400) | `!!! danger` admonitions only |

Accent reserved for: links, active navigation tabs, search result highlights, code copy button, primary CTA links in announce bar, inline code background.

### Admonition Color Mapping

| Admonition Type | Material Color | Italian Auto-Title | Usage Rule |
|-----------------|---------------|-------------------|------------|
| `!!! note` | Blue | Nota | Supplementary information that aids understanding |
| `!!! warning` | Orange | Avviso | Cautions about potential pitfalls or side effects |
| `!!! tip` | Green | Suggerimento | Recommendations for better results or alternative approaches |
| `!!! danger` | Red | Pericolo | Destructive actions, data loss risk, security-critical warnings |

Only these four types are permitted per D-08. Do not use `!!! info`, `!!! bug`, `!!! success`, `!!! failure`, or `!!! example`.

Italian admonition titles are auto-injected via `admonition_translations` in mkdocs.yml (no explicit title needed in Markdown when the default type name should be translated).

---

## Copywriting Contract

### Primary CTA

| Element | English | Italian |
|---------|---------|---------|
| Announce bar CTA | "Getting started with AirGap AI Chatbot" | "Inizia con AirGap AI Chatbot" |
| Announce bar prefix | "v1 Documentation --" | "Documentazione v1 --" |
| Announce bar link | `/chat/getting-started/` | `/it/chat/getting-started/` |

Implementation: Jinja2 template in `docs/overrides/main.html` using `{% block announce %}` with `i18n_current_language` conditional (D-07).

### Page Templates

#### Procedural Guide Pages (D-01, D-02)

Every child page follows this structure:

**English template:**
```markdown
# [Page Title]

[1-2 sentence introduction describing what the user will accomplish.]

--8<-- "_snippets/prereq-[relevant].md"

## [Step N]: [Action Verb + Object]

[code block showing one approach -- inline, not tabbed]

!!! note "[Optional: Context]"
    [Informational note about the step or result.]

!!! warning "[Optional: Caution]"
    [Warning about potential issues.]

!!! tip "[Optional: Recommendation]"
    [Helpful suggestion for better results.]
```

**Italian template (structural mirror per D-05):**
```markdown
# [Title in Italian or English per D-06]

[1-2 sentence Italian introduction mirroring English structure.]

--8<-- "_snippets.it/prereq-[relevant].md"

## [Passo N]: [Azione + Oggetto]

[same code block as English -- code is never translated]

!!! note "[Contesto opzionale]"
    [Nota informativa in italiano.]

!!! warning "[Cautela opzionale]"
    [Avviso su potenziali problemi.]

!!! tip "[Raccomandazione opzionale]"
    [Suggerimento utile in italiano.]
```

Key rules:
- One approach per code block, never tabbed alternatives (D-02)
- Every page covers one task end-to-end (D-01)
- Italian pages mirror English exactly: same headings, same sections, same order (D-05)
- Technical terms stay in English: API, Docker, RBAC, RAG, workspace, deployment (D-06)

#### Section Index Pages (D-03)

**English template:**
```markdown
# [Section Title]

[2-3 introductory paragraphs explaining what the section covers and who it is for.]

- **[Child Page Title](child-page.md)** -- [1-sentence description]
- **[Child Page Title](child-page.md)** -- [1-sentence description]
```

Section indexes are introductory landing pages, not bare link listings. They must have 2-3 paragraphs of prose before the links.

#### Home Page (D-04)

The home page (`index.en.md` / `index.it.md`) serves as the project overview with:
- Quick-start code example
- Feature highlights (3-4 items)
- Links into each documentation section

### Empty State

Not applicable. This is static documentation; all pages have authored content. Build-time errors are caught by `mkdocs build --strict`.

### Error State

| Error | Cause | Resolution |
|-------|-------|-----------|
| "Snippet file not found" | Missing snippet in `_snippets/` or `_snippets.it/` | Create the referenced snippet file |
| "Relative path resolution" | Broken markdown link syntax | Use `.md` extension, not `.html` or trailing-slash paths |
| Missing translation page | `.it.md` file absent for a `.en.md` file | Create the Italian counterpart (fallback shows English per `fallback_to_default: true`) |
| Orphan page warning | Page exists but not in `nav` | Add page to mkdocs.yml nav or prefix directory with `_` |

### Destructive Actions

None in this phase. Static documentation has no destructive user actions.

### Navigation Labels (Italian)

All 24 nav labels (8 section-level + 16 child-page-level):

| English | Italian | Level | Notes |
|---------|---------|-------|-------|
| Setup | Installazione e configurazione | Section | Changed from "Configurazione" to avoid collision with Configuration child page |
| Chat | Chat | Section | |
| Documents & RAG | Documenti e RAG | Section | |
| Workspaces & Projects | Aree di lavoro e Progetti | Section | |
| Administration | Amministrazione | Section | |
| API | API | Section | |
| Deployment | Distribuzione | Section | |
| Security | Sicurezza | Section | |
| Home | Home | Child page | |
| Installation | Installazione | Child page | |
| Configuration | Configurazione | Child page | |
| Getting Started | Per iniziare | Child page | |
| Features | Funzionalita | Child page | |
| Uploading | Caricamento | Child page | |
| Querying | Interrogazione | Child page | |
| Workspaces | Aree di lavoro | Child page | |
| Projects | Progetti | Child page | |
| RBAC | RBAC | Child page | |
| Settings | Impostazioni | Child page | |
| Endpoints | Endpoint | Child page | |
| Authentication | Autenticazione | Child page | |
| Docker | Docker | Child page | |
| Air-Gap Setup | Configurazione Air-Gap | Child page | |
| Overview | Panoramica | Child page | |
| Compliance | Conformita | Child page | |

Source: RESEARCH.md complete nav_translations, CONTEXT.md D-06 (tech terms stay English).

### Translation Rules

1. Italian pages mirror English structure exactly: same headings, same sections, same order (D-05)
2. Technical terms stay in English in Italian pages: API, Docker, RBAC, RAG, workspace, deployment (D-06)
3. Italian for all UI-facing prose, navigation labels, and descriptive text
4. Code blocks are identical between languages -- never translate code
5. Shared snippets reduce translation cost: translate a prerequisite block once, include it in multiple pages (D-09)

---

## Content Patterns

### Shared Snippets

| Directory | Language | Purpose |
|-----------|----------|---------|
| `docs/_snippets/` | English | Repeated content blocks (prerequisites, URLs, disclaimers) |
| `docs/_snippets.it/` | Italian | Italian translations of the same blocks |

Include syntax: `--8<-- "_snippets/filename.md"` (English) or `--8<-- "_snippets.it/filename.md"` (Italian).

The `_` prefix ensures MkDocs excludes snippet directories from the build output (not treated as content pages).

Initial snippet set:

| Snippet File | English Content | Italian Content |
|-------------|----------------|-----------------|
| `prereq-docker.md` | "Before you begin, ensure Docker is installed and running on your system." | "Prima di iniziare, assicurarsi che Docker sia installato e in esecuzione sul sistema." |
| `api-base-url.md` | "All API examples use `http://localhost:3000/api` as the base URL." | "Tutti gli esempi API utilizzano `http://localhost:3000/api` come URL di base." |
| `standard-disclaimer.md` | "This documentation applies to AirGap AI Chatbot v1." | "Questa documentazione si applica ad AirGap AI Chatbot v1." |

### Cross-Reference Rules

- Always use MkDocs markdown link syntax: `[text](page.md)`
- Never hardcode `.html` extensions or trailing-slash directory paths
- Never use absolute paths with language prefixes in markdown links (let i18n plugin resolve them)

---

## Configuration Changes

The following mkdocs.yml changes are required for this phase:

### 1. Add `custom_dir` for template overrides

```yaml
theme:
  name: material
  custom_dir: docs/overrides    # REQUIRED: enables announce bar rendering
  # ... rest of theme config
```

### 2. Delete `docs/overrides/partials/announce.html`

This file uses the wrong override pattern. Material's announce bar is a `{% block announce %}` in `base.html`, not a partial include. Delete this file.

### 3. Create `docs/overrides/main.html`

```html
{% extends "base.html" %}

{% block announce %}
  {% if i18n_current_language == "it" %}
  <span>
    <a href="/it/chat/getting-started/">
      Documentazione v1 &mdash; Inizia con AirGap AI Chatbot
    </a>
  </span>
  {% else %}
  <span>
    <a href="/chat/getting-started/">
      v1 Documentation &mdash; Getting started with AirGap AI Chatbot
    </a>
  </span>
  {% endif %}
{% endblock %}
```

Source: RESEARCH.md Pattern 3. Uses `i18n_current_language` variable exposed by mkdocs-static-i18n.

### 4. Remove `extra.alternate` block

The `extra` -> `alternate` section in mkdocs.yml is redundant -- `reconfigure_material: true` auto-generates per-page language alternates with stay-on-page behavior. Remove the entire block.

### 5. Add `admonition_translations` to Italian language config

```yaml
- locale: it
  name: Italiano
  site_name: AirGap AI Chatbot - Documentazione
  admonition_translations:
    note: Nota
    warning: Avviso
    tip: Suggerimento
    danger: Pericolo
  nav_translations:
    # ... (see Navigation Labels table above for complete list)
```

### 6. Complete `nav_translations` with child-page labels

Add 16 child-page Italian labels and update "Setup" translation to "Installazione e configurazione" to avoid collision with "Configuration" -> "Configurazione". See Navigation Labels table above for the complete mapping.

### 7. Add `base_path` and `check_paths` to pymdownx.snippets

```yaml
- pymdownx.snippets:
    base_path: docs
    check_paths: true
```

---

## Registry Safety

| Registry | Blocks Used | Safety Gate |
|----------|-------------|-------------|
| MkDocs Material (built-in) | theme, search, offline, privacy plugins | not applicable (no third-party component registry) |
| mkdocs-static-i18n | i18n plugin | verified via PyPI -- maintained, v1.3.1 |
| pymdown-extensions | snippets, highlight, superfences, tabbed, details | verified via PyPI -- maintained, v10.21.2 |

No shadcn registry, no npm packages, no third-party frontend component registries. All dependencies are Python packages from PyPI.

---

## Checker Sign-Off

- [ ] Dimension 1 Copywriting: PASS -- all content patterns, page templates, admonition rules, navigation labels, and translation conventions specified
- [ ] Dimension 2 Visuals: PASS -- Material theme provides all visual primitives; announce bar template specified with i18n conditional; snippet include patterns defined
- [ ] Dimension 3 Color: PASS -- indigo primary/accent on slate/default schemes inherited from Phase 1; four-standard admonition color mapping defined
- [ ] Dimension 4 Typography: PASS -- Material theme type scale inherited from Phase 1; heading level rules for content authors specified
- [ ] Dimension 5 Spacing: PASS -- Material 8px base grid inherited from Phase 1; no custom spacing needed
- [ ] Dimension 6 Registry Safety: PASS -- no registries used; not applicable for MkDocs Material project

**Approval:** pending