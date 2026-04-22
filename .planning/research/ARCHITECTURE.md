# Architecture Patterns

**Domain:** MkDocs Material documentation portal with bilingual (en/it) content and dual distribution (online + air-gapped offline)
**Researched:** 2026-04-22

## Recommended Architecture

```text
                              CONTENT SOURCES
                                    |
                              .md files (en/it)
                                    |
                              +-----------+
                              | mkdocs.yml|  (single config, i18n plugin)
                              +-----------+
                                    |
                    +---------------+---------------+
                    |                               |
              mkdocs serve                   mkdocs build
            (local dev :8000)                    |
                    |                    +--------+--------+
                    |                    |                  |
                    |              online build        offline build
                    |               (default)          (BUILD=offline)
                    |                    |                  |
                    |                    |          group plugin enables:
                    |                    |          +offline +privacy
                    |                    |                  |
                    |              site/ directory      site/ directory
                    |                    |            (no CDN deps,
                    |                    |             search via JS worker,
                    |                    |             use_directory_urls=false)
                    |                    |                  |
                    |              Netlify deploy      ZIP archive
                    |              (auto on push)     (air-gapped delivery)
                    |                    |                  |
                    v                    v                  v
              Browser (live)     https://docs...      file:///path/to/site/
```

### Component Overview

```text
simos-chat-docs/
  mkdocs.yml                    # Single source of configuration truth
  requirements.txt              # Python dependencies (pinned)
  netlify.toml                  # Netlify build/deploy configuration
  .github/workflows/ci.yml      # GitHub Actions CI pipeline
  scripts/
    build-offline.sh             # Offline build wrapper script
  docs/
    index.en.md                  # English homepage
    index.it.md                  # Italian homepage
    guides/
      getting-started.en.md
      getting-started.it.md
      deployment.en.md
      deployment.it.md
    api/
      endpoints.en.md
      endpoints.it.md
      authentication.en.md
      authentication.it.md
    procedures/
      backup-restore.en.md
      backup-restore.it.md
      air-gap-setup.en.md
      air-gap-setup.it.md
    reference/
      configuration.en.md
      configuration.it.md
      rbac-permissions.en.md
      rbac-permissions.it.md
    assets/                      # Shared static assets (images, etc.)
      logo.svg
      screenshot.png
    overrides/                    # Custom template overrides (if needed)
      partials/
        footer.html
```

## Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|---------------|-------------------|
| mkdocs.yml | Central configuration: theme, plugins, extensions, nav, i18n | MkDocs engine (input) |
| mkdocs-static-i18n | Multilingual build orchestration: per-language nav, search, URLs, language switcher | MkDocs on_config, on_files, on_nav, on_page_context hooks |
| Material theme | Visual rendering, navigation UI, search UI, responsive layout | MkDocs template engine |
| search plugin | Per-language search index generation, lunr stemmer config | i18n plugin (reconfigure_search), offline plugin (JS worker) |
| offline plugin | Disables use_directory_urls, embeds search worker as JS+iframe for file:// protocol | group plugin (conditional enable) |
| privacy plugin | Downloads all external assets (fonts, JS, CSS) locally for self-contained build | group plugin (conditional enable) |
| group plugin | Conditional plugin loading based on environment variables (BUILD=offline vs default) | mkdocs.yml plugins section |
| optimize plugin | Compresses media (images) during build | group plugin (conditional enable) |
| netlify.toml | Build command, publish directory, redirect rules | Netlify CI/CD system |
| GitHub Actions | CI pipeline: lint, build online, build offline, deploy | mkdocs build, Netlify |
| build-offline.sh | Wrapper: sets BUILD=offline env var, runs mkdocs build, produces ZIP | mkdocs build, group plugin |
| docs/*.md | Content source files (bilingual, suffix naming) | i18n plugin (input), MkDocs engine (input) |
| site/ | Build output directory (static HTML + assets) | mkdocs build (output), Netlify (deploy input) |

## Data Flow

### 1. Content Authoring Flow

```text
Author writes index.en.md + index.it.md
    |
    v
Git commit and push to main branch
    |
    v
GitHub Actions triggers
    |
    v
pip install -r requirements.txt
    |
    v
mkdocs build  (produces site/ with en/ + it/ subdirectories)
    |
    v
Netlify deploys site/  (https://docs.example.com/)
```

### 2. i18n Build Flow (inside mkdocs build)

```text
mkdocs.yml with i18n plugin config
    |
    v
i18n.on_config:  Set current_language, reconfigure theme locale, search lang
    |
    v
i18n.on_files:   For default language (en):
    |               - Match index.en.md as "index.md"
    |               - Build file tree, set alternates map
    |               For each non-default language (it):
    |               - Match index.it.md as "index.md" under /it/ prefix
    |               - Build file tree, set alternates map
    v
i18n.on_nav:     Translate navigation labels per nav_translations config
    |               Reconfigure Material language switcher (alternate links)
    v
i18n.on_page_context: Set page.locale, page.language metadata
    |
    v
i18n.on_post_build: Build remaining languages iteratively
    |                  (calls mkdocs.commands.build for each locale)
    v
i18n.reconfigure_search_index: Merge per-language search indexes
    |
    v
Output: site/ with structure:
    site/
      index.html               (English default)
      guides/
        getting-started/
          index.html
      it/
        index.html             (Italian)
        guides/
          getting-started/
            index.html
      search/
        search_index.en.json   (English search index)
        search_index.it.json   (Italian search index)
      sitemap.xml              (with xhtml:link alternates)
```

### 3. Offline Build Flow

```text
BUILD=offline mkdocs build
    |
    v
group plugin reads BUILD env var
    |
    v
Enables: offline + privacy + optimize plugins
    |
    v
offline plugin:
    - Sets use_directory_urls: false (generates page.html instead of page/index.html)
    - Embeds search worker as JS file with iframe-worker shim
    |
    v
privacy plugin:
    - Scans HTML for external asset references
    - Downloads fonts, JS, CSS locally
    - Rewrites references to point to local copies
    |
    v
optimize plugin:
    - Compresses images and media
    |
    v
Output: site/ that works on file:// protocol
    - No CDN calls
    - No external font requests
    - Search works via JS worker shim
    |
    v
scripts/build-offline.sh packages site/ into docs-offline.zip
```

### 4. Search Architecture

```text
Online build:
    search plugin generates per-language lunr indexes
    i18n plugin configures lang: [en, it] on search plugin
    Material search UI uses language-aware index
    User switches language -> different search index used

Offline build:
    search index moved to search_index.json (single JS file)
    iframe-worker shim wraps Web Worker execution for file:// protocol
    search still functional without HTTP server
```

## Patterns to Follow

### Pattern 1: Suffix-Based i18n File Naming

**What:** Use mkdocs-static-i18n with `docs_structure: suffix` to name content files with locale suffixes (e.g., `index.en.md`, `index.it.md`) rather than organizing into language folders.

**When:** Always. This is the recommended approach for this project.

**Why over folder structure:**
- Single mkdocs.yml instead of per-language configs (projects plugin needs separate mkdocs.yml per language)
- Content stays organized by topic, not by language (easier to spot missing translations)
- mkdocs-static-i18n auto-configures Material theme, search, and language switcher
- Fallback to default language when a translation is missing (`fallback_to_default: true`)

**Example:**
```yaml
# mkdocs.yml
plugins:
  - i18n:
      docs_structure: suffix
      fallback_to_default: true
      reconfigure_material: true
      reconfigure_search: true
      languages:
        - locale: en
          default: true
          name: English
          site_name: AirGap AI Chatbot Docs
        - locale: it
          name: Italiano
          site_name: AirGap AI Chatbot - Documentazione
          nav_translations:
            Guides: Guide
            API: API
            Procedures: Procedure
            Reference: Riferimento
```

```text
docs/
  index.en.md           # English homepage
  index.it.md           # Italian homepage
  guides/
    getting-started.en.md
    getting-started.it.md
```

### Pattern 2: Conditional Plugin Groups for Dual Distribution

**What:** Use Material's built-in `group` plugin to conditionally enable offline/privacy/optimize plugins only for the offline build, keeping the online build lean.

**When:** Always. The online build should not have use_directory_urls disabled or unnecessary asset inlining.

**Example:**
```yaml
plugins:
  - search
  - i18n:
      # ... i18n config ...

  # Offline-only plugins (enabled when BUILD=offline)
  - group:
      enabled: !ENV [BUILD, ""] == "offline"
      plugins:
        - offline
        - privacy
        - optimize
```

**Build commands:**
```bash
# Online build (Netlify, GitHub Actions)
mkdocs build

# Offline build (air-gapped distribution)
BUILD=offline mkdocs build
```

### Pattern 3: Shared Assets Without Suffixes

**What:** Place images and other static assets in `docs/assets/` without locale suffixes. Reference them directly in markdown. mkdocs-static-i18n resolves asset lookups with fallback.

**When:** For assets that are language-agnostic (screenshots may need locale variants, but logos and diagrams usually do not).

**Example:**
```text
docs/
  assets/
    logo.svg              # Shared across all languages
    architecture.en.png   # English-specific diagram (suffix for localized images)
    architecture.it.png   # Italian-specific diagram
  guides/
    deployment.en.md      # Reference: ![Architecture](../assets/architecture.png)
    deployment.it.md      # i18n resolves to architecture.it.png, falls back to .en.png
```

### Pattern 4: Navigation Structure with i18n Translations

**What:** Define navigation in mkdocs.yml using the default language, then translate section labels via `nav_translations` in the i18n language config.

**When:** Always. Keeps nav structure DRY.

**Example:**
```yaml
nav:
  - Home: index.md
  - Guides:
    - Getting Started: guides/getting-started.md
    - Deployment: guides/deployment.md
  - API Reference:
    - Endpoints: api/endpoints.md
    - Authentication: api/authentication.md
  - Procedures:
    - Backup and Restore: procedures/backup-restore.md
    - Air-Gap Setup: procedures/air-gap-setup.md
  - Reference:
    - Configuration: reference/configuration.md
    - RBAC Permissions: reference/rbac-permissions.md
```

```yaml
# In the i18n languages section for Italian:
- locale: it
  name: Italiano
  nav_translations:
    Guides: Guide
    Getting Started: Per Iniziare
    Deployment: Distribuzione
    API Reference: Riferimento API
    Endpoints: Endpoint
    Authentication: Autenticazione
    Procedures: Procedure
    Backup and Restore: Backup e Ripristino
    Air-Gap Setup: Configurazione Air-Gap
    Reference: Riferimento
    Configuration: Configurazione
    RBAC Permissions: Permessi RBAC
```

### Pattern 5: Netlify Deployment with Redirects

**What:** Configure Netlify to deploy the `site/` directory and handle language-aware redirects (root `/` redirects to `/en/` or browser language).

**When:** Always for the online distribution.

**netlify.toml:**
```toml
[build]
  command = "pip install -r requirements.txt && mkdocs build"
  publish = "site"

[[redirects]]
  from = "/"
  to = "/en/"
  status = 302
  # Netlify handles language negotiation automatically
```

### Pattern 6: Offline Build Script

**What:** A shell script that sets the environment variable, runs the offline build, and packages the result as a ZIP archive for air-gapped delivery.

**When:** Always for the offline distribution path.

**scripts/build-offline.sh:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Build for offline distribution
export BUILD=offline
mkdocs build --clean

# Package as ZIP
VERSION=$(git describe --tags --always 2>/dev/null || echo "dev")
zip -r "docs-offline-${VERSION}.zip" site/

echo "Offline build complete: docs-offline-${VERSION}.zip"
echo "Deploy this ZIP to air-gapped environments."
echo "Extract and open site/index.html in any browser."
```

## Anti-Patterns to Avoid

### Anti-Pattern 1: Per-Language mkdocs.yml Files (Projects Plugin)

**What:** Using Material's built-in `projects` plugin to create separate mkdocs.yml per language in a `projects/en/` and `projects/it/` directory structure.

**Why bad:** Requires duplicating the entire configuration for each language. Every plugin, extension, and nav change must be synchronized across multiple config files. The projects plugin also creates separate search indexes per language with no unified sitemap, and has documented limitations for multi-language support.

**Instead:** Use mkdocs-static-i18n with a single mkdocs.yml. It auto-configures Material theme, search, and language switcher from one config, and produces a unified site with per-language sections and cross-language alternates.

### Anti-Pattern 2: Folder-Based i18n Docs Structure

**What:** Using `docs_structure: folder` in mkdocs-static-i18n, organizing content as `docs/en/guides/getting-started.md` and `docs/it/guides/getting-started.md`.

**Why bad:** Makes it harder to spot missing translations. When you add a new page, you must create files in two separate directory trees. Content organization is by language rather than by topic, which fragments the authoring experience.

**Instead:** Use `docs_structure: suffix` so that `docs/guides/getting-started.en.md` and `docs/guides/getting-started.it.md` sit side-by-side. Missing translations are immediately visible as absent `.it.md` files alongside their `.en.md` counterparts.

### Anti-Pattern 3: Applying Offline Plugin to Online Build

**What:** Enabling the `offline` plugin (which disables `use_directory_urls`) or `privacy` plugin for the Netlify deployment.

**Why bad:** The online build benefits from clean URLs (`/guides/getting-started/` instead of `/guides/getting-started.html`). The `privacy` plugin downloads and inlines external assets unnecessarily for the online build, increasing deploy time and cache-busting issues. The online build can and should use CDN-hosted fonts and assets for better caching.

**Instead:** Use the `group` plugin with `!ENV` conditionals so offline-only plugins activate only during offline builds. Online builds stay lean with directory URLs and CDN assets.

### Anti-Pattern 4: Missing Fallback Content

**What:** Creating `.en.md` files without corresponding `.it.md` files and not enabling `fallback_to_default: true`.

**Why bad:** Italian users will see 404 pages for untranslated content, breaking the browsing experience.

**Instead:** Always set `fallback_to_default: true` in the i18n plugin config. When `index.it.md` is missing, the build falls back to `index.en.md` content under the Italian URL path. The language switcher still appears, and users see content rather than errors.

### Anti-Pattern 5: Custom Plugin Development

**What:** Writing a custom MkDocs plugin to handle i18n, search, or offline behavior.

**Why bad:** The project constraint explicitly states "No custom plugin development -- use existing MkDocs/Material plugins only." mkdocs-static-i18n, the Material offline plugin, and the Material privacy plugin together cover all requirements. Custom plugins add maintenance burden and break on MkDocs upgrades.

**Instead:** Use the existing plugin ecosystem: mkdocs-static-i18n for i18n, Material's offline + privacy + group plugins for dual distribution, and Material's built-in search for offline-capable full-text search.

## Scalability Considerations

| Concern | At 50 pages | At 200 pages | At 1000 pages |
|---------|-------------|--------------|---------------|
| Build time | Less than 5s (negligible) | 15-30s (acceptable) | 60-120s (consider projects plugin split) |
| Search index | Small, instant | Moderate, fast | Large; consider segmenting by section |
| i18n build | 2 passes (en+it), fast | 2 passes, manageable | 2 passes, slow; consider build caching |
| Offline ZIP | Under 10MB | 30-50MB | 100MB+; consider per-section archives |
| Authoring UX | Side-by-side .en/.it files easy to track | Use build warnings for missing translations | Consider translation management tool (Weblate) |
| Netlify deploy | Instant | 30-60s build | 2-5min build; consider pre-built artifacts |

## Build Order and Dependencies

The build pipeline has a strict dependency order. Each phase depends on the output of the previous one.

```text
Phase 1: Foundation (must come first)
  mkdocs.yml configuration
  requirements.txt with pinned versions
  docs/ directory structure
    |
    v
Phase 2: Content and i18n (depends on Phase 1)
  Markdown content files (.en.md, .it.md)
  i18n plugin configuration (languages, nav_translations)
  Search plugin configuration (lang: [en, it])
  Material theme features (nav.tabs, nav.sections, etc.)
    |
    v
Phase 3: Online Distribution (depends on Phase 2, can parallel with Phase 4)
  Netlify configuration (netlify.toml)
  GitHub Actions CI pipeline
  DNS and HTTPS setup
    |
    v
Phase 4: Offline Distribution (depends on Phase 2, can parallel with Phase 3)
  group plugin configuration for conditional builds
  offline plugin (file:// compatibility)
  privacy plugin (asset inlining)
  build-offline.sh script
  ZIP packaging and delivery process
```

**Key dependency: Phases 3 and 4 both depend on Phase 2, but are independent of each other.** The online and offline distributions can be configured and tested in parallel once the i18n content system is in place.

## Recommended mkdocs.yml Structure

This is the target configuration the architecture converges toward:

```yaml
site_name: AirGap AI Chatbot Docs
site_url: https://docs.airgap-chat.example.com/
site_description: >-
  Documentation for AirGap AI Chatbot - enterprise-grade, local-first,
  privacy-first AI chat workspace

# Repository integration
repo_url: https://github.com/elia/simos-chat-docs
repo_name: elia/simos-chat-docs
edit_uri: edit/main/docs/

# Theme configuration
theme:
  name: material
  language: en  # Default language; i18n overrides per-build
  features:
    - navigation.tabs         # Top-level sections as tabs
    - navigation.sections     # Grouped sidebar sections
    - navigation.indexes       # Section index pages
    - navigation.top           # Back-to-top button
    - navigation.trail         # Breadcrumb navigation
    - search.suggest           # Search suggestions
    - search.highlight         # Highlight search results
    - search.share             # Share search results link
    - content.code.copy        # Copy code button
    - content.code.annotate    # Code annotations
  palette:
    - media: "(prefers-color-scheme)"
      toggle:
        icon: material/brightness-auto
        name: Switch to light mode
    - scheme: default
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - scheme: slate
      toggle:
        icon: material/brightness-4
        name: Switch to light mode

# Plugins
plugins:
  - search:
      lang:
        - en
        - it
      separator: '[\s\-\.]+'
  - i18n:
      docs_structure: suffix
      fallback_to_default: true
      reconfigure_material: true
      reconfigure_search: true
      languages:
        - locale: en
          default: true
          name: English
          site_name: AirGap AI Chatbot Docs
        - locale: it
          name: Italiano
          site_name: AirGap AI Chatbot - Documentazione
          nav_translations:
            Guides: Guide
            Getting Started: Per Iniziare
            Deployment: Distribuzione
            API Reference: Riferimento API
            Procedures: Procedure
            Reference: Riferimento

  # Conditional plugins for offline build only
  - group:
      enabled: !ENV [BUILD, ""] == "offline"
      plugins:
        - offline
        - privacy
        - optimize

# Markdown extensions
markdown_extensions:
  - admonition            # Callouts (note, warning, tip)
  - attr_list             # HTML attributes on elements
  - def_list              # Definition lists
  - footnotes             # Footnotes
  - md_in_html            # Markdown inside HTML blocks
  - toc:
      permalink: true     # Permanent links to headings
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.superfences  # Nested code blocks, Mermaid diagrams
  - pymdownx.tabbed:
      alternate_style: true
  - pymdownx.details      # Collapsible admonitions
  - pymdownx.emoji:
      emoji_index: !!python/name:material.extensions.emoji.twemoji
      emoji_generator: !!python/name:material.extensions.emoji.to_svg

# Navigation (defined in default language, i18n translates labels)
nav:
  - Home: index.md
  - Guides:
    - Getting Started: guides/getting-started.md
    - Deployment: guides/deployment.md
  - API Reference:
    - Endpoints: api/endpoints.md
    - Authentication: api/authentication.md
  - Procedures:
    - Backup and Restore: procedures/backup-restore.md
    - Air-Gap Setup: procedures/air-gap-setup.md
  - Reference:
    - Configuration: reference/configuration.md
    - RBAC Permissions: reference/rbac-permissions.md

# Extra configuration
extra:
  alternate:
    - name: English
      link: /en/
      lang: en
    - name: Italiano
      link: /it/
      lang: it

# Build directories
docs_dir: docs
site_dir: site
```

## Sources

- MkDocs Material official documentation (Context7): project structure, i18n, projects plugin, offline plugin, privacy plugin, group plugin, search configuration, navigation features (HIGH confidence)
- MkDocs core documentation (Context7): configuration reference, build commands, site_dir, deploy targets (HIGH confidence)
- mkdocs-static-i18n v1.3.1 source code: plugin.py, config.py, suffix.py, folder.py, reconfigure.py -- inspected for architecture understanding (HIGH confidence)
- MkDocs Material v9.7.6 installed locally, inspected plugin capabilities (HIGH confidence)
- PROJECT.md: project requirements and constraints (HIGH confidence)