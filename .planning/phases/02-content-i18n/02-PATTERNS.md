# Phase 2: Content & i18n - Pattern Map

**Mapped:** 2026-04-22
**Files analyzed:** 25 (1 config modify + 1 template create + 1 template delete + 2 snippet dirs + 6 snippet files + 20 bilingual page pairs + 1 script)
**Analogs found:** 22 / 25

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `mkdocs.yml` | config | static-build | `mkdocs.yml` (existing) | exact (modify) |
| `docs/overrides/main.html` | template | static-build | `docs/overrides/partials/announce.html` | role-match (Jinja2 override) |
| `docs/overrides/partials/announce.html` | template | static-build | N/A (delete) | N/A |
| `docs/_snippets/` | directory | static-build | N/A (new directory) | none |
| `docs/_snippets.it/` | directory | static-build | N/A (new directory) | none |
| `docs/_snippets/prereq-docker.md` | snippet | static-build | `docs/index.en.md` (admonition pattern) | partial |
| `docs/_snippets/api-base-url.md` | snippet | static-build | `docs/index.en.md` (code block pattern) | partial |
| `docs/_snippets/standard-disclaimer.md` | snippet | static-build | `docs/index.en.md` (admonition pattern) | partial |
| `docs/_snippets.it/prereq-docker.md` | snippet | static-build | `docs/index.it.md` (admonition pattern) | partial |
| `docs/_snippets.it/api-base-url.md` | snippet | static-build | `docs/index.it.md` (code block pattern) | partial |
| `docs/_snippets.it/standard-disclaimer.md` | snippet | static-build | `docs/index.it.md` (admonition pattern) | partial |
| `docs/index.en.md` | content | static-build | `docs/index.en.md` (existing stub) | exact (modify) |
| `docs/index.it.md` | content | static-build | `docs/index.it.md` (existing stub) | exact (modify) |
| `docs/setup/index.en.md` | content (section index) | static-build | `docs/setup/index.en.md` (existing stub) | exact (modify) |
| `docs/setup/index.it.md` | content (section index) | static-build | `docs/setup/index.it.md` (existing stub) | exact (modify) |
| `docs/setup/installation.en.md` | content (procedural) | static-build | `docs/setup/installation.en.md` (existing stub) | exact (modify) |
| `docs/setup/installation.it.md` | content (procedural) | static-build | `docs/setup/installation.it.md` (existing stub) | exact (modify) |
| *(all remaining 14 child-page pairs)* | content (procedural) | static-build | *(respective stubs)* | exact (modify) |
| `scripts/check-bilingual-pairs.sh` | utility | file-I/O | N/A (no scripts exist) | none |

## Pattern Assignments

### `mkdocs.yml` (config, static-build -- MODIFY)

**Analog:** `mkdocs.yml` (current file, lines 1-165)

This file already exists and is the primary config. Five targeted modifications are needed:

**Modification 1 -- Add `custom_dir` to theme config** (after line 23):
```yaml
# Current (line 22-24):
theme:
  name: material
  language: en

# Target: add custom_dir under name:
theme:
  name: material
  custom_dir: docs/overrides    # Enable template overrides for announce bar
  language: en
```

**Modification 2 -- Add `base_path` to pymdownx.snippets** (replace line 98):
```yaml
# Current (line 98):
  - pymdownx.snippets                # Include code from files

# Target:
  - pymdownx.snippets:
      base_path: docs                # Resolve snippet paths relative to docs/
      check_paths: true              # Warn if snippet file not found
```

**Modification 3 -- Expand `nav_translations` with child-page labels** (replace lines 71-79):
```yaml
# Current (lines 71-79):
          nav_translations:
            Setup: Configurazione
            Chat: Chat
            "Documents & RAG": "Documenti e RAG"
            "Workspaces & Projects": "Aree di lavoro e Progetti"
            Administration: Amministrazione
            API: API
            Deployment: Distribuzione
            Security: Sicurezza

# Target (add 16 child-page labels + fix Setup collision):
          nav_translations:
            # Section-level (8 items)
            Setup: "Installazione e configurazione"  # Changed from Configurazione to avoid collision
            Chat: Chat
            "Documents & RAG": "Documenti e RAG"
            "Workspaces & Projects": "Aree di lavoro e Progetti"
            Administration: Amministrazione
            API: API
            Deployment: Distribuzione
            Security: Sicurezza
            # Child-page level (16 items -- new)
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

**Modification 4 -- Remove `extra.alternate` block** (remove lines 153-160):
```yaml
# Current (lines 153-160):
extra:
  alternate:
    - name: English
      link: /en/
      lang: en
    - name: Italiano
      link: /it/
      lang: it

# Target (remove alternate block entirely -- reconfigure_material handles this):
extra: {}
```

**Modification 5 -- Add `admonition_translations` to Italian locale** (after `nav_translations`):
```yaml
# Add after the nav_translations block under locale: it:
          admonition_translations:
            note: Nota
            warning: Avviso
            tip: Suggerimento
            danger: Pericolo
```

---

### `docs/overrides/main.html` (template, static-build -- CREATE)

**Analog:** `docs/overrides/partials/announce.html` (lines 1-2 -- current announce placeholder)

The existing announce.html uses a simple `<span>` pattern. The new main.html must follow Material theme's Jinja2 block override pattern, NOT the partial pattern.

**Current announce.html** (to be deleted):
```html
<!-- D-10: Announcement bar placeholder. Content will be added in Phase 2. -->
<span>AirGap AI Chatbot Docs -- documentation portal under construction.</span>
```

**New main.html pattern** (from RESEARCH.md Pattern 3):
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

Key differences from the partial pattern:
1. Must extend `base.html` and override `{% block announce %}` -- Material theme uses blocks, not partials
2. Uses `i18n_current_language` variable exposed by mkdocs-static-i18n
3. Uses absolute paths for links (announce bar appears at all page depths)
4. The old `partials/announce.html` file must be DELETED (it conflicts with the block override)

---

### `docs/_snippets/prereq-docker.md` (snippet, static-build -- CREATE)

**Analog:** `docs/index.en.md` (lines 5-8 -- admonition pattern)

Snippet files are new to this project. They follow pymdownx.snippets `--8<--` include syntax. The pattern for admonitions is established in `docs/index.en.md`:

```markdown
!!! info "Documentation Under Construction"

    This documentation portal is being built. Content for each section will be added soon.
```

For prerequisite snippets, use the admonition types from D-08 (`!!! note`, `!!! warning`, `!!! tip`, `!!! danger`). Snippet files contain only the markdown fragment to be included -- no YAML frontmatter, no top-level heading.

**Template pattern for `prereq-docker.md`:**
```markdown
!!! note "Prerequisites"

    - Docker 20.10+ installed and running
    - Docker Compose v2+ (included with Docker Desktop)
    - At least 4 GB of RAM available

??? tip "Verify Docker installation"

    ```bash
    docker --version
    docker compose version
    ```
```

**Template pattern for `api-base-url.md`:**
```markdown
The API is available at:

```bash
BASE_URL="http://localhost:3000/api"
```
```

**Template pattern for `standard-disclaimer.md`:**
```markdown
!!! warning "Self-Hosted Environment"

    This guide assumes you are running AirGap AI Chatbot in a self-hosted environment. Adjust URLs and credentials for your deployment.
```

---

### `docs/_snippets.it/prereq-docker.md` (snippet, static-build -- CREATE)

**Analog:** `docs/index.it.md` (lines 5-8 -- Italian admonition pattern)

Italian snippets mirror English structure exactly (D-05). Technical terms stay in English (D-06). Admonition type keywords (`!!! note`, `!!! warning`, etc.) stay in English -- `admonition_translations` in mkdocs.yml handles title translation.

```markdown
!!! note "Prerequisiti"

    - Docker 20.10+ installato e in esecuzione
    - Docker Compose v2+ (incluso con Docker Desktop)
    - Almeno 4 GB di RAM disponibili

??? tip "Verifica installazione Docker"

    ```bash
    docker --version
    docker compose version
    ```
```

---

### Bilingual page pairs -- Home pages (content, static-build -- MODIFY)

**Analog:** `docs/index.en.md` (existing stub, lines 1-31) and `docs/index.it.md` (lines 1-30)

Current English home page stub:
```markdown
# AirGap AI Chatbot Docs

Welcome to the documentation portal for AirGap AI Chatbot.

!!! info "Documentation Under Construction"

    This documentation portal is being built. Content for each section will be added soon.

## Quick Start

```python
# Example: Using the AirGap AI Chatbot API
import requests

response = requests.get("https://localhost:3000/api/health")
print(response.json())
```

## Features

=== "Self-Hosted"

    Deploy on your own infrastructure with Docker or bare metal.

=== "Air-Gapped"

    Full functionality without internet access for secure environments.

=== "RAG-Powered"

    Upload documents and query them with retrieval-augmented generation.
```

The home page (D-04) stays as project overview with quick-start code, feature highlights, and section links. Replace stub content with full content. Retain the existing pattern: heading, intro paragraph, code blocks, feature highlights. Add section links per D-04.

**Important**: D-02 says inline code blocks, not tabbed alternatives. The current stub uses `=== "Self-Hosted"` content tabs. Replace with inline code blocks showing one approach per snippet, per D-02.

---

### Bilingual page pairs -- Section index pages (content, static-build -- MODIFY)

**Analog:** `docs/setup/index.en.md` (existing stub, lines 1-5) and `docs/chat/index.en.md` (lines 1-5)

Current section index stub:
```markdown
# Setup

Setup and installation guides for AirGap AI Chatbot.

*Content coming soon.*
```

Per D-03, section index pages become introductory landing pages with 2-3 paragraphs plus links to child pages. Replace `*Content coming soon.*` with introductory prose and a bullet-link list.

**Target pattern for section index pages:**
```markdown
# Setup

Get AirGap AI Chatbot running on your infrastructure. This section covers
installation and initial configuration for both Docker and bare-metal deployments.

- **[Installation](installation.md)** -- Pull and run the chatbot container
- **[Configuration](configuration.md)** -- Customize settings for your environment
```

---

### Bilingual page pairs -- Procedural child pages (content, static-build -- MODIFY)

**Analog:** `docs/setup/installation.en.md` (existing stub, lines 1-5) and `docs/setup/installation.it.md` (lines 1-4)

Current child-page stub (English):
```markdown
# Installation

Install AirGap AI Chatbot on your infrastructure.

*Content coming soon.*
```

Current child-page stub (Italian):
```markdown
# Installazione

Installare AirGap AI Chatbot sulla propria infrastruttura.

*Contenuto in arrivo.*
```

Per D-01, replace stubs with procedural guides: title, 1-2 sentence intro, snippet include, step-by-step sections with inline code blocks, and admonitions (D-08).

**English template pattern:**
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

**Italian template pattern (structural mirror per D-05, tech terms in English per D-06):**
```markdown
# Installazione

Installare AirGap AI Chatbot sulla propria infrastruttura con Docker.

--8<-- "_snippets.it/prereq-docker.md"

## Scaricare l'immagine

```bash
docker pull ghcr.io/elia/airgap-chatbot:latest
```

## Eseguire il container

```bash
docker run -d -p 3000:3000 \
  -v ./data:/app/data \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! tip "Verifica dell'installazione"

    Aprire `http://localhost:3000` nel browser per confermare che il chatbot sia in esecuzione.

!!! warning "Requisiti di sistema"

    Assicurarsi che il sistema abbia almeno 4 GB di RAM disponibili per il container.
```

---

### `scripts/check-bilingual-pairs.sh` (utility, file-I/O -- CREATE)

**Analog:** None (no scripts exist in the project yet)

This is a new utility script. No existing analog. Use standard shell script patterns:

```bash
#!/usr/bin/env bash
# check-bilingual-pairs.sh -- Verify every .en.md has a matching .it.md
set -euo pipefail

DOCS_DIR="${1:-docs}"
MISSING=0

echo "Checking bilingual file pairs in ${DOCS_DIR}..."

while IFS= read -r en_file; do
  it_file="${en_file%.en.md}.it.md"
  if [[ ! -f "$it_file" ]]; then
    echo "MISSING: $it_file (pair for $en_file)"
    MISSING=$((MISSING + 1))
  fi
done < <(find "${DOCS_DIR}" -name "*.en.md" -not -path "*/_snippets*")

while IFS= read -r it_file; do
  en_file="${it_file%.it.md}.en.md"
  if [[ ! -f "$en_file" ]]; then
    echo "MISSING: $en_file (pair for $it_file)"
    MISSING=$((MISSING + 1))
  fi
done < <(find "${DOCS_DIR}" -name "*.it.md" -not -path "*/_snippets*")

if [[ $MISSING -gt 0 ]]; then
  echo "FAIL: ${MISSING} missing pair(s)"
  exit 1
else
  echo "PASS: All bilingual pairs complete"
  exit 0
fi
```

## Shared Patterns

### Markdown Structure Conventions
**Source:** All existing stub files in `docs/`
**Apply to:** All 20 bilingual page pairs

Every page file follows the pattern:
1. Level-1 heading (`#`) as page title
2. One-line description paragraph
3. Content (procedural steps, section overview, or feature descriptions)

The `.en.md` / `.it.md` suffix convention is established and must be maintained for all new/modified pages.

### Admonition Set (D-08)
**Source:** `docs/index.en.md` lines 5-8
**Apply to:** All procedural content pages

Standardized admonition types:
- `!!! note` -- informational
- `!!! warning` -- cautions
- `!!! tip` -- recommendations
- `!!! danger` -- destructive actions

Italian titles auto-translated via `admonition_translations` in mkdocs.yml (note -> Nota, warning -> Avviso, tip -> Suggerimento, danger -> Pericolo).

### Snippet Include Syntax (D-09)
**Source:** pymdownx.snippets extension (configured in mkdocs.yml line 98)
**Apply to:** All procedural pages that use shared content

English pages include from `_snippets/`:
```markdown
--8<-- "_snippets/prereq-docker.md"
--8<-- "_snippets/api-base-url.md"
--8<-- "_snippets/standard-disclaimer.md"
```

Italian pages include from `_snippets.it/`:
```markdown
--8<-- "_snippets.it/prereq-docker.md"
--8<-- "_snippets.it/api-base-url.md"
--8<-- "_snippets.it/standard-disclaimer.md"
```

### Structural Mirror Rule (D-05)
**Source:** CONTEXT.md D-05
**Apply to:** All 20 Italian page files

Italian pages must mirror English pages exactly: same headings, same sections, same order. Differences only where Italian grammar requires rephrasing. Technical terms stay in English per D-06.

### Config Modification Pattern
**Source:** `mkdocs.yml` (full file)
**Apply to:** Only mkdocs.yml modifications in this phase

Five targeted modifications to mkdocs.yml:
1. Add `custom_dir: docs/overrides` under `theme:`
2. Add `base_path: docs` and `check_paths: true` to `pymdownx.snippets`
3. Expand `nav_translations` with 16 child-page labels + fix Setup collision
4. Remove `extra.alternate` block (redundant with `reconfigure_material: true`)
5. Add `admonition_translations` under Italian locale

### Cross-Reference Link Convention (PIT-06)
**Source:** RESEARCH.md Pitfall 6
**Apply to:** All internal links in all page files

Always use MkDocs markdown link syntax: `[text](page.md)`. Never hardcode `.html` or trailing-slash paths. This ensures links work in both online and offline builds.

## No Analog Found

| File | Role | Data Flow | Reason |
|------|------|-----------|--------|
| `docs/_snippets/` | directory | static-build | No snippet directories exist yet; create as empty dir |
| `docs/_snippets.it/` | directory | static-build | No snippet directories exist yet; create as empty dir |
| `docs/_snippets/prereq-docker.md` | snippet | static-build | No existing snippets; use admonition patterns from index.en.md |
| `docs/_snippets/api-base-url.md` | snippet | static-build | No existing snippets; use code block patterns from index.en.md |
| `docs/_snippets/standard-disclaimer.md` | snippet | static-build | No existing snippets; use warning admonition pattern |
| `docs/_snippets.it/prereq-docker.md` | snippet | static-build | Italian mirror of English snippet; use index.it.md pattern |
| `docs/_snippets.it/api-base-url.md` | snippet | static-build | Italian mirror of English snippet |
| `docs/_snippets.it/standard-disclaimer.md` | snippet | static-build | Italian mirror of English snippet |
| `scripts/check-bilingual-pairs.sh` | utility | file-I/O | No scripts directory or shell scripts exist in the project |

## Metadata

**Analog search scope:** `docs/` (all .md and .html files), `mkdocs.yml`, `requirements.txt`, `.planning/phases/01-foundation/01-CONTEXT.md`
**Files scanned:** 50 (48 stub/override files + mkdocs.yml + requirements.txt)
**Pattern extraction date:** 2026-04-22