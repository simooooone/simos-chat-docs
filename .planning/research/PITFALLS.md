# Pitfalls Research — AirGap AI Chatbot Documentation Portal

**Date:** 2026-04-22
**Confidence:** HIGH

## Critical Pitfalls (Must Prevent)

### PIT-01: MkDocs 2.0 Upgrade Breaks Everything
**What goes wrong:** Installing `mkdocs>=2.0` silently breaks Material theme (plugin system removed, YAML→TOML config change). The mkdocs-material author confirmed incompatibility.
**Consequences:** Complete build failure; config format incompatible; all plugins stop working.
**Prevention:** Pin `mkdocs>=1.6,<2.0` in requirements.txt. Add a comment explaining why.
**Detection:** `pip check` or `mkdocs --version` in CI. Build will fail loudly.
**Phase:** Phase 1 (Foundation)

### PIT-02: Wrong i18n Plugin Installed
**What goes wrong:** Installing `mkdocs-i18n` (abandoned) instead of `mkdocs-static-i18n` (maintained, v1.3.1+). Both exist on PyPI with similar names.
**Consequences:** Broken language switching, no fallback logic, unmaintained code.
**Prevention:** Explicitly pin `mkdocs-static-i18n==1.3.1` in requirements.txt. Document in mkdocs.yml comments.
**Detection:** `pip list | grep i18n` shows wrong package. Build errors on language switcher.
**Phase:** Phase 1 (Foundation)

### PIT-03: `navigation.instant` Breaks on file:// Protocol
**What goes wrong:** Enabling `navigation.instant` uses the Fetch API, which browsers restrict on `file://` protocol. Pages fail to load in offline/air-gapped mode.
**Consequences:** Offline site is completely broken — links don't work, navigation fails.
**Prevention:** Do NOT enable `navigation.instant` in mkdocs.yml. Document this explicitly. The offline plugin may handle this automatically, but explicit exclusion is safer.
**Detection:** Open site/index.html directly in browser from local filesystem. Click any link — if it loads via XHR, it's broken.
**Phase:** Phase 1 (Foundation) — validate in Phase 4 (Offline)

### PIT-04: CDN Dependencies Leak Into Offline Build
**What goes wrong:** Material theme loads Google Fonts and CDN-hosted JS by default. Without the `privacy` plugin, the offline build still calls external URLs — which fail in air-gapped environments.
**Consequences:** Offline site looks broken (missing fonts, no icons) or silently fails (analytics calls, external resources).
**Prevention:** Enable the `privacy` plugin in the offline build group. It downloads all external assets locally and rewrites references.
**Detection:** `grep -r "fonts.googleapis\|cdn\|http://" site/` after offline build. Any hits = privacy plugin not working.
**Phase:** Phase 4 (Offline Distribution)

### PIT-05: `group` Plugin Is Insiders-Only
**What goes wrong:** The `group` plugin (for conditional online/offline builds) requires Material Insiders (`squidfunk/mkdocs-material-insiders`). Using it on the free tier causes a plugin-not-found error.
**Consequences:** Build fails if you reference `group` in mkdocs.yml without the Insiders license.
**Prevention:** Use per-plugin `!ENV [OFFLINE, false]` conditionals instead of the `group` plugin. Example: `enabled: !ENV [OFFLINE, false]` on `offline` and `privacy` plugins. This works on the free tier.
**Detection:** Build fails with `Plugin 'group' not found` error.
**Phase:** Phase 1 (Foundation)

### PIT-06: `use_directory_urls` Breaks Cross-References Between Builds
**What goes wrong:** The `offline` plugin disables `use_directory_urls` (changes `/page/` to `/page.html`). If cross-references use one style, they break in the other build.
**Consequences:** Links work online but 404 offline, or vice versa. Search indexes may diverge.
**Prevention:** Always use MkDocs markdown link syntax (`[text](page.md)`) — never hardcode `.html` or directory-style URLs. The build system resolves them correctly for each mode.
**Detection:** Crawl the offline site for 404s after build. Check `mkdocs build --strict` catches warnings.
**Phase:** Phase 2 (Content + i18n) — validate in Phase 4

### PIT-07: Missing or Out-of-Sync Translations
**What goes wrong:** A page exists in English (`page.en.md`) but the Italian version (`page.it.md`) is missing or outdated. No CI check catches this.
**Consequences:** Language switcher leads to 404 or shows wrong content. Users see mixed-language pages.
**Prevention:** Add a CI step that checks for translation completeness (every `.en.md` has a corresponding `.it.md`). Use `mkdocs-static-i18n`'s `default_alternate:` config for fallback. Consider a script that compares file pairs.
**Detection:** `diff <(find docs/ -name "*.en.md" | sed 's/.en.md//') <(find docs/ -name "*.it.md" | sed 's/.it.md//')` in CI.
**Phase:** Phase 2 (Content + i18n)

### PIT-08: Search Index Not Language-Separated
**What goes wrong:** Forgetting `lang: [en, it]` in the search plugin config causes English and Italian content to mix in one search index.
**Consequences:** Search results are a jumble of both languages. Users can't find relevant content.
**Prevention:** Configure `reconfigure_search: true` in mkdocs-static-i18n. Set `lang:` in search plugin config. Verify per-language indexes exist in `site/search/`.
**Detection:** Search for "installazione" on English page — if Italian results appear, search isn't separated.
**Phase:** Phase 2 (Content + i18n)

### PIT-09: Netlify Python Version Mismatch
**What goes wrong:** Netlify's default Python is often outdated (3.8 or 3.9). MkDocs 1.6+ and mkdocs-material 9.x require Python 3.9+.
**Consequences:** Build fails on Netlify with `ImportError` or `SyntaxError` from modern Python syntax in dependencies.
**Prevention:** Add `runtime.txt` with `3.12.x` (or current stable) to the repo root. Netlify reads this to set the Python version.
**Detection:** Netlify deploy log shows Python version at build start. If <3.9, build will fail.
**Phase:** Phase 3 (Online Distribution)

### PIT-10: Netlify Build Command Doesn't Install Requirements
**What goes wrong:** Netlify runs `pip install mkdocs` by default, which doesn't include mkdocs-material, mkdocs-static-i18n, or other plugins from requirements.txt.
**Consequences:** Build fails with `ModuleNotFoundError` for every plugin.
**Prevention:** Set Netlify build command to `pip install -r requirements.txt && mkdocs build`. Configure in `netlify.toml`.
**Detection:** Netlify deploy log shows `ModuleNotFoundError` or `Plugin not found`.
**Phase:** Phase 3 (Online Distribution)

## Moderate Pitfalls

### PIT-11: Orphan Pages (Not in nav)
Pages exist as .md files but aren't listed in `mkdocs.yml` nav. They're unreachable via navigation.
**Prevention:** Run `mkdocs build --strict` which treats nav warnings as errors. Add CI check.
**Phase:** Phase 2

### PIT-12: Broken Cross-References Between Languages
Links in `page.en.md` point to `[Italiano](../it/page/)` using hardcoded paths that break when files move.
**Prevention:** Use Material's `cross-refs` or relative links with `.md` extension only. Never hardcode language paths.
**Phase:** Phase 2

### PIT-13: Plugin Load Order Conflicts
Some plugins depend on others running first. `search` must load after `i18n`. `offline` must load after `privacy`.
**Prevention:** Define explicit plugin order in mkdocs.yml. Test both build modes (online and offline).
**Phase:** Phase 1

### PIT-14: Inconsistent File Naming
Mixing `page.en.md` / `page.it.md` with `en/page.md` / `it/page.md` conventions. mkdocs-static-i18n's `docs_structure: suffix` requires consistent suffix pattern.
**Prevention:** Enforce naming convention: always `{name}.{lang}.md` for content files. Add a CI lint step.
**Phase:** Phase 2

### PIT-15: Netlify Caching Issues
Netlify caches the `site/` directory. Stale builds serve old content after deploys.
**Prevention:** Configure `mkdocs build --clean` in netlify.toml. Add `--clean` flag to ensure fresh builds.
**Phase:** Phase 3

### PIT-16: Build Performance With Many Pages
As content grows (100+ pages × 2 languages = 200+ builds), `mkdocs build` gets slow.
**Prevention:** Use `mkdocs-minify-plugin` for HTML/CSS/JS minification. Enable `mkdocs-livereload` during development. Consider splitting large API reference pages.
**Phase:** Phase 2

### PIT-17: Italian Stemming Not Working
Lunr search defaults to English stemming. Italian words like "installazione" won't match partial queries without proper stemming.
**Prevention:** Add `lang: [en, it]` to search plugin config AND install `lunr-languages` package (included with mkdocs-material search).
**Phase:** Phase 2

### PIT-18: Custom CSS/JS Breaking Offline
Custom CSS or JS that references external URLs (icon CDNs, web fonts) breaks in offline mode.
**Prevention:** Audit all custom assets. Either bundle them locally or ensure the `privacy` plugin captures them.
**Phase:** Phase 4

## Minor Pitfalls

### PIT-19: Missing Root Redirect
No `index.md` or redirect from `/` to `/en/` or `/it/`. Users landing at root see a 404.
**Prevention:** Create a root `index.md` that redirects, or configure `mkdocs-static-i18n`'s `default_alternate` setting.
**Phase:** Phase 2

### PIT-20: `nav_translations` Drift
Italian navigation labels (`nav_translations`) get out of sync with actual nav structure in mkdocs.yml.
**Prevention:** Review `nav_translations` whenever nav structure changes. Add to PR checklist.
**Phase:** Phase 2

### PIT-21: ZIP Structure for Offline Distribution
The `site/` directory contains absolute paths that break when extracted to a different location.
**Prevention:** Test offline ZIP by extracting to a different path and opening index.html directly. The `offline` plugin handles most of this, but verify.
**Phase:** Phase 4

### PIT-22: Theme Language for Italian
Material theme `language: it` not set, so UI elements (search placeholder, "Next", "Previous") appear in English even on Italian pages.
**Prevention:** Configure `mkdocs-static-i18n` with `reconfigure_search: true` and ensure Material's `language` setting switches per locale.
**Phase:** Phase 2

### PIT-23: Edit URI for Translated Pages
Edit URI points to the English source even on Italian pages. Contributors click "Edit this page" and land on the wrong file.
**Prevention:** Configure `edit_uri` per-language or disable it if the repo isn't open for contributions.
**Phase:** Phase 2

---
*Research completed: 2026-04-22*