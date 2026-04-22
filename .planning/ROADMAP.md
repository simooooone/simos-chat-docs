# Roadmap: AirGap AI Chatbot Documentation Portal

## Overview

Build a bilingual (English + Italian) static documentation portal using MkDocs Material that serves two distribution paths: online via Netlify for general access, and offline as a self-contained ZIP for air-gapped environments. The project progresses from foundation setup through content and internationalization, then forks into parallel online deployment and offline distribution paths -- both of which must deliver the same complete, searchable documentation experience.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3, 4): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Foundation** - Initialize MkDocs project with Material theme, pinned dependencies, bilingual directory structure, and core rendering features (completed 2026-04-22)
- [ ] **Phase 2: Content & i18n** - Write bilingual documentation pages with working navigation, language switcher, and per-language search
- [ ] **Phase 3: Online Deployment** - Deploy the site to Netlify with CI/CD pipeline and branch previews
- [ ] **Phase 4: Offline Distribution** - Produce a self-contained offline build with privacy plugin, file:// compatibility, and ZIP packaging for air-gapped transfer

## Phase Details

### Phase 1: Foundation
**Goal**: MkDocs project is initialized and running locally with all core configuration in place
**Depends on**: Nothing (first phase)
**Requirements**: FDN-01, FDN-02, FDN-03, FDN-04
**Success Criteria** (what must be TRUE):
  1. `mkdocs serve` starts successfully and renders the site locally with the Material theme
  2. All dependencies are pinned and installable from requirements.txt without version conflicts (mkdocs>=1.6,<2.0 enforced)
  3. Bilingual directory structure exists with .en.md/.it.md placeholder files in every section
  4. Syntax highlighting, admonitions, content tabs, and code copy button all render correctly in the local preview
**Plans**: 3 plans

Plans:
- [x] 01-01-PLAN.md — MkDocs project configuration (requirements.txt + mkdocs.yml)
- [x] 01-02-PLAN.md — Bilingual content stubs and directory structure
- [x] 01-03-PLAN.md — Build verification and feature validation

**UI hint**: yes

### Phase 2: Content & i18n
**Goal**: All documentation pages exist in both English and Italian with working navigation and search
**Depends on**: Phase 1
**Requirements**: CNT-01, CNT-02, CNT-03, CNT-04, CNT-05
**Success Criteria** (what must be TRUE):
  1. Every documentation page is available in both English (.en.md) and Italian (.it.md) with complete content
  2. Language switcher appears on every page and keeps the user on the same page when switching languages
  3. Search works in both English and Italian with correct language-specific stemming and no cross-contamination
  4. Navigation tabs, sections, and breadcrumbs display correctly with Italian-translated labels
  5. Admonitions, content tabs, and code copy button render identically in both language versions
**Plans**: TBD

**UI hint**: yes

### Phase 3: Online Deployment
**Goal**: Documentation is automatically published online via Netlify on every push to main
**Depends on**: Phase 2
**Requirements**: DPL-01, DPL-02, DPL-03, DPL-04
**Success Criteria** (what must be TRUE):
  1. Pushing to the main branch triggers an automatic deployment to Netlify via GitHub Actions
  2. The site is accessible at the configured Netlify URL with correct routing (root redirects to /en/)
  3. Pull requests generate branch preview deployments on Netlify
  4. The Netlify build environment uses the correct Python version (3.12.x) and installs all dependencies successfully
**Plans**: TBD

### Phase 4: Offline Distribution
**Goal**: Users in air-gapped environments can access complete, searchable documentation from a ZIP file with zero internet dependency
**Depends on**: Phase 2
**Requirements**: OFL-01, OFL-02, OFL-03, OFL-04
**Success Criteria** (what must be TRUE):
  1. Running build-offline.sh produces a self-contained site/ directory with zero external asset references (no CDN calls)
  2. Opening the offline site via file:// protocol renders correctly with working search and navigation
  3. The packaged ZIP includes all site assets and a README explaining how to use the offline documentation
  4. No CDN references (Google Fonts, external JS/CSS) exist anywhere in the offline build output
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> 4
(Phases 3 and 4 are independent of each other but both depend on Phase 2)

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 3/3 | Complete | 2026-04-22 |
| 2. Content & i18n | 0/TBD | Not started | - |
| 3. Online Deployment | 0/TBD | Not started | - |
| 4. Offline Distribution | 0/TBD | Not started | - |