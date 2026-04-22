# Phase 1: Foundation - Pattern Map

**Mapped:** 2026-04-22
**Files analyzed:** 53 (2 config, 1 template override, 50 content stubs)
**Analogs found:** 0 / 53 (greenfield project -- no existing MkDocs configuration or docs stubs)

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `mkdocs.yml` | config | transform | RESEARCH.md Pattern 1-3 code examples | research-only |
| `requirements.txt` | config | build | RESEARCH.md requirements.txt template | research-only |
| `docs/overrides/partials/announce.html` | component | transform | RESEARCH.md D-10 description | research-only |
| `docs/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/setup/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/setup/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/setup/installation.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/setup/installation.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/setup/configuration.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/setup/configuration.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/chat/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/chat/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/chat/getting-started.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/chat/getting-started.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/chat/features.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/chat/features.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/documents-rag/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/documents-rag/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/documents-rag/uploading.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/documents-rag/uploading.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/documents-rag/querying.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/documents-rag/querying.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/workspaces-projects/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/workspaces-projects/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/workspaces-projects/workspaces.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/workspaces-projects/workspaces.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/workspaces-projects/projects.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/workspaces-projects/projects.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/administration/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/administration/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/administration/rbac.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/administration/rbac.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/administration/settings.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/administration/settings.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/api/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/api/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/api/endpoints.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/api/endpoints.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/api/authentication.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/api/authentication.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/deployment/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/deployment/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/deployment/docker.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/deployment/docker.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/deployment/air-gap.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/deployment/air-gap.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/security/index.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/security/index.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/security/overview.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/security/overview.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/security/compliance.en.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |
| `docs/security/compliance.it.md` | content | file-I/O | RESEARCH.md Pattern 4 stub template | research-only |

## Pattern Assignments

This is a greenfield project. There are zero existing MkDocs configuration files or documentation stubs in the codebase. All patterns below are sourced from RESEARCH.md (Phase 1 research document) rather than existing codebase analogs.

---

### `mkdocs.yml` (config, transform)

**Analog:** RESEARCH.md "Complete mkdocs.yml for Phase 1" code example (lines 397-564)

**Full configuration pattern:**
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
  - md_in_HTML                       # Markdown inside HTML blocks
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

**Key constraints to enforce when creating mkdocs.yml:**

1. Plugin load order MUST be: i18n -> search -> offline -> privacy (D-07, PIT-13)
2. `navigation.instant` MUST NOT appear in features list (D-14, PIT-03)
3. Offline/privacy plugins MUST use `!ENV [OFFLINE, false]`, NOT `group` plugin (D-13, PIT-05)
4. i18n plugin MUST be `mkdocs-static-i18n`, NOT `mkdocs-i18n` (PIT-02)
5. MkDocs version pin MUST be `>=1.6,<2.0` to prevent MkDocs 2.0 breakage (PIT-01)
6. `docs_structure: suffix` for i18n file naming (D-03)
7. Dark mode listed FIRST in palette to make it default (D-04)

---

### `requirements.txt` (config, build)

**Analog:** RESEARCH.md "requirements.txt Template" (lines 588-596)

**Pattern:**
```
# Core dependencies - pinned to compatible versions
# MkDocs must stay on 1.x - 2.0 breaks the Material plugin system (PIT-01)
mkdocs>=1.6,<2.0
mkdocs-material>=9.7,<10.0
# i18n plugin - use mkdocs-static-i18n, NOT mkdocs-i18n (abandoned) (PIT-02)
mkdocs-static-i18n==1.3.1
pymdown-extensions>=10.21,<11.0
```

**Key constraints:**
1. Each pin includes a comment explaining WHY (PIT-01, PIT-02 references)
2. Upper bounds prevent breaking upgrades (MkDocs 2.0, pymdown 11.0)
3. mkdocs-static-i18n is pinned to exact version `==1.3.1` (not a range) because it is a single-maintainer plugin

---

### `docs/overrides/partials/announce.html` (component, transform)

**Analog:** RESEARCH.md D-10 description + Material theme announce override pattern

**Pattern:**
```html
<!-- docs/overrides/partials/announce.html -->
<!-- D-10: Announcement bar placeholder. Content will be added in Phase 2. -->
<span class="twemoji">
  {% include ".icons/fontawesome/solid/bullhorn.svg" %}
</span>
<span>AirGap AI Chatbot Docs -- documentation portal under construction.</span>
```

**Notes:**
- This file enables the Material theme announcement bar feature
- Content is placeholder text per D-10 ("placeholder content for Phase 2")
- Must be placed at `docs/overrides/partials/announce.html` for Material theme to detect it
- Keep content minimal -- this is just scaffolding to verify the feature works

---

### English content stubs (content, file-I/O) -- Pattern applies to ALL `.en.md` files

**Analog:** RESEARCH.md Pattern 4 "Minimal Content Stubs" (lines 313-319)

**Pattern for English stubs (`.en.md` files):**
```markdown
# {Title}

{One-line description in English.}

*Content coming soon.*
```

**Concrete examples per section:**

| File | Title | Description |
|------|-------|-------------|
| `docs/index.en.md` | AirGap AI Chatbot Docs | Welcome to the documentation portal for AirGap AI Chatbot. |
| `docs/setup/index.en.md` | Setup | Setup and installation guides for AirGap AI Chatbot. |
| `docs/setup/installation.en.md` | Installation | Install AirGap AI Chatbot on your infrastructure. |
| `docs/setup/configuration.en.md` | Configuration | Configure AirGap AI Chatbot for your environment. |
| `docs/chat/index.en.md` | Chat | Chat interface guides and feature documentation. |
| `docs/chat/getting-started.en.md` | Getting Started | Start your first conversation with AirGap AI Chatbot. |
| `docs/chat/features.en.md` | Features | Explore chat features including streaming, citations, and tool use. |
| `docs/documents-rag/index.en.md` | Documents and RAG | Document management and Retrieval-Augmented Generation. |
| `docs/documents-rag/uploading.en.md` | Uploading | Upload and manage documents in your workspace. |
| `docs/documents-rag/querying.en.md` | Querying | Query your documents using hybrid search and RAG. |
| `docs/workspaces-projects/index.en.md` | Workspaces and Projects | Organize your work with workspaces and projects. |
| `docs/workspaces-projects/workspaces.en.md` | Workspaces | Create and manage workspaces for your team. |
| `docs/workspaces-projects/projects.en.md` | Projects | Create and manage projects within workspaces. |
| `docs/administration/index.en.md` | Administration | Administrative guides for AirGap AI Chatbot. |
| `docs/administration/rbac.en.md` | RBAC | Role-Based Access Control configuration and user management. |
| `docs/administration/settings.en.md` | Settings | System settings, environment variables, and enterprise configuration. |
| `docs/api/index.en.md` | API | REST API reference for AirGap AI Chatbot. |
| `docs/api/endpoints.en.md` | Endpoints | API endpoint reference and usage examples. |
| `docs/api/authentication.en.md` | Authentication | API authentication methods including JWT and API keys. |
| `docs/deployment/index.en.md` | Deployment | Deployment guides for various environments. |
| `docs/deployment/docker.en.md` | Docker | Deploy AirGap AI Chatbot with Docker and Docker Compose. |
| `docs/deployment/air-gap.en.md` | Air-Gap Setup | Deploy AirGap AI Chatbot in air-gapped environments. |
| `docs/security/index.en.md` | Security | Security overview and best practices. |
| `docs/security/overview.en.md` | Overview | Security architecture and threat model. |
| `docs/security/compliance.en.md` | Compliance | Compliance, data residency, and audit logging. |

---

### Italian content stubs (content, file-I/O) -- Pattern applies to ALL `.it.md` files

**Analog:** RESEARCH.md Pattern 4 "Minimal Content Stubs" (lines 321-328)

**Pattern for Italian stubs (`.it.md` files):**
```markdown
# {Titolo}

{Descrizione di una riga in italiano.}

*Contenuto in arrivo.*
```

**Concrete examples per section:**

| File | Titolo | Descrizione |
|------|--------|-------------|
| `docs/index.it.md` | AirGap AI Chatbot - Documentazione | Benvenuti nel portale di documentazione di AirGap AI Chatbot. |
| `docs/setup/index.it.md` | Configurazione | Guide di installazione e configurazione per AirGap AI Chatbot. |
| `docs/setup/installation.it.md` | Installazione | Installare AirGap AI Chatbot sulla propria infrastruttura. |
| `docs/setup/configuration.it.md` | Configurazione | Configurare AirGap AI Chatbot per il proprio ambiente. |
| `docs/chat/index.it.md` | Chat | Guide all'interfaccia di chat e documentazione delle funzionalita. |
| `docs/chat/getting-started.it.md` | Per Iniziare | Iniziare la prima conversazione con AirGap AI Chatbot. |
| `docs/chat/features.it.md` | Funzionalita | Esplorare le funzionalita della chat: streaming, citazioni e uso degli strumenti. |
| `docs/documents-rag/index.it.md` | Documenti e RAG | Gestione dei documenti e generazione aumentata dal recupero (RAG). |
| `docs/documents-rag/uploading.it.md` | Caricamento | Caricare e gestire documenti nel proprio spazio di lavoro. |
| `docs/documents-rag/querying.it.md` | Interrogazione | Interrogare i documenti tramite ricerca ibrida e RAG. |
| `docs/workspaces-projects/index.it.md` | Aree di lavoro e Progetti | Organizzare il lavoro con aree di lavoro e progetti. |
| `docs/workspaces-projects/workspaces.it.md` | Aree di lavoro | Creare e gestire aree di lavoro per il proprio team. |
| `docs/workspaces-projects/projects.it.md` | Progetti | Creare e gestire progetti all'interno delle aree di lavoro. |
| `docs/administration/index.it.md` | Amministrazione | Guide amministrative per AirGap AI Chatbot. |
| `docs/administration/rbac.it.md` | RBAC | Configurazione del controllo degli accessi basato sui ruoli e gestione degli utenti. |
| `docs/administration/settings.it.md` | Impostazioni | Impostazioni di sistema, variabili d'ambiente e configurazione enterprise. |
| `docs/api/index.it.md` | API | Riferimento API REST per AirGap AI Chatbot. |
| `docs/api/endpoints.it.md` | Endpoint | Riferimento degli endpoint API ed esempi di utilizzo. |
| `docs/api/authentication.it.md` | Autenticazione | Metodi di autenticazione API inclusi JWT e chiavi API. |
| `docs/deployment/index.it.md` | Distribuzione | Guide di distribuzione per vari ambienti. |
| `docs/deployment/docker.it.md` | Docker | Distribuire AirGap AI Chatbot con Docker e Docker Compose. |
| `docs/deployment/air-gap.it.md` | Installazione Air-Gap | Distribuire AirGap AI Chatbot in ambienti isolati (air-gapped). |
| `docs/security/index.it.md` | Sicurezza | Panoramica sulla sicurezza e best practice. |
| `docs/security/overview.it.md` | Panoramica | Architettura di sicurezza e modello di minaccia. |
| `docs/security/compliance.it.md` | Conformita | Conformita, residenza dei dati e registrazione di audit. |

---

## Shared Patterns

### Bilingual pairing rule (D-16)
**Apply to:** ALL content stub files

Every `.en.md` file MUST have a corresponding `.it.md` file in the same directory. The i18n plugin's `fallback_to_default: true` config provides a safety net (shows English content at Italian URL rather than 404), but the file pair must always exist to prevent broken language switcher links.

**Verification command:**
```bash
# Count English and Italian stubs -- must be equal
find docs/ -name "*.en.md" | wc -l
find docs/ -name "*.it.md" | wc -l
```

### File naming convention (D-03)
**Apply to:** ALL content stub files

Files use suffix-based naming: `pagename.en.md` and `pagename.it.md` (NOT directory-based like `en/pagename.md`). This is required by the `docs_structure: suffix` setting in the i18n plugin configuration.

### Nav references use base name (no locale suffix)
**Apply to:** `mkdocs.yml` nav section

In the `nav` section of mkdocs.yml, file references use the BASE name without locale suffix:
- `setup/installation.md` (NOT `setup/installation.en.md`)
- The i18n plugin resolves the correct `.en.md` or `.it.md` file based on the current language build.

### Critical MkDocs constraints (from CLAUDE.md and PITFALLS.md)
**Apply to:** `mkdocs.yml`

| Constraint | Reference | Enforcement |
|------------|-----------|-------------|
| MkDocs >=1.6,<2.0 | CLAUDE.md, PIT-01 | Pin in requirements.txt, comment in mkdocs.yml |
| mkdocs-static-i18n (NOT mkdocs-i18n) | CLAUDE.md, PIT-02 | Pin in requirements.txt, comment in mkdocs.yml |
| !ENV conditionals (NOT group plugin) | CLAUDE.md, PIT-05 | Use `!ENV [OFFLINE, false]` on offline/privacy plugins |
| No navigation.instant | CLAUDE.md, PIT-03 | Do NOT add to theme.features, add comment explaining why |
| Plugin order: i18n -> search -> offline -> privacy | PIT-13 | Enforce in YAML ordering |
| pymdownx.tabbed alternate_style: true | RESEARCH.md | Required for Material compatibility |

---

## No Analog Found

All files in this phase have no existing codebase analog. This is a greenfield MkDocs project -- there is no existing `mkdocs.yml`, `requirements.txt`, or documentation stub structure. The existing `docs/` directory contains only project source documentation (`README.md`, `CLAUDE.md`, package-level `CLAUDE.md` files) which are application developer docs, not MkDocs portal content.

| File | Role | Data Flow | Reason |
|------|------|-----------|--------|
| `mkdocs.yml` | config | transform | No existing MkDocs config in repo |
| `requirements.txt` | config | build | No existing Python requirements file in repo |
| `docs/overrides/partials/announce.html` | component | transform | No existing template overrides in repo |
| All 50 content stubs (`*.en.md`, `*.it.md`) | content | file-I/O | No existing documentation stubs in repo; only source project docs exist |

**Reference source for all patterns:** `.planning/phases/01-foundation/01-RESEARCH.md` contains verified configuration patterns, code examples, and anti-patterns. The planner should use those directly as the implementation templates.

---

## Metadata

**Analog search scope:** Project root, docs/, .planning/
**Files scanned:** 8 (existing docs/ files: README.md, CLAUDE.md, 4x package CLAUDE.md, 0 config files, 0 stub files)
**Pattern extraction date:** 2026-04-22