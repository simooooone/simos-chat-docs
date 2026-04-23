# Phase 3: Online Deployment - Pattern Map

**Mapped:** 2026-04-23
**Files analyzed:** 4 (3 config create + 1 config modify)
**Analogs found:** 2 / 4

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `netlify.toml` | config | request-response | `mkdocs.yml` (root config file) | role-match |
| `runtime.txt` | config | N/A (static) | `requirements.txt` (root config, build deps) | role-match |
| `.github/workflows/build-check.yml` | config (CI/CD) | batch | RESEARCH.md Pattern 2 (lines 169-187) | research-only |
| `mkdocs.yml` | config | static-build | `mkdocs.yml` (existing, line 11) | exact (self-modify) |

## Pattern Assignments

### `netlify.toml` (config, request-response -- CREATE)

**Analog:** `mkdocs.yml` (project root config file -- same role as deployment configuration)

No `netlify.toml` exists in the codebase. The project has one root config pattern: `mkdocs.yml` defines build behavior for MkDocs; `netlify.toml` defines build behavior for Netlify. Both are declarative config files at the project root that control how the site is built and served.

**Primary pattern source:** RESEARCH.md "Code Examples" (lines 265-293)

**Imports/header pattern:**
```toml
# netlify.toml -- Netlify deployment configuration
# Phase 3: Online deployment
#
# Build settings: Netlify runs `mkdocs build` and serves the `site/` output
# Python version: Specified in runtime.txt (NOT here) per D-07
# Dependencies: Netlify auto-installs from requirements.txt -- do NOT add pip install to command
```

**Core build configuration** (from RESEARCH.md lines 265-269):
```toml
[build]
  command = "mkdocs build"
  publish = "site/"
```

**Redirect rule for /en/ backward compatibility** (from RESEARCH.md lines 272-280):
```toml
# Redirect /en/* to /* since mkdocs-static-i18n builds default language at root
# Do NOT redirect / to /en/ -- that would 404 (English lives at /, not /en/)
[[redirects]]
  from = "/en/*"
  to = "/:splat"
  status = 301
```

**Security headers** (from RESEARCH.md lines 283-293):
```toml
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Content-Security-Policy = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self'; connect-src 'self'"
    Strict-Transport-Security = "max-age=31536000; includeSubDomains; preload"
```

**Key constraints for netlify.toml:**

1. Build command MUST be `mkdocs build` only -- do NOT add `pip install` (Netlify auto-installs from requirements.txt; see RESEARCH.md Pitfall 4)
2. Publish directory MUST be `site/` (MkDocs default output directory)
3. `/en/*` redirect goes TO `/:splat` (not the other way) -- English is at root, not `/en/` (RESEARCH.md Pitfall 1)
4. CSP MUST include `'unsafe-inline'` for scripts and styles (MkDocs Material generates inline content)
5. CSP MUST include `https://fonts.googleapis.com` and `https://fonts.gstatic.com` (Material theme Google Fonts; online build does NOT use privacy plugin)
6. Do NOT include deprecated `X-XSS-Protection` header (superseded by CSP; RESEARCH.md "State of the Art")
7. Python version goes in `runtime.txt`, NOT in netlify.toml env var (D-07)

**Comment convention** (follow `mkdocs.yml` pattern):
```toml
# Config files in this project use decision references in comments:
#   D-07 = runtime.txt for Python version
#   D-08 = root redirect (adjusted: /en/* -> /* instead of / -> /en/)
#   D-09 = security headers
```

---

### `runtime.txt` (config, N/A -- CREATE)

**Analog:** `requirements.txt` (project root, defines build dependency info as a simple text file)

No `runtime.txt` exists. The closest analog is `requirements.txt`: both are simple text files at the project root that declare build environment information. `requirements.txt` declares Python package dependencies; `runtime.txt` declares the Python runtime version.

**Primary pattern source:** RESEARCH.md "Code Examples" (lines 297-299) and "Pattern 3" (lines 192-202)

**Full file pattern:**
```
3.12
```

**Key constraints for runtime.txt:**

1. Format: `x.y` only (e.g., `3.12`, NOT `3.12.1` or `python-3.12`) -- Netlify parses this format specifically
2. No trailing newline -- write with `printf '3.12' > runtime.txt`, verify with `xxd runtime.txt` (should end with `32`, not `0a`) (RESEARCH.md Pitfall 2)
3. Must be in the site's base directory (project root) for Netlify to auto-read it
4. Do NOT also set `PYTHON_VERSION` env var in netlify.toml -- use ONE method only (D-07 locks runtime.txt) (RESEARCH.md Anti-Pattern)

**Comment convention:** Unlike `requirements.txt` which uses `#` comments, `runtime.txt` contains ONLY the version number with no comments (Netlify reads the entire file as the version string).

---

### `.github/workflows/build-check.yml` (config/CI, batch -- CREATE)

**Analog:** No GitHub Actions workflows exist in the codebase. No `.github/` directory exists at all.

**Primary pattern source:** RESEARCH.md "Code Examples" (lines 304-323) and "Pattern 2" (lines 165-188)

**Full workflow pattern:**
```yaml
name: Build Check

on:
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-python@v6
        with:
          python-version: '3.12'
          cache: 'pip'
      - run: pip install -r requirements.txt
      - run: mkdocs build --strict
```

**Key constraints for build-check.yml:**

1. Trigger MUST be `pull_request` targeting `main` only -- NOT push (D-01: Netlify handles production deploys via native git integration, not GitHub Actions)
2. Use `actions/checkout@v6` and `actions/setup-python@v6` (verified current versions; RESEARCH.md "Standard Stack" lines 75-76)
3. Python version MUST be `'3.12'` -- must match `runtime.txt` value (RESEARCH.md Pitfall 6)
4. Use `cache: 'pip'` in setup-python for faster CI runs
5. Use `mkdocs build --strict` (NOT plain `mkdocs build`) -- `--strict` treats warnings as errors, making the CI check stricter than Netlify's build. This catches broken links and other issues. (RESEARCH.md Code Examples line 324)
6. Unlike Netlify, GitHub Actions does NOT auto-install from requirements.txt -- explicit `pip install -r requirements.txt` step IS required here (unlike netlify.toml where it would be redundant)

**Directory creation note:** The `.github/workflows/` directory does not exist. It must be created before writing the workflow file.

---

### `mkdocs.yml` (config, static-build -- MODIFY)

**Analog:** `mkdocs.yml` (existing file, self-modification)

Only one targeted modification is needed: update the `site_url` value from the placeholder to the actual Netlify subdomain.

**Current value** (line 11):
```yaml
site_url: https://docs.airgap-chatbot.example.com/
```

**Target value** (from RESEARCH.md lines 327-329):
```yaml
site_url: https://docs-airgap-chatbot.netlify.app/
```

The exact subdomain is Claude's discretion per CONTEXT.md. The pattern `docs-airgap-chatbot.netlify.app` is descriptive and follows the convention `{project-description}.netlify.app`.

**Why this matters (RESEARCH.md Pitfall 3):**
- `site_url` controls language switcher URLs -- if not updated, links point to `example.com`
- `site_url` controls canonical links in the sitemap -- if not updated, SEO indexing fails
- mkdocs-static-i18n issues #261 and #289 confirm this causes 404s on language switch
- The build does NOT break with a placeholder URL -- the issue is invisible until deployment

**No other changes to mkdocs.yml in this phase.** The `!ENV [OFFLINE, false]` conditionals on offline/privacy plugins naturally cause Netlify to skip them (since Netlify does not set `OFFLINE=true`), so the online build works without modification to plugin config.

---

## Shared Patterns

### Root config file convention
**Source:** `mkdocs.yml` and `requirements.txt`
**Apply to:** `netlify.toml` and `runtime.txt`

Both existing root config files follow the pattern:
1. Comment header explaining purpose and phase
2. Inline comments referencing decision IDs (e.g., `D-07`, `PIT-01`)
3. Declarative configuration (not imperative scripts)

Example from `requirements.txt` (lines 1-7):
```
# Core dependencies - pinned to compatible versions
# MkDocs must stay on 1.x - 2.0 breaks the Material plugin system (PIT-01)
mkdocs>=1.6,<2.0
mkdocs-material>=9.7,<10.0
# i18n plugin - use mkdocs-static-i18n, NOT mkdocs-i18n (abandoned) (PIT-02)
mkdocs-static-i18n==1.3.1
pymdown-extensions>=10.21,<11.0
```

`netlify.toml` should follow this convention: phase header, decision ID references in comments, declarative config sections.

### Build command alignment
**Source:** `mkdocs.yml` + RESEARCH.md
**Apply to:** `netlify.toml` and `.github/workflows/build-check.yml`

Both Netlify and GitHub Actions run `mkdocs build`, but with different semantics:
- **Netlify** (`netlify.toml`): `mkdocs build` (plain) -- Netlify auto-installs deps; do NOT add `pip install` to command
- **GitHub Actions** (`build-check.yml`): `mkdocs build --strict` + explicit `pip install -r requirements.txt` step -- Actions has no auto-install; `--strict` catches warnings as errors for CI merge gating

The build command is the same core operation (`mkdocs build`), but the CI version adds `--strict` for stricter validation.

### Default language path convention (CRITICAL)
**Source:** RESEARCH.md Pitfall 1 (lines 224-228)
**Apply to:** `netlify.toml` redirect rules and `mkdocs.yml` site_url

mkdocs-static-i18n v1.3.1 builds the default language (English) at root `/`, not at `/en/`. This is a critical conflict with CONTEXT.md D-08 and D-11, which assumed English at `/en/`.

**Resolution (from RESEARCH.md Open Question 1):** Accept the plugin's default behavior:
- English content is served at `/` (root)
- Italian content is served at `/it/`
- Add a redirect from `/en/*` to `/:splat` for backward compatibility
- Do NOT redirect `/` to `/en/` (that would cause a 404)

This affects:
- `netlify.toml`: redirect `/en/*` -> `/:splat` (not `/` -> `/en/`)
- `mkdocs.yml`: `site_url` uses root URL (e.g., `https://docs-airgap-chatbot.netlify.app/`)
- `docs/overrides/main.html`: English announce link uses `/chat/getting-started/` (root path, confirmed in existing file line 13)

### Python version consistency
**Source:** `runtime.txt` + RESEARCH.md Pitfall 6
**Apply to:** `runtime.txt` and `.github/workflows/build-check.yml`

Python 3.12 is specified in two places:
1. `runtime.txt`: `3.12` (Netlify reads this automatically)
2. `.github/workflows/build-check.yml`: `python-version: '3.12'` in `actions/setup-python@v6`

These MUST match. If one is updated, the other must be updated too. Mismatch causes builds that pass on one platform but fail on the other.

---

## No Analog Found

| File | Role | Data Flow | Reason |
|------|------|-----------|--------|
| `.github/workflows/build-check.yml` | config (CI/CD) | batch | No `.github/` directory or GitHub Actions workflows exist in the project. RESEARCH.md provides the verified pattern. |

Note: `netlify.toml` and `runtime.txt` have partial role-match analogs (`mkdocs.yml` and `requirements.txt` respectively) for the root-config-file convention, but their content patterns come entirely from RESEARCH.md. The planner should use RESEARCH.md code examples as the primary implementation source for all three new files, applying the shared root-config-file convention from the existing project files.

---

## Metadata

**Analog search scope:** Project root (`mkdocs.yml`, `requirements.txt`, `.gitignore`, `CLAUDE.md`), `docs/overrides/`, `.github/` (does not exist)
**Files scanned:** 6 (mkdocs.yml, requirements.txt, .gitignore, CLAUDE.md, docs/overrides/main.html)
**Pattern extraction date:** 2026-04-23