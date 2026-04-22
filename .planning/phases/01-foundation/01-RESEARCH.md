# Phase 1: Foundation - Research

**Researched:** 2026-04-22
**Domain:** MkDocs project initialization with Material theme, i18n plugin, and core rendering configuration
**Confidence:** HIGH

## Summary

Phase 1 establishes the MkDocs project skeleton: a working `mkdocs.yml` with Material theme, pinned dependencies in `requirements.txt`, bilingual `.en.md`/`.it.md` placeholder files, and all core rendering features (syntax highlighting, admonitions, content tabs, code copy button) verified via `mkdocs serve`. This is a greenfield setup -- no existing MkDocs configuration exists. All packages (mkdocs 1.6.1, mkdocs-material 9.7.6, mkdocs-static-i18n 1.3.1, pymdown-extensions 10.21.2) are already installed and verified on the development machine, so the phase is purely about creating the correct configuration files and directory structure.

The primary risk is misconfiguration rather than version incompatibility. The critical decisions from CONTEXT.md are: (1) use `!ENV [OFFLINE, false]` conditionals on `offline` and `privacy` plugins, NOT the Insiders-only `group` plugin; (2) exclude `navigation.instant` from the features list; (3) pin `mkdocs>=1.6,<2.0`; (4) use `docs_structure: suffix` for i18n; (5) feature-area-based navigation with 8 sections, 2-3 levels deep.

**Primary recommendation:** Create a single `mkdocs.yml` with explicit plugin load order (i18n, then search, then conditioned offline/privacy), dark-mode-default palette, suffix-based i18n configuration, and all required markdown extensions. Then create minimal `.en.md`/`.it.md` stubs for all 8 nav sections and verify with `mkdocs serve`.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** Feature-area-based organization -- sections organized by product area (Setup, Chat, Documents & RAG, Workspaces & Projects, Administration, API, Deployment, Security)
- **D-02:** 8 top-level nav sections, 2-3 levels deep maximum
- **D-03:** Navigation structure defined in mkdocs.yml `nav` with bilingual labels via `nav_translations`
- **D-04:** Dark mode as default palette, with light mode toggle
- **D-05:** Text/SVG logo placeholder in header -- asset to be provided later
- **D-06:** Default Material theme (no custom brand colors beyond dark/light palette)
- **D-07:** Explicit plugin load order in mkdocs.yml: i18n -> search -> (offline/privacy conditioned on `!ENV`). Prevents PIT-13 load-order conflicts.
- **D-08:** Separate per-language search indexes (en + it) with Italian stemming and `reconfigure_search: true`
- **D-09:** Print-to-PDF support enabled via Material `print` feature
- **D-10:** Announcement bar enabled (Material `announce` block) -- placeholder content for Phase 2
- **D-11:** TOC sidebar on right for long pages (Material `toc` feature)
- **D-12:** Footer navigation with previous/next links enabled
- **D-13:** `!ENV [OFFLINE, false]` conditionals for privacy and offline plugins (NOT Insiders-only `group` plugin)
- **D-14:** `navigation.instant` explicitly excluded from mkdocs.yml (Fetch API fails on file:// protocol -- PIT-03)
- **D-15:** Minimal stubs for .en.md/.it.md files: title + one-line description + "Content coming soon" note
- **D-16:** Each English stub must have a corresponding Italian stub (bilingual pairing enforced)

### Claude's Discretion
- Exact nav section labels and ordering (as long as they follow the feature-area pattern)
- Specific heading structure within minimal stubs
- Exact dark palette colors (Material defaults are fine)
- Plugin version pins beyond the requirements already specified

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| FDN-01 | MkDocs project initialized with Material theme (mkdocs-material 9.7.x) and core plugins configured | mkdocs.yml with theme: material, plugins section with i18n + search, markdown_extensions with pymdownx.* -- all verified syntax |
| FDN-02 | Dependencies pinned in requirements.txt -- mkdocs>=1.6,<2.0, mkdocs-material>=9.7, mkdocs-static-i18n==1.3.1, pymdown-extensions>=10.21 | Exact version pins verified against PyPI; installed versions confirmed (1.6.1, 9.7.6, 1.3.1, 10.21.2) |
| FDN-03 | Bilingual directory structure established with .en.md/.it.md suffix convention and placeholder content files | mkdocs-static-i18n docs_structure: suffix config verified; 8 nav sections mapped to directory structure; stub template defined per D-15/D-16 |
| FDN-04 | Syntax highlighting (PyMdown Extensions), admonitions, content tabs, and code copy button configured in mkdocs.yml | pymdownx.highlight, pymdownx.superfences, pymdownx.tabbed (alternate_style), admonition, content.code.copy all verified in Material docs and existing research |
</phase_requirements>

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Static site generation | Build Tool | -- | MkDocs is a build tool that transforms .md into .html; it runs at build time, not at request time |
| Theme rendering | CDN/Static | -- | Material theme generates static HTML/CSS/JS; no server-side rendering |
| Search indexing | Build Tool | Browser/Client | lunr.js index built at build time, consumed client-side |
| i18n build orchestration | Build Tool | -- | mkdocs-static-i18n runs during `mkdocs build` to produce per-language output |
| Navigation structure | Build Tool | -- | `nav` in mkdocs.yml is resolved at build time into static HTML navigation |
| Bilingual content files | File System | -- | .en.md/.it.md files are source content stored in the repo, processed at build time |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| mkdocs | 1.6.1 (pin >=1.6,<2.0) | Static site generator | Mandatory per project constraints; 2.0 breaks Material plugin system [VERIFIED: PyPI] |
| mkdocs-material | 9.7.6 (pin >=9.7,<10.0) | Theme and built-in plugins | Provides search, offline, privacy, and i18n UI integration; best-in-class docs theme [VERIFIED: PyPI] |
| mkdocs-static-i18n | 1.3.1 (pin ==1.3.1) | Bilingual content management | Community standard for MkDocs i18n; suffix-based naming, single config, language switcher [VERIFIED: PyPI] |
| pymdown-extensions | 10.21.2 (pin >=10.21,<11.0) | Markdown extensions | Required by Material for code highlighting, superfences, tabbed content, admonitions [VERIFIED: PyPI] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Pygments | >=2.16 (transitive) | Syntax highlighting engine | Bundled with pymdown-extensions; no separate install needed |
| mkdocs-material-extensions | 1.3.1 (transitive) | Emoji/icon shortcodes | Auto-installed with mkdocs-material; used for admonition icons |
| lunr-languages | (bundled with search) | Italian stemming for search | Enables per-language search indexes; configured via `search.lang: [en, it]` |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| mkdocs-static-i18n | mkdocs-i18n (abandoned) | mkdocs-i18n is unmaintained and incompatible; mkdocs-static-i18n is the standard [VERIFIED: PyPI - mkdocs-i18n last release 2021] |
| Material `group` plugin | `!ENV` conditionals | `group` is Insiders-only (paid); `!ENV` works on free tier [CITED: CONTEXT.md D-13] |
| `navigation.instant` | Standard page loads | `navigation.instant` breaks on file:// protocol; excluded per D-14 [CITED: CONTEXT.md D-14] |

**Installation:**
```bash
# Create and activate virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install core dependencies with version pins
pip install "mkdocs>=1.6,<2.0" "mkdocs-material>=9.7,<10.0" "mkdocs-static-i18n==1.3.1" "pymdown-extensions>=10.21,<11.0"

# Freeze for reproducible builds
pip freeze > requirements.txt
```

**Version verification:** All versions confirmed against PyPI on 2026-04-22:
- mkdocs 1.6.1 (latest in 1.x line)
- mkdocs-material 9.7.6 (latest stable)
- mkdocs-static-i18n 1.3.1 (latest)
- pymdown-extensions 10.21.2 (latest)

## Architecture Patterns

### System Architecture Diagram

```text
                              MARKDOWN SOURCES
                                    |
                          .en.md / .it.md files (suffix convention)
                                    |
                              +-------------+
                              | mkdocs.yml  | (single config: theme, plugins, extensions, nav)
                              +-------------+
                                    |
                          +---------+---------+
                          |                   |
                    mkdocs serve          mkdocs build
                  (local dev :8000)             |
                          |          +---------+---------+
                          |          |                   |
                          |    online build         offline build
                          |     (default)         (BUILD=offline)
                          |          |                   |
                          |          |          !ENV enables:
                          |          |          +offline +privacy
                          |          |                   |
                          |    site/ directory      site/ directory
                          |          |            (no CDN deps,
                          |          |             file:// compatible)
                          |          |                   |
                          |    Browser preview     ZIP archive
                          |                          (air-gapped)
```

### Recommended Project Structure
```text
simos-chat-docs/
  mkdocs.yml                    # Single source of configuration truth
  requirements.txt              # Pinned Python dependencies
  docs/
    index.en.md                  # English homepage
    index.it.md                  # Italian homepage
    assets/                      # Shared static assets (images, logo)
    overrides/                   # Custom template overrides (if needed)
      partials/
        announce.html            # Announcement bar placeholder (D-10)
    setup/
      installation.en.md        # Setup section stubs
      installation.it.md
      configuration.en.md
      configuration.it.md
    chat/
      getting-started.en.md     # Chat section stubs
      getting-started.it.md
      features.en.md
      features.it.md
    documents-rag/
      uploading.en.md           # Documents & RAG section stubs
      uploading.it.md
      querying.en.md
      querying.it.md
    workspaces-projects/
      workspaces.en.md          # Workspaces & Projects section stubs
      workspaces.it.md
      projects.en.md
      projects.it.md
    administration/
      rbac.en.md                 # Administration section stubs
      rbac.it.md
      settings.en.md
      settings.it.md
    api/
      endpoints.en.md            # API section stubs
      endpoints.it.md
      authentication.en.md
      authentication.it.md
    deployment/
      docker.en.md               # Deployment section stubs
      docker.it.md
      air-gap.en.md
      air-gap.it.md
    security/
      overview.en.md             # Security section stubs
      overview.it.md
      compliance.en.md
      compliance.it.md
```

### Pattern 1: Suffix-Based i18n File Naming

**What:** Content files use `.en.md` / `.it.md` suffixes, organized by topic directory, not by language directory.

**When to use:** Always for this project.

**Example:**
```yaml
# mkdocs.yml - i18n plugin configuration
plugins:
  - i18n:
      docs_structure: suffix            # D-03: suffix-based i18n
      fallback_to_default: true         # D-16: show English if Italian missing
      reconfigure_material: true        # Auto-configure theme locale + alternates
      reconfigure_search: true          # D-08: per-language search indexes
      languages:
        - locale: en
          default: true
          name: English
          site_name: AirGap AI Chatbot Docs
        - locale: it
          name: Italiano
          site_name: AirGap AI Chatbot - Documentazione
          nav_translations:
            Setup: Configurazione
            Chat: Chat
            "Documents & RAG": "Documenti e RAG"
            "Workspaces & Projects": "Aree di lavoro e Progetti"
            Administration: Amministrazione
            API: API
            Deployment: Distribuzione
            Security: Sicurezza
```

```text
# Directory layout (suffix convention)
docs/
  guides/
    getting-started.en.md    # English version
    getting-started.it.md    # Italian version (side by side)
```

Source: [CITED: ultrabug.github.io/mkdocs-static-i18n setup docs]

### Pattern 2: Conditional Plugin Loading with !ENV

**What:** Use `!ENV [OFFLINE, false]` on `offline` and `privacy` plugins instead of the Insiders-only `group` plugin.

**When to use:** For dual-distribution builds (online vs offline).

**Example:**
```yaml
# mkdocs.yml - plugin section
plugins:
  - i18n:
      # ... i18n config ...
  - search:
      lang:
        - en
        - it
      separator: '[\s\-\.]+'
  # Conditional plugins for offline build only (D-13)
  - offline:
      enabled: !ENV [OFFLINE, false]
  - privacy:
      enabled: !ENV [OFFLINE, false]
```

**Build commands:**
```bash
# Online build (default, for Netlify)
mkdocs build

# Offline build (for air-gapped distribution)
BUILD=offline mkdocs build
```

Source: [CITED: CONTEXT.md D-13], [CITED: squidfunk.github.io/mkdocs-material/plugins/offline]

### Pattern 3: Dark Mode Default Palette

**What:** Configure Material theme with dark mode as the default (slate scheme) with a toggle to light mode.

**When to use:** Per D-04 -- developer/ops audience prefers dark mode.

**Example:**
```yaml
# mkdocs.yml - theme palette (D-04: dark mode default)
theme:
  palette:
    # Dark mode (default - listed first)
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to light mode
    # Light mode
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to dark mode
```

Source: [CITED: squidfunk.github.io/mkdocs-material setup/changing-the-colors]

### Pattern 4: Minimal Content Stubs

**What:** Each `.en.md` / `.it.md` file follows the stub template per D-15/D-16.

**When to use:** For all placeholder files in Phase 1.

**English stub example:**
```markdown
# Installation

Overview of installation procedures for AirGap AI Chatbot.

*Content coming soon.*
```

**Italian stub example:**
```markdown
# Installazione

Panoramica delle procedure di installazione per AirGap AI Chatbot.

*Contenuto in arrivo.*
```

Source: [CITED: CONTEXT.md D-15, D-16]

### Anti-Patterns to Avoid

- **Anti-Pattern: Using the `group` plugin for conditional plugin loading:** The `group` plugin is Insiders-only and requires a paid license. Use `!ENV [OFFLINE, false]` conditionals on individual plugins instead. [CITED: CONTEXT.md D-13, PIT-05]
- **Anti-Pattern: Enabling `navigation.instant`:** This feature uses the Fetch API which is restricted on `file://` protocol. Even if only used for the online build, maintaining two configs is error-prone. Exclude it entirely per D-14. [CITED: CONTEXT.md D-14, PIT-03]
- **Anti-Pattern: Folder-based i18n structure:** Using `docs/en/` and `docs/it/` directories makes it harder to spot missing translations and requires maintaining separate file trees. Use suffix-based naming (`page.en.md` / `page.it.md`) per D-03. [CITED: ARCHITECTURE.md Anti-Pattern 2]
- **Anti-Pattern: Unpinned dependency ranges:** Using `mkdocs>=1.6` without an upper bound allows MkDocs 2.0 to be installed, which breaks the entire project. Pin `>=1.6,<2.0` per CLAUDE.md constraint. [CITED: CLAUDE.md, PIT-01]
- **Anti-Pattern: Wrong i18n plugin:** Installing `mkdocs-i18n` (abandoned) instead of `mkdocs-static-i18n` (maintained). Both exist on PyPI with similar names. Pin `mkdocs-static-i18n==1.3.1` explicitly. [CITED: PIT-02]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Language switching UI | Custom language toggle | Material `extra.alternate` + i18n plugin `reconfigure_material: true` | Material handles stay-on-page switching automatically; the i18n plugin configures per-language alternates [VERIFIED: ultrabug.github.io/mkdocs-static-i18n] |
| Search with Italian stemming | Custom lunr config | `search.lang: [en, it]` + `reconfigure_search: true` on i18n plugin | The i18n plugin reconfigures search per-language build automatically, including correct stemmers [VERIFIED: ultrabug.github.io/mkdocs-static-i18n] |
| Offline compatibility (file:// protocol) | Custom service worker | Material `offline` plugin with `enabled: !ENV [OFFLINE, false]` | The offline plugin handles the iframe-worker shim for search and disables `use_directory_urls`; custom service workers require HTTPS [VERIFIED: squidfunk.github.io/mkdocs-material/plugins/offline] |
| External asset bundling for air-gap | Custom download script | Material `privacy` plugin with `enabled: !ENV [OFFLINE, false]` | The privacy plugin scans HTML for external URLs, downloads them, and rewrites references; covers Google Fonts, CDN scripts, etc. [VERIFIED: squidfunk.github.io/mkdocs-material/plugins/privacy] |
| Content tabs for code examples | Custom tab HTML | `pymdownx.tabbed` with `alternate_style: true` | Material renders these as accessible, responsive tabs; custom HTML breaks offline [VERIFIED: squidfunk.github.io/mkdocs-material] |
| Navigation translation | Custom Jinja template override | i18n plugin `nav_translations` per language | The i18n plugin replaces nav labels per build automatically [VERIFIED: ultrabug.github.io/mkdocs-static-i18n/setup/localizing-navigation] |

**Key insight:** Every rendering and i18n feature needed for Phase 1 is provided by mkdocs-material and mkdocs-static-i18n out of the box. The only custom work is configuration in mkdocs.yml, not code.

## Common Pitfalls

### Pitfall 1: MkDocs 2.0 Upgrade Breaks Everything (PIT-01)
**What goes wrong:** Installing `mkdocs>=2.0` silently breaks Material theme -- the plugin system is removed and the config format changes to TOML.
**Why it happens:** MkDocs 2.0 was released in February 2026 as a complete rewrite. Without an upper bound pin, `pip install mkdocs` pulls 2.0+.
**How to avoid:** Pin `mkdocs>=1.6,<2.0` in requirements.txt. Add a comment explaining why.
**Warning signs:** `mkdocs build` fails with config format errors; `Plugin 'search' not found` errors.

### Pitfall 2: Wrong i18n Plugin Installed (PIT-02)
**What goes wrong:** Installing `mkdocs-i18n` (abandoned, last release 2021) instead of `mkdocs-static-i18n` (maintained, v1.3.1).
**Why it happens:** Both exist on PyPI with similar names.
**How to avoid:** Explicitly pin `mkdocs-static-i18n==1.3.1` in requirements.txt. Add a comment in mkdocs.yml.
**Warning signs:** `i18n` plugin not found or config key errors during build.

### Pitfall 3: Plugin Load Order Conflicts (PIT-13)
**What goes wrong:** Some plugins depend on others having run first. `search` must load after `i18n`. `offline` must load after `privacy`.
**Why it happens:** MkDocs loads plugins in YAML order, but plugin authors may not document ordering requirements.
**How to avoid:** Explicit plugin order in mkdocs.yml: `i18n` first, then `search`, then conditioned `offline` and `privacy`. Per D-07.
**Warning signs:** Search results contain duplicate entries from both languages; offline build has missing assets.

### Pitfall 4: `navigation.instant` Breaks Offline (PIT-03)
**What goes wrong:** Enabling `navigation.instant` uses the Fetch API, which is restricted on `file://` protocol. Pages fail to load in offline/air-gapped mode.
**Why it happens:** `navigation.instant` is a popular Material feature that developers reflexively enable.
**How to avoid:** Explicitly exclude `navigation.instant` from `theme.features` list. Add a comment in mkdocs.yml explaining why. Per D-14.
**Warning signs:** Links work on `http://localhost:8000` but fail when opened from file system.

### Pitfall 5: `group` Plugin Requires Insiders License (PIT-05)
**What goes wrong:** Referencing the `group` plugin in mkdocs.yml causes `Plugin 'group' not found` error on the free tier of Material.
**Why it happens:** Documentation and examples often show the `group` plugin for conditional loading, but it requires the paid Insiders license.
**How to avoid:** Use per-plugin `!ENV [OFFLINE, false]` conditionals instead. Per D-13 and D-07.
**Warning signs:** Build fails with `Plugin 'group' not found`.

### Pitfall 6: Missing `.it.md` Stub Breaks Language Switcher
**What goes wrong:** A `.en.md` file exists without a corresponding `.it.md` file. The language switcher links to a 404.
**Why it happens:** Authoring content in one language first and forgetting the partner file.
**How to avoid:** Always create bilingual pairs per D-16. Use `fallback_to_default: true` in i18n config as a safety net (shows English content at Italian URL rather than 404).
**Warning signs:** Language switcher leads to 404 pages; build warnings about missing translations.

## Code Examples

### Complete mkdocs.yml for Phase 1

This is the target configuration that satisfies all FDN-01 through FDN-04 requirements plus all CONTEXT.md decisions.

```yaml
# mkdocs.yml - AirGap AI Chatbot Documentation Portal
# Phase 1: Foundation configuration
#
# CRITICAL CONSTRAINTS:
# - MkDocs must stay on 1.x (2.0 breaks Material plugin system) -- see PIT-01
# - Do NOT enable navigation.instant (breaks on file:// protocol) -- see PIT-03
# - Use !ENV conditionals for offline/privacy, NOT the group plugin -- see PIT-05
# - Use mkdocs-static-i18n, NOT mkdocs-i18n (abandoned) -- see PIT-02

site_name: AirGap AI Chatbot Docs
site_url: https://docs.airgap-chatbot.example.com/
site_description: >-
  Documentation for AirGap AI Chatbot - enterprise-grade, local-first,
  privacy-first AI chat workspace

# Repository integration
repo_url: https://github.com/elia/simos-chat-docs
repo_name: elia/simos-chat-docs
edit_uri: edit/main/docs/

# Theme configuration (D-04: dark mode default, D-06: default Material theme)
theme:
  name: material
  language: en  # Default language; i18n plugin overrides per-build
  # D-14: navigation.instant is EXCLUDED (breaks on file:// protocol)
  features:
    - navigation.tabs          # D-02: Top-level sections as tabs
    - navigation.sections      # D-02: Grouped sidebar sections
    - navigation.indexes       # Section index pages
    - navigation.top           # Back-to-top button
    - navigation.trail         # Breadcrumbs (D-02)
    - navigation.footer        # D-12: Footer prev/next links
    - search.suggest           # Search autocomplete
    - search.highlight         # Highlight search results
    - content.code.copy        # FDN-04: Code copy button
    - content.code.annotate    # Code annotations support
    - content.tooltips         # Hover tooltips for abbreviations
  palette:
    # D-04: Dark mode as default (listed first)
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to light mode
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to dark mode
  # D-05: Logo placeholder (asset to be provided later)
  # logo: assets/logo.svg
  # D-11: TOC on right side (default behavior, no feature flag needed)

# Plugins (D-07: explicit load order: i18n -> search -> conditioned offline/privacy)
plugins:
  - i18n:
      docs_structure: suffix            # D-03: suffix-based i18n
      fallback_to_default: true         # D-16: show English if Italian missing
      reconfigure_material: true        # Auto-configure theme locale + alternates
      reconfigure_search: true          # D-08: per-language search indexes
      languages:
        - locale: en
          default: true
          name: English
          site_name: AirGap AI Chatbot Docs
        - locale: it
          name: Italiano
          site_name: AirGap AI Chatbot - Documentazione
          nav_translations:
            Setup: Configurazione
            Chat: Chat
            "Documents & RAG": "Documenti e RAG"
            "Workspaces & Projects": "Aree di lavoro e Progetti"
            Administration: Amministrazione
            API: API
            Deployment: Distribuzione
            Security: Sicurezza
  - search:
      lang:
        - en
        - it                        # D-08: bilingual search with Italian stemming
      separator: '[\s\-\.]+'
  # D-13: Conditioned on !ENV for offline build only (NOT group plugin)
  - offline:
      enabled: !ENV [OFFLINE, false]
  - privacy:
      enabled: !ENV [OFFLINE, false]

# Markdown extensions (FDN-04: syntax highlighting, admonitions, content tabs)
markdown_extensions:
  - pymdownx.highlight:             # Syntax highlighting
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
  - pymdownx.inlinehilite            # Inline code highlighting
  - pymdownx.snippets                # Include code from files
  - pymdownx.superfences             # Nested code blocks, Mermaid diagrams
  - pymdownx.tabbed:                 # FDN-04: Content tabs
      alternate_style: true
  - pymdownx.details                 # Collapsible admonitions
  - pymdownx.emoji:                  # Emoji support in admonitions
      emoji_index: !!python/name:material.extensions.emoji.twemoji
      emoji_generator: !!python/name:material.extensions.emoji.to_svg
  - admonition                       # FDN-04: Callouts (note, warning, tip)
  - attr_list                        # HTML attributes on elements
  - def_list                         # Definition lists
  - footnotes                        # Footnotes
  - md_in_html                       # Markdown inside HTML blocks
  - tables                          # Tables support
  - toc:                             # D-11: Table of contents with permalinks
      permalink: true
      toc_depth: 3

# Navigation (D-01: feature-area-based, D-02: 8 sections, 2-3 levels)
nav:
  - Home: index.md
  - Setup:
    - setup/index.md
    - Installation: setup/installation.md
    - Configuration: setup/configuration.md
  - Chat:
    - chat/index.md
    - Getting Started: chat/getting-started.md
    - Features: chat/features.md
  - "Documents & RAG":
    - documents-rag/index.md
    - Uploading: documents-rag/uploading.md
    - Querying: documents-rag/querying.md
  - "Workspaces & Projects":
    - workspaces-projects/index.md
    - Workspaces: workspaces-projects/workspaces.md
    - Projects: workspaces-projects/projects.md
  - Administration:
    - administration/index.md
    - RBAC: administration/rbac.md
    - Settings: administration/settings.md
  - API:
    - api/index.md
    - Endpoints: api/endpoints.md
    - Authentication: api/authentication.md
  - Deployment:
    - deployment/index.md
    - Docker: deployment/docker.md
    - "Air-Gap Setup": deployment/air-gap.md
  - Security:
    - security/index.md
    - Overview: security/overview.md
    - Compliance: security/compliance.md

# Extra configuration
extra:
  alternate:
    - name: English
      link: /en/
      lang: en
    - name: Italiano
      link: /it/
      lang: it

# D-10: Announcement bar placeholder (content in Phase 2)
# To activate, create docs/overrides/partials/announce.html

# D-09: Print-to-PDF support is built into Material theme
# (accessible via browser print dialog, no config needed)
```

### Stub Template (per D-15/D-16)

**English stub pattern:**
```markdown
# {Title}

{One-line description in English.}

*Content coming soon.*
```

**Italian stub pattern:**
```markdown
# {Titolo}

{One-line description in Italian.}

*Contenuto in arrivo.*
```

### requirements.txt Template

```
# Core dependencies - pinned to compatible versions
# MkDocs must stay on 1.x - 2.0 breaks the Material plugin system (PIT-01)
mkdocs>=1.6,<2.0
mkdocs-material>=9.7,<10.0
# i18n plugin - use mkdocs-static-i18n, NOT mkdocs-i18n (abandoned) (PIT-02)
mkdocs-static-i18n==1.3.1
pymdown-extensions>=10.21,<11.0
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|-------------|------------------|--------------|--------|
| `mkdocs-i18n` plugin | `mkdocs-static-i18n` plugin | ~2022 | mkdocs-i18n is abandoned; static-i18n is the maintained standard [VERIFIED: PyPI] |
| `group` plugin for conditional builds | `!ENV` conditionals on individual plugins | 2024-2025 | `group` requires Insiders license; `!ENV` works on free tier [VERIFIED: squidfunk.github.io/mkdocs-material] |
| `pymdownx.tabbed` without `alternate_style` | `pymdownx.tabbed` with `alternate_style: true` | pymdown-extensions 9.x+ | Old style is deprecated; alternate_style is required for Material [VERIFIED: squidfunk.github.io/mkdocs-material] |
| Per-language mkdocs.yml (projects plugin) | Single mkdocs.yml with i18n plugin | mkdocs-static-i18n 1.x | Single config is easier to maintain; projects plugin requires separate configs per language [VERIFIED: ultrabug.github.io/mkdocs-static-i18n] |
| `navigation.instant` feature | Explicit exclusion | Ongoing | `navigation.instant` breaks on `file://` protocol; must be excluded for air-gap compatibility [VERIFIED: PIT-03] |

**Deprecated/outdated:**
- `mkdocs-i18n`: Abandoned, incompatible with Material. Do not use. [VERIFIED: PyPI - last release 2021]
- `group` plugin: Requires paid Insiders license. Use `!ENV` conditionals instead. [VERIFIED: squidfunk.github.io/mkdocs-material/plugins/group]
- MkDocs 2.0: Released February 2026. Breaks Material plugin system. Pin to 1.x. [VERIFIED: squidfunk.github.io/mkdocs-material/blog/2026/02/18/mkdocs-2.0]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `reconfigure_material: true` automatically configures Material's `extra.alternate` language switcher from the i18n plugin's `languages` config | Architecture Patterns | Language switcher would not appear; manual `extra.alternate` configuration would be needed |
| A2 | `reconfigure_search: true` with `search.lang: [en, it]` produces separate per-language search indexes | Architecture Patterns | Search results would mix English and Italian content |
| A3 | Dark mode default works by placing the `scheme: slate` entry first in the palette list | Code Examples | Light mode would be default instead |
| A4 | Print-to-PDF support is built into Material theme and requires no additional configuration (D-09) | Code Examples | Print button might not appear in theme |
| A5 | Announcement bar requires creating `docs/overrides/partials/announce.html` and does not need a feature flag | Code Examples | Announcement might not display correctly |
| A6 | The 8 nav section names (Setup, Chat, Documents & RAG, Workspaces & Projects, Administration, API, Deployment, Security) are appropriate labels derived from the product's feature areas per the README | Code Examples | Nav labels may need adjustment in Phase 2 when content is written |

## Open Questions

1. **Announcement bar content (D-10)**
   - What we know: CONTEXT.md says "placeholder content for Phase 2"
   - What's unclear: Should Phase 1 include an empty `announce.html` override file, or defer the file creation entirely to Phase 2?
   - Recommendation: Create a minimal `docs/overrides/partials/announce.html` with empty/placeholder text so the theme feature is confirmed working.

2. **Site URL (site_url in mkdocs.yml)**
   - What we know: The project will be deployed to Netlify (Phase 3), but the actual domain is not yet configured.
   - What's unclear: What URL to use for `site_url` in Phase 1.
   - Recommendation: Use a placeholder like `https://docs.airgap-chatbot.example.com/` and update it in Phase 3 when the domain is known.

3. **Logo asset (D-05)**
   - What we know: D-05 says "Text/SVG logo placeholder in header -- asset to be provided later"
   - What's unclear: Should Phase 1 create a placeholder SVG, or comment out the logo line entirely?
   - Recommendation: Comment out the `logo:` line in mkdocs.yml with a note that the asset will be provided later. Material theme renders the site name as text when no logo is set.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Python | MkDocs runtime | Yes | 3.14.3 | -- |
| pip | Package management | Yes | 26.0.1 | -- |
| mkdocs | Static site generator | Yes | 1.6.1 | -- |
| mkdocs-material | Theme + plugins | Yes | 9.7.6 | -- |
| mkdocs-static-i18n | i18n plugin | Yes | 1.3.1 | -- |
| pymdown-extensions | Markdown extensions | Yes | 10.21.2 | -- |
| python3 -m venv | Virtual environment | Yes | -- | -- |
| git | Version control | Yes | -- | -- |

**Missing dependencies with no fallback:**
- None -- all required dependencies are installed.

**Missing dependencies with fallback:**
- None needed.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Manual verification via `mkdocs serve` + `mkdocs build --strict` |
| Config file | mkdocs.yml (validates at build time) |
| Quick run command | `mkdocs serve` (starts dev server on :8000) |
| Full suite command | `mkdocs build --strict` (validates config, plugins, and nav) |

### Phase Requirements to Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| FDN-01 | MkDocs project initializes with Material theme and core plugins | smoke | `mkdocs build --strict && echo "OK"` | N/A (create) |
| FDN-01 | `mkdocs serve` starts and renders site locally | manual | `mkdocs serve` (verify in browser) | N/A |
| FDN-02 | All dependencies installable from requirements.txt without version conflicts | unit | `pip install -r requirements.txt && mkdocs --version` | N/A (create) |
| FDN-02 | MkDocs version is 1.6.x (not 2.x) | unit | `mkdocs --version \| grep "1.6"` | N/A |
| FDN-03 | Bilingual directory structure with .en.md/.it.md suffix files | unit | `find docs/ -name "*.en.md" \| wc -l && find docs/ -name "*.it.md" \| wc -l` | N/A (create) |
| FDN-03 | Each .en.md has a corresponding .it.md file | unit | Script to compare file pairs | N/A (create) |
| FDN-04 | Syntax highlighting renders in code blocks | manual | Visual check on `mkdocs serve` | N/A |
| FDN-04 | Admonitions render (note, warning, tip) | manual | Visual check on `mkdocs serve` | N/A |
| FDN-04 | Content tabs render with `===` syntax | manual | Visual check on `mkdocs serve` | N/A |
| FDN-04 | Code copy button appears on code blocks | manual | Visual check on `mkdocs serve` | N/A |
| D-04 | Dark mode is default palette | manual | Visual check on `mkdocs serve` | N/A |
| D-07 | Plugin load order is i18n -> search -> offline/privacy | unit | `grep -A1 "plugins:" mkdocs.yml` | N/A (create) |
| D-13 | offline/privacy plugins use `!ENV [OFFLINE, false]` | unit | `grep "OFFLINE" mkdocs.yml` | N/A (create) |
| D-14 | `navigation.instant` is NOT in features list | unit | `grep "navigation.instant" mkdocs.yml && echo "FAIL" \|\| echo "OK"` | N/A (create) |

### Sampling Rate
- **Per task commit:** `mkdocs build --strict` (validates config and nav structure)
- **Per wave merge:** `mkdocs serve` manual verification of all FDN-04 features
- **Phase gate:** Full `mkdocs build --strict` + manual browser verification

### Wave 0 Gaps
- [ ] `requirements.txt` -- pinned dependencies with version constraints (FDN-02)
- [ ] `mkdocs.yml` -- complete configuration (FDN-01, FDN-03, FDN-04)
- [ ] `docs/` directory structure -- bilingual stub files (FDN-03)
- [ ] No automated test framework needed -- validation is `mkdocs build --strict` + manual browser check

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|----------------|---------|-----------------|
| V2 Authentication | No | Static site, no authentication |
| V3 Session Management | No | Static site, no sessions |
| V4 Access Control | No | Static site, no access control |
| V5 Input Validation | Yes | YAML config validation via `mkdocs build --strict` |
| V6 Cryptography | No | No cryptographic operations in this phase |

### Known Threat Patterns for MkDocs Static Site

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Dependency confusion (supply chain) | Tampering | Pin exact versions in requirements.txt |
| Config injection (malicious YAML) | Tampering | `mkdocs build --strict` validates config; no dynamic YAML loading |
| CDN dependency leak (offline build) | Information Disclosure | Privacy plugin with `!ENV [OFFLINE, false]` conditional |

## Sources

### Primary (HIGH confidence)
- Context7 /squidfunk/mkdocs-material -- theme configuration, plugins, features, offline/privacy setup
- Context7 /mkdocs/mkdocs -- core configuration, plugin system, build commands
- ultrabug.github.io/mkdocs-static-i18n -- i18n plugin configuration (docs_structure, reconfigure_search, reconfigure_material, nav_translations, fallback_to_default)
- PyPI version indexes -- mkdocs 1.6.1, mkdocs-material 9.7.6, mkdocs-static-i18n 1.3.1, pymdown-extensions 10.21.2
- CONTEXT.md (phase decisions) -- locked decisions D-01 through D-16
- CLAUDE.md (project constraints) -- MkDocs >=1.6,<2.0, mkdocs-static-i18n, !ENV conditionals, no navigation.instant

### Secondary (MEDIUM confidence)
- Project-level research in .planning/research/ (SUMMARY.md, PITFALLS.md, ARCHITECTURE.md, FEATURES.md, STACK.md)
- PyPI package metadata for mkdocs-i18n (abandoned) vs mkdocs-static-i18n (maintained)
- Installed package versions verified on development machine

### Tertiary (LOW confidence)
- None -- all claims verified against primary or secondary sources

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - all packages verified against PyPI and installed locally
- Architecture: HIGH - mkdocs.yml configuration derived from official docs and verified plugin syntax
- Pitfalls: HIGH - all 6 Phase 1 pitfalls (PIT-01 through PIT-05, PIT-13) documented in project-level research and verified against official docs

**Research date:** 2026-04-22
**Valid until:** 2026-05-22 (stable tech, 30-day validity)