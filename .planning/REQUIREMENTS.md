# Requirements: AirGap AI Chatbot Documentation Portal

**Defined:** 2026-04-22
**Core Value:** Users in air-gapped environments must be able to consult complete, searchable documentation without any internet dependency

## v1 Requirements

### Foundation

- [x] **FDN-01**: MkDocs project initialized with Material theme (mkdocs-material 9.7.x) and core plugins configured
- [x] **FDN-02**: Dependencies pinned in requirements.txt — mkdocs>=1.6,<2.0, mkdocs-material>=9.7, mkdocs-static-i18n==1.3.1, pymdown-extensions>=10.21
- [x] **FDN-03**: Bilingual directory structure established with `.en.md`/`.it.md` suffix convention and placeholder content files
- [x] **FDN-04**: Syntax highlighting (PyMdown Extensions), admonitions, content tabs, and code copy button configured in mkdocs.yml

### Content & i18n

- [ ] **CNT-01**: Every documentation page available in both English (`.en.md`) and Italian (`.it.md`)
- [ ] **CNT-02**: Language switcher with stay-on-page behavior configured via Material `extra.alternate` and mkdocs-static-i18n
- [ ] **CNT-03**: Per-language search index — lunr.js with `lang: [en, it]`, Italian stemming, and `reconfigure_search: true`
- [ ] **CNT-04**: Navigation structure with tabs, sections, and breadcrumbs defined in mkdocs.yml `nav`
- [x] **CNT-05**: Admonitions, content tabs, and code copy button render correctly in both language versions

### Online Deployment

- [ ] **DPL-01**: Netlify deployment configured via `netlify.toml` — build command, publish directory, Python version
- [ ] **DPL-02**: Python runtime version specified in `runtime.txt` (3.12.x) for Netlify build environment
- [ ] **DPL-03**: GitHub Actions CI/CD pipeline auto-deploys to Netlify on push to main branch
- [ ] **DPL-04**: Branch deploy previews enabled for pull requests via Netlify

### Offline Distribution

- [ ] **OFL-01**: Privacy plugin enabled in offline build — localizes all external assets (Google Fonts, CDN JS/CSS)
- [ ] **OFL-02**: Offline plugin enabled in offline build — file:// protocol compatibility, search worker iframe shim, disables `use_directory_urls`
- [ ] **OFL-03**: `build-offline.sh` script sets `BUILD=offline` environment variable and runs `mkdocs build`
- [ ] **OFL-04**: `site/` directory packaged as ZIP for air-gapped transfer with README on how to use it

## v2 Requirements

### Advanced Features

- **ADV-01**: OpenAPI/SwaggerUI rendering via neoteroi.mkdocsoad plugin
- **ADV-02**: PDF generation of documentation
- **ADV-03**: Privacy-respecting analytics integration (Plausible or similar)
- **ADV-04**: Multi-browser offline validation (Chrome, Firefox, Edge on file://)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Dynamic content / server-side rendering | Static site only — air-gap requirement excludes server dependencies |
| User authentication on docs site | Documentation is publicly accessible, no access control needed |
| CMS / headless CMS | Content lives as .md files in git repo, version-controlled |
| Custom plugin development | Use existing MkDocs/Material ecosystem plugins only |
| Custom branding / brand colors | Default Material theme sufficient for v1 |
| `navigation.instant` | Fetch API restricted on file:// protocol — breaks offline build |
| MkDocs 2.x | Incompatible with Material theme plugin system — must stay on 1.x |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| FDN-01 | Phase 1: Foundation | Complete |
| FDN-02 | Phase 1: Foundation | Complete |
| FDN-03 | Phase 1: Foundation | Complete |
| FDN-04 | Phase 1: Foundation | Complete |
| CNT-01 | Phase 2: Content & i18n | Pending |
| CNT-02 | Phase 2: Content & i18n | Pending |
| CNT-03 | Phase 2: Content & i18n | Pending |
| CNT-04 | Phase 2: Content & i18n | Pending |
| CNT-05 | Phase 2: Content & i18n | Complete |
| DPL-01 | Phase 3: Online Deployment | Pending |
| DPL-02 | Phase 3: Online Deployment | Pending |
| DPL-03 | Phase 3: Online Deployment | Pending |
| DPL-04 | Phase 3: Online Deployment | Pending |
| OFL-01 | Phase 4: Offline Distribution | Pending |
| OFL-02 | Phase 4: Offline Distribution | Pending |
| OFL-03 | Phase 4: Offline Distribution | Pending |
| OFL-04 | Phase 4: Offline Distribution | Pending |

**Coverage:**
- v1 requirements: 17 total
- Mapped to phases: 17
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-22*
*Last updated: 2026-04-22 after roadmap creation*