# Project Research Summary

**Project:** AirGap AI Chatbot -- Documentation Portal
**Domain:** Static documentation site with bilingual content and dual distribution (online + air-gapped offline)
**Researched:** 2026-04-22
**Confidence:** HIGH

## Executive Summary

This is a MkDocs Material documentation portal for an air-gapped AI chatbot product, with the defining constraint that it must work both as a Netlify-hosted online site and as a self-contained ZIP archive opened via `file://` protocol in air-gapped environments. The project is bilingual (English + Italian), which adds i18n complexity but is well-served by the mkdocs-static-i18n plugin with suffix-based file naming. Experts build this type of dual-distribution documentation site by using Material's built-in `offline` and `privacy` plugins conditionally -- enabled only for the offline build via `!ENV` variable toggles -- while keeping the online build lean with directory URLs and CDN assets.

The recommended approach is a single `mkdocs.yml` that serves both distribution paths. Content files use the `.en.md` / `.it.md` suffix convention under `docs_structure: suffix`, giving side-by-side language files organized by topic rather than by language. The critical architectural decision is **not** using Material's `group` plugin (Insiders-only) but instead applying per-plugin `!ENV [OFFLINE, false]` conditionals on the `offline` and `privacy` plugins directly. This keeps the entire stack on the free tier of mkdocs-material while achieving full air-gap compliance.

The key risks are: (1) accidentally upgrading to MkDocs 2.0, which breaks the plugin system and is incompatible with Material -- prevent by pinning `>=1.6,<2.0`; (2) enabling `navigation.instant`, which uses the Fetch API and silently breaks on `file://` protocol; (3) CDN dependencies leaking into the offline build if the privacy plugin is misconfigured. All three are preventable with explicit version pinning, documented feature exclusions, and CI verification.

## Key Findings

### Recommended Stack

The stack is constrained to MkDocs 1.x by project mandate and by the MkDocs 2.0 incompatibility crisis. Material for MkDocs 9.x provides the theme, search, offline, and privacy plugins as built-ins. i18n is handled by mkdocs-static-i18n (the maintained plugin, not the abandoned mkdocs-i18n). All markdown extensions come from pymdown-extensions.

**Core technologies:**
- MkDocs >=1.6,<2.0: static site generator -- mandatory per project constraints; must pin to 1.x because 2.0 removes the plugin system
- mkdocs-material >=9.5,<10.0: theme and plugin ecosystem -- provides search, offline, privacy, and i18n UI integration out of the box
- mkdocs-static-i18n >=1.2,<2.0: multilingual content management -- suffix-based file naming, single mkdocs.yml, automatic language switcher
- pymdown-extensions >=10.14,<11.0: markdown extensions -- code highlighting, superfences, tabbed content, snippets for API doc rendering
- Python >=3.10: runtime -- required by mkdocs-material 9.x; 3.12+ recommended for CI
- Netlify: hosting -- mandatory per project constraints; provides branch previews and redirect rules
- GitHub Actions: CI/CD -- builds both online and offline distributions on push

### Expected Features

**Must have (table stakes):**
- Syntax-highlighted code blocks with copy button -- API docs without this look unprofessional
- Client-side search with bilingual stemming (en + it) -- docs without search feel broken
- Navigation tabs + sections + breadcrumbs -- users need wayfinding
- Language switcher with stay-on-page behavior -- bilingual site is unusable without it
- Admonitions (callouts) -- needed for deprecation notices, security warnings
- Content tabs -- show same endpoint in curl, Python, JS side-by-side
- Responsive layout -- ships by default with Material

**Should have (differentiators):**
- Offline plugin (air-gapped distribution) -- the project's core value proposition
- Privacy plugin (zero CDN dependencies) -- guarantees offline build has no external calls
- Per-language search index -- correct stemming per language, no cross-contamination
- Code annotations -- mark specific lines in complex JSON responses with explanations
- Inline code highlighting -- language-aware highlighting for function names in prose
- Include code from files -- embed actual config files and curl examples, avoid copy drift

**Defer (v2+):**
- OpenAPI rendering (neoteroi.mkdocsoad) -- add when spec stabilizes; hand-written Markdown is fine initially
- Version selector (mike) -- only needed when multiple API versions exist
- Instant navigation / instant previews -- must be validated against `file://` protocol first
- Social cards -- low ROI for internal API docs
- Git revision dates -- nice trust signal but adds git dependency to build pipeline
- Tags plugin -- useful categorization but not essential at launch

### Architecture Approach

A single `mkdocs.yml` drives both online and offline builds. Content files use suffix-based i18n naming (`.en.md` / `.it.md`) organized by topic directory. The i18n plugin runs per-language builds from one config, producing a unified `site/` directory with `/en/` and `/it/` subdirectories plus per-language search indexes. The offline build is triggered by an environment variable (`OFFLINE=true` or `BUILD=offline`) that conditionally enables the `offline` and `privacy` plugins, which disable directory URLs, embed the search worker for `file://` protocol, and download all external assets locally.

**Major components:**
1. **mkdocs.yml** -- single source of configuration truth; defines theme, plugins, extensions, nav, i18n, and conditional offline behavior
2. **mkdocs-static-i18n** -- orchestrates bilingual builds: per-language file resolution, navigation translation, search reconfiguration, language switcher integration
3. **Offline build path** -- `offline` plugin (file:// compatibility) + `privacy` plugin (asset bundling) + build script (ZIP packaging); enabled conditionally via `!ENV`
4. **Netlify deployment** -- `netlify.toml` configures build command, publish directory, root-to-`/en/` redirect, and cache headers
5. **GitHub Actions CI** -- runs `mkdocs build` for online deployment and `OFFLINE=true mkdocs build` for offline ZIP artifact

### Critical Pitfalls

1. **MkDocs 2.0 upgrade breaks everything** -- pin `mkdocs>=1.6,<2.0` in requirements.txt with an explanatory comment; add `mkdocs --version` check to CI
2. **`navigation.instant` breaks on file:// protocol** -- do NOT enable this feature flag; document the exclusion explicitly in mkdocs.yml comments
3. **CDN dependencies leak into offline build** -- enable `privacy` plugin in offline build group; verify with `grep -r "fonts.googleapis\|cdn" site/` after offline build
4. **Wrong i18n plugin installed** -- pin `mkdocs-static-i18n==1.3.1` (not `mkdocs-i18n`); both exist on PyPI with similar names
5. **`group` plugin is Insiders-only** -- use per-plugin `!ENV [OFFLINE, false]` conditionals instead; the `group` plugin requires a paid Material Insiders license

## Implications for Roadmap

Based on combined research, the project naturally decomposes into four phases driven by strict dependency ordering. Phases 3 and 4 both depend on Phase 2 but can proceed in parallel with each other.

### Phase 1: Foundation
**Rationale:** The mkdocs.yml configuration, dependency pinning, and directory structure must exist before any content or builds can work. Version pinning mistakes here (especially the MkDocs 2.0 trap) cascade into catastrophic failures later.
**Delivers:** Working `mkdocs.yml`, `requirements.txt`, `docs/` directory structure, initial `mkdocs serve` up and running
**Addresses:** All table-stakes features (theme, search, navigation, code highlighting)
**Avoids:** PIT-01 (MkDocs 2.0), PIT-02 (wrong i18n plugin), PIT-05 (group plugin), PIT-13 (plugin load order)

### Phase 2: Content and i18n
**Rationale:** Content files and i18n configuration must exist before either distribution path can deploy anything meaningful. The suffix-based file naming convention and translation completeness checks are established here.
**Delivers:** Bilingual content pages (.en.md / .it.md), i18n plugin configuration with `nav_translations`, search with bilingual stemming, language switcher working
**Addresses:** Bilingual search, language switcher, content tabs, admonitions, code highlighting
**Avoids:** PIT-06 (cross-reference format), PIT-07 (missing translations), PIT-08 (search index not separated), PIT-14 (inconsistent naming), PIT-17 (Italian stemming), PIT-19 (root redirect), PIT-22 (theme language for Italian)

### Phase 3: Online Distribution
**Rationale:** Once content and i18n work locally, the online deployment path can be configured. Netlify hosting is the project mandate.
**Delivers:** Netlify deployment via `netlify.toml`, GitHub Actions CI pipeline, root redirect to `/en/`, cache headers, branch previews
**Uses:** Netlify (hosting), GitHub Actions (CI), mkdocs build (online mode)
**Avoids:** PIT-09 (Netlify Python version), PIT-10 (missing requirements install), PIT-15 (Netlify caching)

### Phase 4: Offline Distribution
**Rationale:** The project's core differentiator. Must validate that the offline build produces a self-contained ZIP that works on `file://` protocol. This depends on i18n content (Phase 2) but is independent of Netlify (Phase 3).
**Delivers:** Conditional offline/privacy plugin configuration, `build-offline.sh` script, ZIP packaging, verified air-gap compliance
**Avoids:** PIT-03 (navigation.instant breaks file://), PIT-04 (CDN leaks), PIT-18 (custom CSS/JS breaking offline), PIT-21 (ZIP structure)

### Phase Ordering Rationale

- Phase 1 must come first because mkdocs.yml is the input to everything else; dependency pinning errors here are unrecoverable later
- Phase 2 must come before Phases 3 and 4 because content and i18n are prerequisites for any meaningful deployment or packaging
- Phases 3 and 4 are independent of each other and can proceed in parallel once Phase 2 is complete
- The offline build validation (Phase 4) is placed last because it is the most failure-prone path and benefits from having stable content and a working online build to compare against

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 4:** The interaction between the offline plugin, privacy plugin, and `file://` protocol has edge cases that may require hands-on validation. Specifically: confirm that the privacy plugin captures all external assets (not just Google Fonts), and verify that search works on `file://` across browsers (Chrome, Firefox, Edge).
- **Phase 2:** The `nav_translations` mechanism in mkdocs-static-i18n should be tested with the actual nav structure to confirm that all labels are translated and no orphaned entries exist.

Phases with standard patterns (skip research-phase):
- **Phase 1:** MkDocs + Material setup is well-documented and formulaic; no research needed beyond what is already captured
- **Phase 3:** Netlify deployment of static sites is a standard pattern; the `netlify.toml` config is straightforward

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All technology choices verified against official docs via Context7; version pinning validated against PyPI; MkDocs 2.0 incompatibility confirmed by Material author |
| Features | HIGH | Feature set derived directly from Material for MkDocs capabilities; all features are built-in or community-standard plugins with documented APIs |
| Architecture | HIGH | Single-mkdocs.yml dual-build architecture is the documented recommendation for this exact use case; component boundaries and data flows are clear |
| Pitfalls | HIGH | All critical pitfalls verified against official documentation; the MkDocs 2.0 and navigation.instant pitfalls have documented evidence of breakage |

**Overall confidence:** HIGH

### Gaps to Address

- **Offline search on file:// across browsers:** The offline plugin's iframe-worker shim is documented but browser behavior on `file://` varies. Must validate in Phase 4 with actual browsers. Cannot be fully resolved by research alone.
- **Privacy plugin coverage completeness:** The privacy plugin documents Google Fonts and CDN script capture, but custom assets (icon CDNs, web fonts loaded via custom CSS) may not be captured automatically. Audit all custom assets in Phase 4.
- **Instant navigation compatibility:** `navigation.instant` is desirable for the online build but incompatible with offline. Research whether it can be conditionally enabled for online-only builds without maintaining two separate mkdocs.yml files. This may require a custom template override or a plugin hook.
- **Translation completeness enforcement:** No automated tooling was identified that checks for missing `.it.md` files alongside every `.en.md` file. A CI script must be written in Phase 2.

## Sources

### Primary (HIGH confidence)
- Material for MkDocs official documentation (squidfunk.github.io/mkdocs-material) via Context7 -- theme config, plugin APIs, offline plugin, privacy plugin, search, i18n integration, navigation features
- MkDocs core documentation (mkdocs.org, github.com/mkdocs/mkdocs) via Context7 -- build system, configuration, plugin architecture, deploy targets
- mkdocs-static-i18n v1.3.1 source code and PyPI -- plugin architecture, suffix mode, reconfigure hooks, fallback behavior
- MkDocs 2.0 announcement (squidfunk.github.io/mkdocs-material/blog/2026/02/18/mkdocs-2.0) via Context7 -- breaking changes, plugin system removal, incompatibility with Material

### Secondary (MEDIUM confidence)
- mkdocs-static-i18n plugin reference from MkDocs plugin wiki -- community patterns, known issues
- Netlify deployment patterns based on Material publishing guide + standard static site patterns -- build config, redirects, caching
- Neoteroi MkDocs plugins documentation via Context7 -- OpenAPI rendering capabilities and air-gap constraints

### Tertiary (LOW confidence)
- Build performance estimates at scale (200+ pages) -- extrapolated from MkDocs community reports, not benchmarked for this specific stack

---
*Research completed: 2026-04-22*
*Ready for roadmap: yes*
