---
phase: 01-foundation
plan: 01
status: complete
requirements:
  - FDN-01
  - FDN-02
  - FDN-04
---

# Plan 01-01 Summary: MkDocs Project Configuration

## What was built

Created the two core configuration files for the MkDocs documentation portal:

1. **requirements.txt** — Pinned Python dependencies with upper bounds and explanatory comments:
   - mkdocs>=1.6,<2.0 (PIT-01: MkDocs 2.0 breaks Material plugin system)
   - mkdocs-material>=9.7,<10.0
   - mkdocs-static-i18n==1.3.1 (PIT-02: wrong package mkdocs-i18n is abandoned)
   - pymdown-extensions>=10.21,<11.0

2. **mkdocs.yml** — Complete MkDocs Material theme configuration:
   - Plugin load order: i18n -> search -> offline -> privacy (D-07)
   - Suffix-based i18n with docs_structure: suffix (D-03)
   - !ENV [OFFLINE, false] conditionals for offline/privacy plugins (D-13)
   - Dark mode as default palette (D-04)
   - No navigation.instant (D-14, breaks on file:// protocol)
   - Bilingual search with en/it stemming (D-08)
   - All FDN-04 markdown extensions (admonitions, content tabs, code copy, syntax highlighting)
   - 8-section navigation structure with nav_translations for Italian (D-01, D-02)

## Key decisions enforced

- D-03: Suffix-based i18n (not folder-based)
- D-04: Dark mode default (slate listed first in palette)
- D-07: Explicit plugin load order
- D-13: !ENV conditionals instead of Insiders-only group plugin
- D-14: navigation.instant excluded (file:// compatibility)
- D-16: fallback_to_default: true

## Files created

- `requirements.txt`
- `mkdocs.yml`