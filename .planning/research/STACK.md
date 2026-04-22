# Technology Stack

**Project:** AirGap AI Chatbot -- Documentation Portal
**Researched:** 2026-04-22

## Recommended Stack

### Core Framework

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| MkDocs | 1.6.1 (pin to >=1.6,<2.0) | Static site generator | Mandatory per project constraints. MkDocs 2.0 is a breaking rewrite that removes the plugin system and changes config format to TOML -- it is incompatible with Material for MkDocs. Pin to the 1.x line to avoid a forced migration. |
| mkdocs-material | 9.7.6 (pin to >=9.5,<10.0) | Theme and plugin ecosystem | Best-in-class documentation theme. Ships built-in search, offline, privacy, and social plugins. 60+ locale support. Active development. The 9.x line is compatible with MkDocs 1.6.x. |
| Python | >=3.10,<4.0 | Runtime for MkDocs and plugins | MkDocs and its plugins are Python. Python 3.10+ is required by mkdocs-material 9.x. Python 3.12+ recommended for CI. |

### i18n (Bilingual English + Italian)

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| mkdocs-static-i18n | 1.3.1 (pin to >=1.2,<2.0) | Multilingual content management | The standard plugin for i18n in MkDocs Material. Supports per-language file suffixes (e.g., `page.en.md`, `page.it.md`) and folder-based layouts. Generates language-specific builds with a single `mkdocs build`. Integrates with Material's language switcher via `extra.alternate`. |
| mkdocs-material built-in locale support | (included in 9.7.6) | UI string translations (navigation labels, search placeholder, etc.) | Material ships translations for 60+ languages including Italian (`it`). Set `theme.language: en` for the default build; the i18n plugin overrides per-language build. No extra install needed. |
| lunr-languages | (bundled with mkdocs-material search plugin) | Per-language search stemming | The search plugin uses lunr.js with lunr-languages for language-specific stemming. Both English and Italian are well-supported. Configure `search.lang: [en, it]` in mkdocs.yml. |

### Code Highlighting (API Documentation)

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| pymdown-extensions | 10.21.2 (pin to >=10.14,<11.0) | Markdown extensions for code blocks | Required by Material for MkDocs. Provides `highlight`, `superfences`, `inlinehilite`, `snippets`, `tabbed`, and `critic` extensions. The 10.14+ line is required by mkdocs-material 9.5+. |
| Pygments | >=2.16 (bundled dependency) | Syntax highlighting engine | Powers `pymdownx.highlight`. Supports 500+ languages. No separate install needed -- pulled in by mkdocs-material. |
| mkdocs-material-extensions | 1.3.1 (bundled dependency) | Material-specific markdown extensions | Provides custom emoji and icon shortcodes. Pulled in automatically by mkdocs-material. No separate install needed. |

### Offline / Air-Gapped Build

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| mkdocs-material offline plugin | (built into mkdocs-material) | Make site work on file:// protocol | Disables `use_directory_urls` so all links use `index.html` relative paths (not `/path/` style). Moves the search worker from a separate JS file to an inline iframe-worker shim so search works without a server. Enable conditionally: `enabled: !ENV [OFFLINE, false]`. |
| mkdocs-material privacy plugin | (built into mkdocs-material) | Download and bundle external assets | Scans built HTML for external URLs (Google Fonts, CDN scripts), downloads them into `site/assets/external/`, and replaces references with local paths. Essential for air-gap: without it, the site would call out to Google Fonts at runtime and fail silently in offline environments. Enable conditionally: `enabled: !ENV [OFFLINE, false]` or always enable for consistency. |

### Deployment

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Netlify | N/A (SaaS) | Online hosting | Mandatory per project constraints. Provides branch previews, automatic SSL, redirect rules, and custom headers via `netlify.toml`. Free tier sufficient for documentation sites. |
| GitHub Actions | N/A (CI/CD) | Automated build and deploy on push | Triggers `mkdocs build` on push to main. Uploads `site/` directory to Netlify. Also runs the offline build (with `OFFLINE=true`) and uploads the ZIP as a build artifact. |
| netlify.toml | (project config file) | Build and deploy configuration | Specifies build command (`pip install -r requirements.txt && mkdocs build`) and publish directory (`site`). Also defines redirect rules and cache headers. |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| mkdocs-minify-plugin | 0.8.0 | Minify HTML/CSS/JS in production builds | Add for production builds to reduce output size. Not needed for dev. Enables with `plugins: [minify]`. |
| neoteroi.mkdocsoad | latest | OpenAPI/Swagger spec rendering | Add in Phase 2 when OpenAPI spec stabilizes. Renders full API reference from a YAML/JSON spec file. Must use local spec files (not remote URLs) for air-gap compatibility. |
| mike | latest | Multi-version deployment | Add when multiple API versions exist. Manages versioned directories under the site URL. Requires `extra.version.provider: mike` in mkdocs.yml. |
| git-revision-date-localized | latest | Show "last updated" and "created" dates on pages | Optional. Adds git dependency to build pipeline. Useful trust signal for maintained docs. |

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| i18n approach | mkdocs-static-i18n (per-file suffixes) | Material built-in `extra.alternate` only | The `extra.alternate` approach requires separate MkDocs instances per language (separate mkdocs.yml files). mkdocs-static-i18n manages all languages from a single project with `page.en.md` / `page.it.md` suffixes. Single source of truth, single build command, automatic language switcher. The built-in `alternate` is still used for the language switcher UI -- the two complement each other. |
| i18n approach | mkdocs-static-i18n | mkdocs-i18n (different plugin) | mkdocs-i18n is an older, less maintained plugin. mkdocs-static-i18n is the community standard, actively maintained (1.3.1 released 2025), and has first-class Material integration. |
| Search | Material built-in search (lunr.js) | Algolia DocSearch | Algolia requires external JavaScript calls to Algolia servers. Breaks completely in air-gapped environments. The free tier requires application and approval. lunr.js is fully client-side, works offline, and supports multilingual stemming. |
| Search | Material built-in search (lunr.js) | mkdocs-localsearch | localsearch is a fork of Material's search that works with `file://` protocol. However, the Material `offline` plugin already handles this by shimming the search worker. Using both would be redundant and conflicting. |
| Theme | mkdocs-material (9.7.6) | mkdocs-material-insiders | Insiders is a sponsor-only build with experimental features. It requires a GitHub token for private package access, adds CI complexity, and is not necessary for this project. The stable release has all required features (search, offline, privacy, i18n support). |
| Offline search | Material offline plugin + built-in search | Custom service worker approach | The offline plugin already handles file:// compatibility and search worker shimming. A custom service worker would add complexity, break in air-gapped environments (SW requires HTTPS or localhost), and solve a problem that the offline plugin already addresses. |
| Deployment | Netlify | GitHub Pages | Project constraint mandates Netlify. But also: Netlify provides branch previews (automatic deploy previews for PRs), redirect/header configuration via toml, and simpler custom domain setup. GitHub Pages requires manual branch previews and lacks redirect rules. |
| SSG | MkDocs | Docusaurus | Project constraint mandates MkDocs. Docusaurus (React-based) would require a Node toolchain and is less suited for air-gapped deployment due to runtime JS dependencies in the build. |
| SSG | MkDocs | Sphinx | Project constraint mandates MkDocs. Sphinx (Python-based) is more powerful for API docs but has a steeper learning curve and reStructuredText is less familiar than Markdown for content authors. |

## Installation

```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Core dependencies (pin major versions to avoid MkDocs 2.0 breakage)
pip install "mkdocs>=1.6,<2.0"
pip install "mkdocs-material>=9.5,<10.0"
pip install "mkdocs-static-i18n>=1.2,<2.0"
pip install "pymdown-extensions>=10.14,<11.0"

# Optional production plugins
pip install mkdocs-minify-plugin

# Lock dependencies for reproducible builds
pip freeze > requirements.txt
```

For CI/CD (GitHub Actions), use the same `requirements.txt`:

```yaml
# .github/workflows/ci.yml
- run: pip install -r requirements.txt
- run: mkdocs build
```

## Version Pinning Strategy

**CRITICAL: Pin MkDocs to the 1.x line.** MkDocs 2.0 (announced February 2026) is a complete rewrite that:
- Changes config format from YAML to TOML
- Removes the plugin system
- Is incompatible with Material for MkDocs

The mkdocs-material author has stated they will not support MkDocs 2.0's architecture. This means the MkDocs 1.x + Material 9.x combination is the stable long-term foundation for this project. Do not upgrade MkDocs to 2.x without a full migration assessment.

Pin strategy in `requirements.txt`:
```
mkdocs>=1.6,<2.0
mkdocs-material>=9.5,<10.0
mkdocs-static-i18n>=1.2,<2.0
pymdown-extensions>=10.14,<11.0
```

This allows minor and patch updates within the compatible range while blocking the incompatible MkDocs 2.0.

## mkdocs.yml Skeleton

This is the recommended starting configuration that addresses all project requirements. It is not the final config -- it is the structural foundation.

```yaml
site_name: AirGap AI Chatbot Docs
site_url: https://docs.airgap-chatbot.example.com/  # Set actual URL

# --- Theme ---
theme:
  name: material
  language: en  # Default language; i18n plugin overrides per-build
  features:
    - navigation.tabs        # Top-level sections as horizontal tabs
    - navigation.sections    # Sidebar grouping
    - navigation.path        # Breadcrumbs
    - navigation.top         # Back-to-top button
    - search.suggest         # Search autocomplete
    - search.highlight       # Highlight search terms in results
    - content.code.copy      # Copy button on code blocks
    - content.code.annotate  # Code annotations support
  # Do NOT add navigation.instant here -- it uses fetch API, breaks in offline/file:// builds
  palette:
    - scheme: default
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - scheme: slate
      toggle:
        icon: material/brightness-4
        name: Switch to light mode

# --- i18n (Language Switcher) ---
extra:
  alternate:
    - name: English
      link: /en/
      lang: en
    - name: Italiano
      link: /it/
      lang: it

# --- Plugins ---
plugins:
  - search:
      lang:
        - en
        - it
  - i18n:
      languages:
        - locale: en
          name: English
          default: true
        - locale: it
          name: Italiano
  # Conditionally enable for offline builds: OFFLINE=true mkdocs build
  - offline:
      enabled: !ENV [OFFLINE, false]
  # Conditionally enable for offline builds (or always enable for consistency)
  - privacy:
      enabled: !ENV [OFFLINE, false]

# --- Markdown Extensions ---
markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - pymdownx.superfences
  - pymdownx.tabbed:
      alternate_style: true
  - admonition
  - attr_list
  - def_list
  - footnotes
  - md_in_html
  - toc:
      permalink: true

# --- Navigation ---
nav:
  - Home: index.md
  # Add sections as content is created
```

## Offline Build Script Pattern

```bash
#!/usr/bin/env bash
# build-offline.sh -- Build documentation for air-gapped distribution
set -euo pipefail

export OFFLINE=true
mkdocs build --clean

# Package as distributable ZIP
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "dev")
ZIP_NAME="airgap-docs-${VERSION}.zip"
cd site
zip -r "../${ZIP_NAME}" .
cd ..

echo "Offline build complete: ${ZIP_NAME}"
echo "Size: $(du -sh "${ZIP_NAME}" | cut -f1)"
echo "Contents can be viewed by opening site/index.html in a browser"
```

## Netlify Configuration

```toml
# netlify.toml
[build]
  command = "pip install -r requirements.txt && mkdocs build"
  publish = "site"

# Redirect default language to English
[[redirects]]
  from = "/"
  to = "/en/"
  status = 301

# Cache static assets aggressively
[[headers]]
  for = "/assets/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

## Sources

- Material for MkDocs official documentation (squidfunk.github.io/mkdocs-material) -- via Context7 [HIGH confidence]
- MkDocs core documentation (mkdocs.org, github.com/mkdocs/mkdocs) -- via Context7 [HIGH confidence]
- mkdocs-static-i18n PyPI package info (pypi.org/project/mkdocs-static-i18n) -- via pip [HIGH confidence]
- MkDocs 2.0 announcement (squidfunk.github.io/mkdocs-material/blog/2026/02/18/mkdocs-2.0) -- via Context7 [HIGH confidence]
- Material offline plugin documentation (squidfunk.github.io/mkdocs-material/plugins/offline) -- via Context7 [HIGH confidence]
- Material privacy plugin documentation (squidfunk.github.io/mkdocs-material/plugins/privacy) -- via Context7 [HIGH confidence]
- PyPI version indexes for mkdocs, mkdocs-material, pymdown-extensions, mkdocs-static-i18n, mkdocs-minify-plugin -- via pip [HIGH confidence]