---
phase: 02-content-i18n
plan: 01
status: complete
started: 2026-04-22
completed: 2026-04-22
---

## Plan 02-01: Configuration and i18n Infrastructure

### What was built

Fixed all MkDocs configuration gaps and created the shared infrastructure for bilingual content rendering.

### Changes made

1. **mkdocs.yml — 5 modifications:**
   - Added `custom_dir: docs/overrides` to enable template overrides for the announce bar
   - Configured `pymdownx.snippets` with `base_path: docs` and `check_paths: true`
   - Expanded `nav_translations` from 8 to 24 entries (8 section-level + 16 child-page)
   - Fixed Setup translation collision: "Configurazione" → "Installazione e configurazione"
   - Added `admonition_translations` for Italian (note→Nota, warning→Avviso, tip→Suggerimento, danger→Pericolo)
   - Removed redundant `extra.alternate` block (i18n plugin handles alternates automatically)

2. **docs/overrides/main.html** — i18n-aware announce bar template using `i18n_current_language` conditional with absolute paths

3. **docs/overrides/partials/announce.html** — deleted (was using wrong override pattern)

4. **docs/_snippets/** — 3 English snippet files (prereq-docker, api-base-url, standard-disclaimer)

5. **docs/_snippets.it/** — 3 Italian snippet files (structural mirrors)

6. **scripts/check-bilingual-pairs.sh** — automated validation script

### Verification

- `mkdocs build --strict` passes
- `bash scripts/check-bilingual-pairs.sh` reports PASS
- All 24 nav_translations present
- admonition_translations configured for Italian
- extra.alternate removed
- custom_dir, base_path configured correctly

### key-files

created:
  - mkdocs.yml
  - docs/overrides/main.html
  - docs/_snippets/prereq-docker.md
  - docs/_snippets/api-base-url.md
  - docs/_snippets/standard-disclaimer.md
  - docs/_snippets.it/prereq-docker.md
  - docs/_snippets.it/api-base-url.md
  - docs/_snippets.it/standard-disclaimer.md
  - scripts/check-bilingual-pairs.sh

deleted:
  - docs/overrides/partials/announce.html

### deviations

None — all changes matched the plan exactly.