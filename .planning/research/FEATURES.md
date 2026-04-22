# Feature Landscape

**Domain:** MkDocs Material documentation portal with dual distribution (online + air-gapped)
**Researched:** 2026-04-22

## Table Stakes

Features users expect. Missing = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Syntax-highlighted code blocks | API documentation is primarily code; unhighlighted code blocks look unprofessional | Low | Built into Material via `pymdownx.highlight` + `pymdownx.superfences`. Supports 100+ languages via Pygments. Zero additional config needed beyond enabling the extensions. |
| Built-in search (client-side) | Users expect to type and find. Docs without search feel broken. | Low | Material ships a built-in `search` plugin powered by lunr.js. Index is baked into the static build. No external service required. Works offline by default. Config: `plugins: [search]` with `lang: [en, it]` for bilingual stemming. |
| Navigation tabs | Top-level sections rendered as horizontal tabs are the standard doc-site pattern | Low | Single feature flag: `theme.features: [navigation.tabs]`. Renders above 1220px viewport. Below that, collapses to sidebar. |
| Navigation sections | Sidebar grouping of pages under section headers | Low | Feature flag: `theme.features: [navigation.sections]`. Groups top-level entries in sidebar. Pairs with tabs for a two-level navigation. |
| Breadcrumbs | Users need to know where they are in the doc tree | Low | Feature flag: `theme.features: [navigation.path]`. Renders breadcrumb trail above page title. |
| Table of contents (right-side) | Long pages need in-page navigation | Low | Enabled by default as a right-side outline. Can integrate into sidebar with `toc.integrate`. For API doc pages with many endpoints, this is essential. |
| Code copy button | API docs show curl commands, JSON payloads; users copy them constantly | Low | Feature flag: `theme.features: [content.code.copy]`. Adds a clipboard icon to every code block. Can also be per-block with `.copy` class. |
| Content tabs | API docs show the same endpoint in multiple languages (curl, Python, JS) | Low | Uses `=== "Tab Name"` syntax from `pymdownx.tabbed`. Built into Material. Critical for showing request examples in multiple formats side-by-side. |
| Responsive/mobile layout | Users read docs on phones and tablets | Low | Material is mobile-first. No configuration needed. |
| Admonitions (callouts) | Warning about deprecated endpoints, tips for common patterns, notes about rate limits | Low | Uses `!!! note`, `!!! warning`, `!!! tip` syntax. 12 built-in types. Fully styled. Custom icons configurable via `theme.icon.admonition`. |
| Language switcher | Bilingual site without a language switcher is unusable | Low | Defined via `extra.alternate` in `mkdocs.yml`. Each entry needs `name`, `link`, and `lang`. Material renders it in the header automatically. Stay-on-page behavior is built in (switches to same page path in target language if it exists). |

## Differentiators

Features that set the product apart. Not expected, but valued.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Offline plugin (air-gapped distribution) | The core differentiator for this project. Users in air-gapped environments get the same site as online users, just zipped. | Medium | Built-in `offline` plugin. Enable with `plugins: [offline]`. Conditionally enable via env var: `enabled: !ENV [OFFLINE, false]` so the same `mkdocs.yml` works for both online and offline builds. The generated `site/` directory becomes a distributable ZIP. |
| Privacy plugin (zero CDN dependencies) | Guarantees the offline build has zero external calls. Downloads all fonts, scripts, stylesheets into the `site/` directory. | Medium | Built-in `privacy` plugin. Scans HTML for external assets (Google Fonts, CDN scripts), downloads them recursively, replaces references with local paths. Essential for air-gap compliance. Config: `plugins: [privacy]`. Assets land in `assets/external/` inside the site directory. |
| Per-language search index | English and Italian users each get a search index with correct stemming for their language. No cross-contamination. | Low | Search plugin supports multiple `lang` values. Each language build gets its own lunr.js index. Config: `plugins: [search: {lang: [en, it]}]`. Adding languages increases JS payload slightly, but both English and Italian are well-supported by lunr-languages. |
| Code annotations | Mark specific lines in API response examples with numbered markers that expand into explanations. Makes complex JSON/XML responses scannable. | Low | Add `.annotate` class to code blocks. Use `(1)` markers in code, then `1. Explanation text` below. Feature flag: `content.code.annotate` (enabled by default in Material). |
| Instant navigation (SPA-like) | Page transitions without full reload. Feels like a native app, not a static site. | Low | Feature flag: `theme.features: [navigation.instant]`. Pre-fetches pages on hover, swaps content via XHR. Significant UX improvement for sites with many pages. **Caveat**: Must test that instant nav does not break offline builds served from `file://` protocol -- this needs validation. |
| Instant page previews | Hover over any internal link to see a preview of the target page. Useful for API reference where endpoints reference each other. | Medium | Feature flag: `theme.features: [navigation.instant.preview]`. Requires `site_url` to be set. Can configure per-page or per-section via `material.extensions.preview` markdown extension. |
| OpenAPI spec rendering | Render full API reference from an OpenAPI/Swagger YAML/JSON file instead of hand-writing every endpoint | Medium | `neoteroi.mkdocsoad` plugin. Embed with `[OAD(./path/to/swagger.yaml)]` in Markdown. Supports local files and remote URLs. Config: `plugins: [neoteroi.mkdocsoad: {use_pymdownx: true}]`. **Important**: For air-gapped builds, the OpenAPI spec file must be local (not a remote URL). |
| Line numbers in code blocks | Required for API error message references ("see line 42") and for discussing long configuration files | Low | Set `pymdownx.highlight: {linenums: true}` globally, or per-block with `linenums="1"` attribute. Anchor line numbers enabled with `anchor_linenums: true` for direct linking to specific lines. |
| Inline code highlighting | Mention a function name or variable in prose and have it highlighted | Low | `pymdownx.inlinehilite` extension. Write `` `:::python my_function` `` to get language-aware inline highlighting. Useful in API prose descriptions. |
| Include code from files | Keep code examples in separate files, include them in docs. Avoids copy drift between actual code and docs. | Low | `pymdownx.snippets` extension. Syntax: `--8<-- "path/to/file.py"`. For this project, useful for embedding actual config files, curl examples, or response payloads that live alongside the codebase. |
| Tags/categories | Group API endpoints by category (auth, data, admin) across pages | Low | Built-in `tags` plugin. Add `tags: [auth, REST]` to page frontmatter. Material renders a tag index page. Pairs well with the blog plugin but works for regular docs too. Config: `plugins: [tags]`. |
| Version selector | When the chatbot API evolves, users need to find docs for the version they are running | Medium | Requires `mike` utility (separate install). Material integrates via `extra.version.provider: mike`. Deploys each version to a subdirectory. Version selector appears in header. **Defer to later phase** -- only needed when API has multiple released versions. |
| Git revision dates | Show "last updated" and "created" dates on each page. Builds trust that docs are maintained. | Low | `git-revision-date-localized` plugin. Config: `plugins: [git-revision-date-localized: {enable_creation_date: true}]`. Pulls dates from git history. **Caveat**: Adds git dependency to build pipeline. Minor complexity. |
| Social cards | Auto-generated Open Graph images for each page. Links shared in Slack/Teams/Discord look professional. | Medium | Built-in `social` plugin. Config: `plugins: [social]`. Requires Cairo and Pango system libraries for rendering. **Low priority for API docs** -- nice to have, not essential. Can be deferred. |
| Custom 404 page | Better UX when users land on a deleted or mistyped URL | Low | MkDocs generates a `404.html` automatically. Material styles it. Works offline. |

## Anti-Features

Features to explicitly NOT build. These are either out of scope or actively harmful for this project.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Algolia DocSearch | Requires external JavaScript call to Algolia servers. Breaks completely in air-gapped environments. The free tier requires application and approval. | Use the built-in Material search plugin (lunr.js). It is fully client-side, works offline, and supports multilingual stemming. |
| CDN-loaded fonts or assets | Google Fonts, unpkg CDN scripts, and any external resource URL will fail silently in air-gapped environments. Pages will render with fallback fonts and broken scripts. | Use the `privacy` plugin to download and bundle all external assets into the `site/` directory. Alternatively, self-host fonts by placing woff2 files in the `docs/` directory and referencing them via custom CSS. |
| External comment systems (Disqus, Giscus, Utterances) | All require JavaScript calls to external servers. Break in air-gap. Add privacy concerns. Add maintenance burden. | Do not add comments. Documentation is not a forum. Feedback channels can be a link to a GitHub issue template or an email address. |
| Custom MkDocs plugins | Project constraint: use existing plugins only. Custom plugins add maintenance burden, require testing against Material updates, and create a single point of failure. | Compose existing plugins. The Material ecosystem (search, offline, privacy, tags, blog, social) plus community plugins (neoteroi.mkdocsoad, git-revision-date-localized, mike) cover the full feature surface. |
| Server-side rendering or dynamic content | The project is explicitly static-only. SSR would require a server, breaking the air-gap use case entirely. | Static build via `mkdocs build`. The `site/` directory is the deployable artifact. |
| Authentication/access control on the doc site | Documentation is publicly accessible per project requirements. Adding auth creates complexity (user management, session handling) with no value. | Keep docs public. If sensitive content exists, it should not be in the documentation repo. |
| CMS/headless CMS integration | Content lives in `.md` files in the repo. CMS adds a runtime dependency, a database, and an editing layer that conflicts with git-based workflow. | Edit Markdown files directly. Use `mkdocs serve` for live preview during authoring. PR-based review workflow for content changes. |
| Client-side analytics (Google Analytics, Plausible, etc.) | Analytics scripts call external servers. Break in air-gap. Also: the doc site is public and small -- analytics overhead is not justified. | Do not add analytics. If usage data is needed later, parse Netlify server logs (available without client-side JS). |
| Hot-keys / keyboard shortcuts plugin | Niche feature for a documentation site. Adds complexity without proportional value. Users navigate with mouse or browser shortcuts. | Skip. The built-in search is already keyboard-accessible (focus with `/` in Material). |

## Feature Dependencies

```
Search plugin (lunr.js)
  --> Search language config: lang: [en, it]
  --> Required by both online and offline builds
  --> No external service dependency (self-contained)

Offline plugin
  --> Privacy plugin (bundling external assets is prerequisite for true offline)
  --> search plugin (search must work without internet)
  --> Must NOT use CDN-loaded anything (fonts, scripts, analytics)
  --> Same mkdocs.yml as online build (use env var toggle: !ENV [OFFLINE, false])

Privacy plugin
  --> Downloads Google Fonts (Roboto, Roboto Mono) into site/assets/external/
  --> Downloads any CDN scripts into site/assets/external/
  --> Must run for BOTH builds if site uses default Material fonts
  --> Alternatively: self-host fonts and skip CDN references entirely

i18n / Language switcher
  --> extra.alternate config (defines language entries)
  --> Per-language page files (.en.md, .it.md suffixes)
  --> search plugin lang config (per-language stemming)
  --> mkdocs-static-i18n plugin OR Material built-in alternate links
  --> Stay-on-page switching (built into Material when alternate is configured)

Code highlighting (API docs)
  --> pymdownx.highlight (Pygments engine)
  --> pymdownx.superfences (nested code blocks in admonitions/tabs)
  --> pymdownx.inlinehilite (inline code highlighting)
  --> pymdownx.snippets (include code from external files)

Navigation structure
  --> navigation.tabs (top-level horizontal tabs)
  --> navigation.sections (sidebar grouping)
  --> navigation.path (breadcrumbs)
  --> toc.integrate (optional: move TOC into sidebar)
  --> navigation.instant (optional: SPA-like nav, TEST with file:// protocol)

OpenAPI rendering (if used)
  --> neoteroi.mkdocsoad plugin
  --> Local OpenAPI spec file (not remote URL -- air-gap constraint)
  --> pymdownx.highlight (for syntax highlighting inside rendered API docs)
  --> privacy plugin (if spec file references external schemas)

Content tabs (multi-language examples)
  --> pymdownx.tabbed extension
  --> pymdownx.superfences (code blocks inside tabs)

Versioning (deferred)
  --> mike utility
  --> extra.version.provider: mike
  --> Git branch strategy for versioned docs
  --> Only needed when multiple API versions exist

Netlify deployment
  --> mkdocs build --site-dir site (produces static output)
  --> netlify.toml (build command, publish directory, redirects, headers)
  --> GitHub Actions CI (auto-deploy on push)
  --> Branch previews (automatic with Netlify -- no extra config)
```

## MVP Recommendation

Prioritize (ship in Phase 1):

1. **Search with bilingual stemming** -- the single most impactful feature. Without it, docs are unusable. Low complexity, built into Material.
2. **Syntax-highlighted code blocks with copy button and content tabs** -- core to API documentation. Without these, API docs feel like raw text files. Low complexity.
3. **Navigation tabs + sections + breadcrumbs + TOC** -- users cannot find content without wayfinding. Low complexity.
4. **Language switcher with stay-on-page** -- bilingual docs without a switcher are two disconnected sites. Low complexity.
5. **Privacy plugin** -- this is what makes the offline build actually work without internet. Medium complexity (asset downloading, but automated).
6. **Offline plugin** -- the project's core value. Without it, the air-gap requirement is unmet. Medium complexity (env var toggle, ZIP packaging).
7. **Admonitions** -- needed for deprecation notices, security warnings on API endpoints. Low complexity.

Defer to Phase 2:

- **OpenAPI rendering** (neoteroi.mkdocsoad): Useful but not blocking. Initial API docs can be hand-written Markdown. Add the plugin when the OpenAPI spec stabilizes.
- **Version selector** (mike): Only relevant when there are multiple API versions. Ship v1 docs first.
- **Code annotations**: Nice-to-have for complex response examples. Not blocking.
- **Instant navigation / instant previews**: Must be validated against `file://` protocol for offline builds before enabling.
- **Social cards**: Low ROI for an internal API documentation site.
- **Tags plugin**: Useful for categorization but not essential at launch.
- **Git revision dates**: Nice trust signal but adds a git dependency to the build pipeline.

## Sources

- Material for MkDocs official documentation (squidfunk.github.io/mkdocs-material) -- via Context7 [HIGH confidence]
- MkDocs core documentation (mkdocs.org, github.com/mkdocs/mkdocs) -- via Context7 [HIGH confidence]
- mkdocstrings documentation (github.com/mkdocstrings/mkdocstrings) -- via Context7 [HIGH confidence]
- Neoteroi MkDocs plugins documentation (context7.com/neoteroi/mkdocs-plugins) -- via Context7 [HIGH confidence]
- mkdocs-static-i18n plugin reference from MkDocs plugin wiki -- via Context7 [MEDIUM confidence, community plugin]
- Netlify deployment patterns: based on Material publishing guide + standard Netlify static site patterns [MEDIUM confidence, not Material-specific]