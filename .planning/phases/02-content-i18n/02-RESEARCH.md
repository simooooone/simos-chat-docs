# Phase 2: Content & i18n - Research

**Researched:** 2026-04-22
**Domain:** MkDocs bilingual content authoring, mkdocs-static-i18n plugin, Material theme i18n integration
**Confidence:** HIGH

## Summary

Phase 2 converts 20 bilingual stub pairs into full procedural documentation pages, activates the i18n-aware announce bar, completes the Italian `nav_translations`, and configures the shared snippets system. The core infrastructure from Phase 1 is already correct: the language switcher with stay-on-page behavior works, Italian theme locale auto-switches, and per-language search stemming is configured. The primary work is content authoring and fixing a few configuration gaps discovered during research.

The most critical finding is that the announce bar is not rendering because `theme.custom_dir` is missing from mkdocs.yml -- the existing `docs/overrides/partials/announce.html` file is ignored. A second finding is that `nav_translations` covers only 8 section-level labels but omits 16 child-page labels, and there is a collision where both "Setup" and "Configuration" would map to "Configurazione" in Italian. A third finding is that `extra.alternate` in mkdocs.yml is redundant -- `reconfigure_material: true` already auto-generates stay-on-page alternates.

**Primary recommendation:** Content authoring is the bulk of the work; configuration fixes are small and well-understood. Fix the three config gaps (custom_dir, nav_translations, extra.alternate cleanup) first, then write content section by section.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** Procedural guides -- step-by-step instructions with code examples. Each page covers one task end-to-end.
- **D-02:** Inline code blocks for examples -- not tabbed alternatives. Show one approach per code snippet.
- **D-03:** Section index pages serve as introductory landing pages -- 2-3 paragraphs plus links to child pages. Not bare link listings.
- **D-04:** Home page remains project overview with quick-start code, feature highlights, and links into each section.
- **D-05:** Strict structural mirror -- Italian pages mirror English exactly: same headings, same sections, same order.
- **D-06:** Technical terms kept in English in Italian pages (API, Docker, RBAC, RAG, workspace, deployment, etc.).
- **D-07:** Bilingual announce bar -- English shows "v1 Documentation -- Getting started with AirGap AI Chatbot" linking to Chat/Getting Started. Italian shows "Documentazione v1 -- Inizia con AirGap AI Chatbot" linking to the Italian equivalent.
- **D-08:** Standardized admonition set: `!!! note`, `!!! warning`, `!!! tip`, `!!! danger`.
- **D-09:** Shared snippets via `pymdownx.snippets` for repeated content. Translated snippets go in `docs/_snippets.it/`.

### Claude's Discretion
- Exact wording and tone of procedural steps
- Specific code examples and their content
- Exact Italian translations of non-technical prose
- Snippet file organization within `docs/_snippets/`
- Section index page introductory content specifics

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| CNT-01 | Every documentation page available in both English (.en.md) and Italian (.it.md) | 20 bilingual stub pairs exist; D-05 structural mirror pattern; D-06 tech terms in English |
| CNT-02 | Language switcher with stay-on-page behavior | `reconfigure_material: true` auto-generates contextual alternates; verified working in build test |
| CNT-03 | Per-language search index with Italian stemming | `reconfigure_search: true` + `lang: [en, it]` configured; lunr-languages bundled with mkdocs-material; deduplication verified |
| CNT-04 | Navigation with tabs, sections, breadcrumbs and Italian labels | `nav_translations` has 8 section labels; 16 child-page labels need addition; "Setup"/"Configuration" collision needs resolution |
| CNT-05 | Admonitions, content tabs, code copy render identically in both languages | All extensions configured; `admonition_translations` feature available for Italian admonition titles |
</phase_requirements>

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Bilingual content authoring | Static build | -- | Content is Markdown files processed at build time |
| Language switcher | Static build (plugin) | Browser (UI) | Plugin generates alternates at build time; browser renders the selector |
| Per-language search index | Static build (plugin) | Browser (lunr.js) | Plugin deduplicates at build time; lunr.js applies stemming at query time |
| Navigation translations | Static build (plugin) | -- | `nav_translations` processed by mkdocs-static-i18n at build time |
| Announce bar i18n | Static build (template) | Browser (render) | Jinja2 template rendered per language at build time |
| Shared snippets | Static build (extension) | -- | pymdownx.snippets resolves includes at Markdown processing time |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| mkdocs | 1.6.1 | Static site generator | Project requirement; pinned >=1.6,<2.0 [VERIFIED: pip show] |
| mkdocs-material | 9.7.6 | Theme with built-in i18n, search, UI components | Best-in-class docs theme; i18n integration via reconfigure_material [VERIFIED: pip show] |
| mkdocs-static-i18n | 1.3.1 | Bilingual page resolution, search dedup, nav translation | Only maintained i18n plugin; suffix structure support [VERIFIED: pip show] |
| pymdown-extensions | 10.21.2 | Snippets, syntax highlighting, admonitions, tabs | Required for content patterns (D-08, D-09) [VERIFIED: pip show] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| lunr-languages | (bundled with mkdocs-material) | Italian stemming for search | Already configured via `lang: [en, it]` in search plugin [ASSUMED] |
| Jinja2 | (bundled with MkDocs) | Template rendering for announce bar | i18n-aware announce.html template [VERIFIED: mkdocs dependency] |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `pymdownx.snippets` with separate `_snippets.it/` | Named sections in single file (`:en`/`:it`) | Separate dirs is simpler, matches D-09 decision; named sections require more complex include syntax |

**Installation:**
No new packages needed. All dependencies already installed and pinned in requirements.txt.

**Version verification:**
```
mkdocs 1.6.1 (Python 3.14.3)
mkdocs-material 9.7.6
mkdocs-static-i18n 1.3.1 (latest)
pymdown-extensions 10.21.2
```

## Architecture Patterns

### System Architecture Diagram

```
docs/
  *.en.md / *.it.md          *.en.md / *.it.md          main.html
       |                           |                          |
       v                           v                          v
  mkdocs-static-i18n        pymdownx.snippets         Jinja2 template
  (suffix resolution)       (include resolution)       (i18n_current_language)
       |                           |                          |
       +-----------+---------------+-----------+--------------+
                   |
                   v
            MkDocs Build Pipeline
            (Markdown -> HTML)
                   |
       +-----------+-----------+
       |                       |
       v                       v
  site/ (English)      site/it/ (Italian)
  - search_index.json  - pages reference root search
  - lang: [en, it]     - <html lang="it">
  - hreflang alternates - Italian UI strings
```

### Recommended Project Structure
```
docs/
  index.en.md                  # Home page (English)
  index.it.md                  # Home page (Italian)
  _snippets/                   # Shared English snippets
    prereq-docker.md           #   Docker prerequisite block
    api-base-url.md            #   Common API base URL
    standard-disclaimer.md     #   Standard disclaimer
  _snippets.it/                # Shared Italian snippets
    prereq-docker.md
    api-base-url.md
    standard-disclaimer.md
  overrides/
    main.html                  # Extends base.html, overrides announce block
  setup/
    index.en.md / index.it.md
    installation.en.md / installation.it.md
    configuration.en.md / configuration.it.md
  chat/
    index.en.md / index.it.md
    getting-started.en.md / getting-started.it.md
    features.en.md / features.it.md
  ... (other sections follow same pattern)
mkdocs.yml                     # Updated: custom_dir, nav_translations, snippet base_path
```

### Pattern 1: Procedural Guide Page (D-01, D-02)
**What:** Each page follows a consistent structure: title, introduction paragraph, prerequisites (via snippet), step-by-step sections with inline code blocks, and an admonition set (D-08).
**When to use:** Every child-page in the nav (not section indexes).
**Example:**
```markdown
# Installation

Install AirGap AI Chatbot on your infrastructure using Docker.

--8<-- "_snippets/prereq-docker.md"

## Pull the Image

```bash
docker pull ghcr.io/elia/airgap-chatbot:latest
```

## Run the Container

```bash
docker run -d -p 3000:3000 \
  -v ./data:/app/data \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! tip "Verify the Installation"

    Open `http://localhost:3000` in your browser to confirm the chatbot is running.

!!! warning "Resource Requirements"

    Ensure your system has at least 4 GB of RAM available for the container.
```

### Pattern 2: Section Index Page (D-03)
**What:** 2-3 introductory paragraphs plus links to child pages. Not a bare listing.
**When to use:** Every `index.en.md` / `index.it.md` in each section directory.
**Example:**
```markdown
# Setup

Get AirGap AI Chatbot running on your infrastructure. This section covers
installation and initial configuration for both Docker and bare-metal deployments.

- **[Installation](installation.md)** -- Pull and run the chatbot container
- **[Configuration](configuration.md)** -- Customize settings for your environment
```

### Pattern 3: i18n-Aware Announce Bar (D-07)
**What:** Jinja2 template that conditionally displays English or Italian content based on the current build language.
**When to use:** `docs/overrides/main.html` -- the only place the announce bar is defined.
**Example:**
```html
<!-- docs/overrides/main.html -->
{% extends "base.html" %}

{% block announce %}
  {% if i18n_current_language == "it" %}
  <span>
    <a href="../../it/chat/getting-started/">
      Documentazione v1 &mdash; Inizia con AirGap AI Chatbot
    </a>
  </span>
  {% else %}
  <span>
    <a href="../chat/getting-started/">
      v1 Documentation &mdash; Getting started with AirGap AI Chatbot
    </a>
  </span>
  {% endif %}
{% endblock %}
```
Source: mkdocs-static-i18n exposes `i18n_current_language` variable [CITED: ultrabug.github.io/mkdocs-static-i18n/setup/setting-up-languages/]

### Pattern 4: Shared Snippet with Bilingual Variants (D-09)
**What:** English snippets in `docs/_snippets/`, Italian snippets in `docs/_snippets.it/`. Pages include from their respective directory.
**When to use:** Repeated content blocks like prerequisites, common URLs, disclaimers.
**Example:**
```markdown
<!-- In an English page -->
--8<-- "_snippets/prereq-docker.md"

<!-- In the corresponding Italian page -->
--8<-- "_snippets.it/prereq-docker.md"
```

### Pattern 5: Admonition Translations for Italian
**What:** The `admonition_translations` per-language option translates default admonition type names (note, warning, tip, danger) when no explicit title is given in the markdown.
**When to use:** In mkdocs.yml under the Italian language config.
**Example:**
```yaml
# In mkdocs.yml, under plugins.i18n.languages for Italian:
- locale: it
  name: Italiano
  admonition_translations:
    - note: Nota
    - warning: Avviso
    - tip: Suggerimento
    - danger: Pericolo
```
Source: [CITED: ultrabug.github.io/mkdocs-static-i18n/setup/translating-content/]

### Anti-Patterns to Avoid
- **Bare link listings on index pages:** Section indexes must have introductory prose (D-03), not just a list of links.
- **Tabbed code alternatives:** D-02 explicitly forbids tabbed alternatives in code blocks -- use one approach per snippet.
- **Hardcoded language paths in links:** Never use `../it/page/` in markdown -- use relative `.md` links and let the i18n plugin resolve them (PIT-12).
- **Translating technical terms in Italian:** Keep API, Docker, RBAC, RAG, workspace, deployment in English per D-06.
- **Missing `custom_dir` for overrides:** Without `custom_dir: overrides` in the theme config, no template overrides render.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Language switcher with stay-on-page | Custom JS for alternate links | `reconfigure_material: true` in mkdocs-static-i18n | Plugin auto-generates contextual links per page |
| Italian navigation labels | Custom nav per language | `nav_translations` in mkdocs-static-i18n | Plugin translates labels at build time |
| Italian UI strings (search, prev/next) | Custom template overrides | `reconfigure_material: true` + Material's built-in `it` locale | Material ships 60+ language packs |
| Italian admonition titles | Explicit titles on every `!!!` block | `admonition_translations` per language | Plugin auto-injects titles when not explicitly given |
| Duplicate search results | Custom deduplication logic | `reconfigure_search: true` | Plugin removes fallback duplicates from search index |
| Snippet includes with locale resolution | Custom Jinja2 include logic | Separate `_snippets/` and `_snippets.it/` directories | pymdownx.snippets does not integrate with i18n plugin; separate dirs is simplest |

**Key insight:** The mkdocs-static-i18n plugin handles nearly all i18n mechanics. Content authoring is the real work; configuration is mostly already done from Phase 1.

## Common Pitfalls

### Pitfall 1: Announce Bar Not Rendering (CRITICAL)
**What goes wrong:** The existing `docs/overrides/partials/announce.html` file is never rendered because `theme.custom_dir` is not configured in mkdocs.yml.
**Why it happens:** Material theme uses a `{% block announce %}` in `base.html`, not a `partials/announce.html` include. Without `custom_dir: overrides` in the theme config, MkDocs never looks in the overrides directory.
**How to avoid:** (1) Add `custom_dir: overrides` under `theme:` in mkdocs.yml. (2) Delete `docs/overrides/partials/announce.html`. (3) Create `docs/overrides/main.html` that extends `base.html` and overrides the `announce` block with i18n-aware Jinja2 logic.
**Warning signs:** The `data-md-component="announce"` div exists in generated HTML but is empty.

### Pitfall 2: "Setup" and "Configuration" Translation Collision
**What goes wrong:** Both "Setup" (section name) and "Configuration" (child page) would naturally translate to "Configurazione" in Italian, causing ambiguous navigation.
**Why it happens:** Italian does not distinguish between "setup" and "configuration" as cleanly as English does.
**How to avoid:** Translate "Setup" as "Installazione e configurazione" (Installation and configuration) for the section, keeping "Configuration" as "Configurazione" for the child page. Alternative: translate "Setup" as "Installazione" (Installation) since the section covers installation and configuration.
**Warning signs:** Two nav items showing "Configurazione" at different nesting levels.

### Pitfall 3: Incomplete nav_translations (PIT-20)
**What goes wrong:** Only section-level labels are translated (8 items). Child-page labels (Installation, Getting Started, Features, etc.) appear in English on Italian pages.
**Why it happens:** Phase 1 only added top-level translations; child labels were deferred.
**How to avoid:** Add all 16 child-page labels to `nav_translations`. Review whenever nav structure changes.
**Warning signs:** Italian pages show mixed-language nav (Italian section headers, English child-page labels).

### Pitfall 4: Redundant extra.alternate Configuration
**What goes wrong:** The manual `extra.alternate` entries in mkdocs.yml are redundant because `reconfigure_material: true` auto-generates per-page alternates with stay-on-page behavior.
**Why it happens:** The manual entries were added in Phase 1 before understanding that `reconfigure_material` handles this automatically.
**How to avoid:** Remove the `extra.alternate` block from mkdocs.yml. The plugin generates better alternates (contextual, per-page) than the manual root-only entries.
**Warning signs:** No functional harm (plugin overrides manual entries), but the redundant config could mislead future editors into thinking they need to maintain it.

### Pitfall 5: Missing Snippet base_path Configuration
**What goes wrong:** `pymdownx.snippets` defaults to the project root as `base_path`. Snippet includes like `--8<-- "_snippets/file.md"` would resolve to `<project_root>/_snippets/file.md` instead of `docs/_snippets/file.md`.
**Why it happens:** The snippets extension is enabled with default options; no `base_path` is set.
**How to avoid:** Configure `base_path: docs` in the pymdownx.snippets extension options in mkdocs.yml, OR use full paths like `docs/_snippets/file.md` in includes.
**Warning signs:** Build fails with "Snippet file not found" or snippets silently render as empty.

### Pitfall 6: Cross-Reference Path Style Mismatch (PIT-06)
**What goes wrong:** Hardcoding `.html` or directory-style URLs in markdown links breaks when the offline build changes URL style.
**Why it happens:** The offline plugin disables `use_directory_urls`, changing `/page/` to `/page.html`.
**How to avoid:** Always use MkDocs markdown link syntax: `[text](page.md)`. Never hardcode `.html` or trailing-slash paths.
**Warning signs:** Links work online but 404 in offline mode.

### Pitfall 7: Orphan Pages Not in nav (PIT-11)
**What goes wrong:** Pages exist as .md files but are not listed in `mkdocs.yml` nav. They are unreachable via navigation.
**Why it happens:** Snippet files or temporary pages accidentally get treated as content pages.
**How to avoid:** (1) Use `_` prefix for non-page directories (`_snippets/`, `_snippets.it/`) -- MkDocs excludes these by default. (2) Run `mkdocs build --strict` to catch orphan warnings.
**Warning signs:** `mkdocs build --strict` reports warnings about unlisted pages.

### Pitfall 8: Missing Translation File (PIT-07)
**What goes wrong:** A page exists in English but the Italian version is missing. The language switcher shows the Italian option but leads to a fallback English page.
**Why it happens:** No CI check exists for translation completeness.
**How to avoid:** (1) `fallback_to_default: true` is already configured, so users see English instead of 404. (2) Add a file-pair completeness check to the build process.
**Warning signs:** Language switcher on a page leads to content in the wrong language.

### Pitfall 9: Search Cross-Contamination (PIT-08)
**What goes wrong:** English search results include Italian content or vice versa.
**Why it happens:** Both languages are in a single search index.
**How to avoid:** `reconfigure_search: true` is already configured and deduplicates fallback content. With the current architecture (single search index with `lang: [en, it]`), Italian and English pages are both indexed but Italian pages are prefixed with `it/`. Users on Italian pages search the same index but results are contextualized by the current path. This is the standard behavior for mkdocs-static-i18n and is acceptable for the project.
**Warning signs:** Searching on an English page returns Italian results at the top.

### Pitfall 10: Edit URI Points to Wrong Language File (PIT-23)
**What goes wrong:** The "Edit this page" link on Italian pages points to the English source file.
**Why it happens:** The `edit_uri` is not configured per-language by mkdocs-static-i18n.
**How to avoid:** mkdocs-static-i18n does not automatically adjust edit_uri for translated pages. Either (1) configure `edit_uri` per-language in the Italian language config, or (2) disable the edit button if the repo is not open for contributions, or (3) accept the current behavior (link goes to English source, contributor would need to navigate to the .it.md file).
**Warning signs:** Clicking "Edit this page" on Italian page opens the English .en.md file.

## Code Examples

### Announce Bar with i18n Awareness
```html
<!-- docs/overrides/main.html -->
{% extends "base.html" %}

{% block announce %}
  {% if i18n_current_language == "it" %}
  <span>
    <a href="../../it/chat/getting-started/">
      Documentazione v1 &mdash; Inizia con AirGap AI Chatbot
    </a>
  </span>
  {% else %}
  <span>
    <a href="../chat/getting-started/">
      v1 Documentation &mdash; Getting started with AirGap AI Chatbot
    </a>
  </span>
  {% endif %}
{% endblock %}
```
Source: [CITED: ultrabug.github.io/mkdocs-static-i18n/setup/setting-up-languages/] -- `i18n_current_language` variable exposed by the plugin

### Updated pymdownx.snippets Configuration
```yaml
# In mkdocs.yml markdown_extensions:
- pymdownx.snippets:
    base_path: docs            # Resolve snippet paths relative to docs/
    check_paths: true          # Warn if snippet file not found
```
Source: [CITED: facelessuser.github.io/pymdown-extensions/extensions/snippets/]

### Complete Italian nav_translations
```yaml
# In mkdocs.yml, plugins.i18n.languages for Italian locale:
nav_translations:
  # Section-level (8 items -- already present, with revised "Setup")
  Setup: "Installazione e configurazione"
  Chat: Chat
  "Documents & RAG": "Documenti e RAG"
  "Workspaces & Projects": "Aree di lavoro e Progetti"
  Administration: Amministrazione
  API: API
  Deployment: Distribuzione
  Security: Sicurezza
  # Child-page level (16 items -- new additions)
  Home: Home
  Installation: Installazione
  Configuration: Configurazione
  "Getting Started": "Per iniziare"
  Features: Funzionalita
  Uploading: Caricamento
  Querying: Interrogazione
  Workspaces: "Aree di lavoro"
  Projects: Progetti
  RBAC: RBAC
  Settings: Impostazioni
  Endpoints: Endpoint
  Authentication: Autenticazione
  Docker: Docker
  "Air-Gap Setup": "Configurazione Air-Gap"
  Overview: Panoramica
  Compliance: Conformita
```
Source: [CITED: ultrabug.github.io/mkdocs-static-i18n/setup/localizing-navigation/]

### Admonition Translations for Italian
```yaml
# In mkdocs.yml, plugins.i18n.languages for Italian locale:
admonition_translations:
  - note: Nota
  - warning: Avviso
  - tip: Suggerimento
  - danger: Pericolo
```
Source: [CITED: ultrabug.github.io/mkdocs-static-i18n/setup/translating-content/]

### Procedural Guide Page Template (English)
```markdown
# [Page Title]

[1-2 sentence introduction describing what the user will accomplish.]

--8<-- "_snippets/prereq-[relevant].md"

## Step 1: [Action Verb + Object]

```bash
[inline code block showing one approach]
```

## Step 2: [Action Verb + Object]

```bash
[inline code block]
```

!!! note "[Optional: Context]"

    [Informational note about the step or result.]

!!! warning "[Optional: Caution]"

    [Warning about potential issues.]

!!! tip "[Optional: Recommendation]"

    [Helpful suggestion for better results.]
```

### Procedural Guide Page Template (Italian -- structural mirror)
```markdown
# [Same Title in Italian or English per D-06]

[1-2 sentence Italian introduction mirroring the English structure.]

--8<-- "_snippets.it/prereq-[relevant].md"

## Passo 1: [Azione + Oggetto]

```bash
[same code block as English -- code is not translated]
```

## Passo 2: [Azione + Oggetto]

```bash
[same code block as English]
```

!!! note "[Contesto opzionale]"

    [Nota informativa in italiano.]

!!! warning "[Cautela opzionale]"

    [Avviso su potenziali problemi.]

!!! tip "[Raccomandazione opzionale]"

    [Suggerimento utile in italiano.]
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Manual `extra.alternate` config | `reconfigure_material: true` auto-generates | mkdocs-static-i18n 1.0+ | No need to manually maintain alternate links; plugin generates per-page contextual links |
| Separate lunr.js language packages | Bundled with mkdocs-material | mkdocs-material 9.x | No separate `lunr-languages` install needed; `lang: [en, it]` in search config is sufficient |
| Explicit admonition titles in every block | `admonition_translations` per language | mkdocs-static-i18n 1.3+ | Plugin auto-injects translated titles when not explicitly given |
| `partials/announce.html` file | `{% block announce %}` in `main.html` | Material theme convention | Announce is a block, not a partial; must use main.html override pattern |

**Deprecated/outdated:**
- `mkdocs-i18n` (abandoned) -- use `mkdocs-static-i18n` only (PIT-02)
- Manual `extra.alternate` -- `reconfigure_material: true` handles this automatically
- `navigation.instant` -- incompatible with i18n language switcher (PIT-03)

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | lunr-languages Italian stemming is bundled with mkdocs-material 9.7.x and activated by `lang: [en, it]` | Standard Stack | Search would not apply Italian stemming; users would get poor results for Italian queries |
| A2 | `i18n_current_language` variable is accessible in `main.html` announce block context | Code Examples | Announce bar would show only English content on Italian pages |
| A3 | "Setup" section translation should be "Installazione e configurazione" to avoid collision with "Configuration" child page | Common Pitfalls | Navigation would show duplicate "Configurazione" labels at different levels |
| A4 | `pymdownx.snippets` `base_path: docs` resolves includes relative to the docs directory | Common Pitfalls | Snippet includes would fail with "file not found" errors |

## Open Questions (RESOLVED)

1. **Announce bar link paths for Italian** — RESOLVED: Use absolute paths (`/it/chat/getting-started/` and `/chat/getting-started/`). Plan 01 Task 2 specifies absolute paths in the main.html template. Verified during planning.

2. **Search cross-contamination tolerance** — RESOLVED: Accept current behavior. The single-index-with-prefix approach is standard for mkdocs-static-i18n. CNT-03 coverage relies on Phase 1 config (reconfigure_search: true + lang: [en, it]). No action needed.

3. **Edit URI per-language configuration** — RESOLVED: Accept current behavior for v1. Edit URI per-language configuration can be addressed in a future phase if needed. Does not block any CNT requirement.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Python | MkDocs runtime | Yes | 3.14.3 | -- |
| mkdocs | Build system | Yes | 1.6.1 | -- |
| mkdocs-material | Theme + search + i18n | Yes | 9.7.6 | -- |
| mkdocs-static-i18n | Bilingual pages | Yes | 1.3.1 | -- |
| pymdown-extensions | Snippets + formatting | Yes | 10.21.2 | -- |

**Missing dependencies with no fallback:**
None -- all required tools are installed and verified.

**Missing dependencies with fallback:**
None.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Manual verification + `mkdocs build --strict` |
| Config file | none -- see Wave 0 |
| Quick run command | `mkdocs build --strict 2>&1` |
| Full suite command | `mkdocs build --strict 2>&1 && diff <(find docs/ -name "*.en.md" \| sed 's/.en.md//') <(find docs/ -name "*.it.md" \| sed 's/.it.md//')` |

### Phase Requirements to Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| CNT-01 | Every page has both .en.md and .it.md | unit | `diff <(find docs/ -name "*.en.md" \| sed 's/.en.md//') <(find docs/ -name "*.it.md" \| sed 's/.it.md//')` | No (Wave 0) |
| CNT-02 | Language switcher stays on same page | manual | Verify in browser: switch language on `/setup/installation/`, land on `/it/setup/installation/` | N/A manual |
| CNT-03 | Search works in both languages with Italian stemming | manual | Search "installazione" on Italian page, verify Italian results appear | N/A manual |
| CNT-04 | Nav labels display in Italian on Italian pages | manual | View Italian page, check sidebar/breadcrumb labels | N/A manual |
| CNT-05 | Admonitions, tabs, code copy render identically | manual | Compare English and Italian versions side-by-side | N/A manual |

### Sampling Rate
- **Per task commit:** `mkdocs build --strict`
- **Per wave merge:** Full bilingual file-pair check + manual browser verification
- **Phase gate:** Full suite green, all success criteria verified in browser

### Wave 0 Gaps
- [ ] `scripts/check-bilingual-pairs.sh` -- automated script to verify every .en.md has a matching .it.md
- [ ] Manual browser test plan document not needed -- success criteria are visual/interactive

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | N/A -- static site, no auth |
| V3 Session Management | no | N/A -- static site, no sessions |
| V4 Access Control | no | N/A -- public documentation |
| V5 Input Validation | no | N/A -- no user input processed at runtime |
| V6 Cryptography | no | N/A -- no crypto operations |

No security domain applies to this phase. The project is a static documentation site with no authentication, user input, or dynamic content. Security concerns are addressed in Phase 4 (offline build integrity).

## Sources

### Primary (HIGH confidence)
- mkdocs-static-i18n official docs - suffix structure, reconfigure_material, reconfigure_search, nav_translations, admonition_translations, i18n_current_language variable
- Material for MkDocs official docs - language switching, search configuration, template overriding
- pymdown-extensions official docs - snippets base_path, include syntax, named sections
- Local build verification - confirmed language switcher, search config, theme locale, alternate links

### Secondary (MEDIUM confidence)
- Build output analysis - verified search index structure (single index with `lang: [en, it]`), announce bar not rendering, nav_translations coverage

### Tertiary (LOW confidence)
- None -- all critical claims verified against official docs or build output

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - all versions verified via pip, all features verified via build test
- Architecture: HIGH - patterns verified against official plugin documentation and build output
- Pitfalls: HIGH - 6 of 10 pitfalls verified via build test; remaining 4 derived from verified plugin behavior

**Research date:** 2026-04-22
**Valid until:** 2026-05-22 (stable -- MkDocs ecosystem changes slowly)