# Phase 3: Online Deployment - Research

**Researched:** 2026-04-23
**Domain:** Netlify deployment, GitHub Actions CI, static site hosting
**Confidence:** HIGH

## Summary

Phase 3 deploys the MkDocs documentation site to Netlify with automated CI/CD. Production deploys happen via Netlify's native git integration (push to main triggers build+deploy). Pull requests get deploy previews automatically from Netlify, plus a lightweight GitHub Actions build-check workflow that validates `mkdocs build` succeeds before merge. Configuration lives in `netlify.toml` (build settings, redirects, security headers) and `runtime.txt` (Python 3.12).

A critical finding emerged during research: **mkdocs-static-i18n v1.3.1 builds the default language (English) at root `/`, not at `/en/`**. The `force_default_in_subdirectory` option (PR #322) is still open and unmerged. This conflicts with CONTEXT.md decisions D-08 and D-11, which assume English at `/en/` with a root redirect. The planner must resolve this conflict -- the most practical approach is to accept the plugin's default behavior (English at `/`, Italian at `/it/`) and add a Netlify redirect from `/en/*` to `/:splat` for backward compatibility.

**Primary recommendation:** Create `netlify.toml` with `mkdocs build` command and `site/` publish directory, `runtime.txt` with `3.12`, a GitHub Actions build-check workflow for PRs, and security headers. Update `site_url` in `mkdocs.yml` to the actual Netlify subdomain. Resolve the `/en/` path conflict by using the plugin's default behavior with a redirect rule.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** Netlify native git integration for production deploys -- Netlify connects directly to the GitHub repo, builds on push to main. No GitHub Actions workflow for production deploys.
- **D-02:** Push to main triggers production deploys only. No tag-based or release-based deploys for v1.
- **D-03:** GitHub Actions workflow for build verification on PRs -- a lightweight check that `mkdocs build` succeeds, separate from Netlify's deploy preview. Catches build errors before merge.
- **D-04:** Public deploy previews -- anyone with the preview URL can view PR deployments.
- **D-05:** Netlify PR bot comments -- automatic comments on each PR with the deploy preview URL and status. Zero additional config needed.
- **D-06:** Auto-cleanup on PR close -- Netlify automatically removes deploy previews when a PR is closed or merged. No custom retention policy.
- **D-07:** Python version specified via `runtime.txt` file (not netlify.toml env var). Netlify reads this automatically.
- **D-08:** Root URL redirect `/` to `/en/` via netlify.toml redirect rule.
- **D-09:** Standard security headers in netlify.toml: X-Frame-Options, X-Content-Type-Options, Referrer-Policy, and basic Content-Security-Policy.
- **D-10:** Netlify subdomain for v1 (e.g., docs-airgap-chatbot.netlify.app). Zero DNS configuration, instant setup.
- **D-11:** Language paths: English at `/en/`, Italian at `/it/`. Root `/` redirects to `/en/` per D-08.
- **D-12:** Netlify automatic HTTPS via Let's Encrypt. Zero certificate management.

### Claude's Discretion
- Exact Netlify site name/subdomain (as long as it's descriptive)
- Specific GitHub Actions workflow file name and job structure (as long as it runs `mkdocs build`)
- Exact security header values (as long as they follow current best practices)
- netlify.toml build command and publish directory (must be `mkdocs build` and `site/`)

### Deferred Ideas (OUT OF SCOPE)
None
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| DPL-01 | Netlify deployment configured via `netlify.toml` -- build command, publish directory, Python version | Standard Stack: netlify.toml with `[build]` section; Python version via `runtime.txt` (D-07) |
| DPL-02 | Python runtime version specified in `runtime.txt` (3.12.x) for Netlify build environment | `runtime.txt` format: `3.12` (x.y only, no trailing newline); Netlify auto-reads this file |
| DPL-03 | GitHub Actions CI/CD pipeline auto-deploys to Netlify on push to main branch | Overridden by D-01: Netlify native git integration handles production deploys. D-03 adds a GitHub Actions build-check on PRs instead. |
| DPL-04 | Branch deploy previews enabled for pull requests via Netlify | Netlify deploy previews are automatic when git integration is connected; no extra config needed |
</phase_requirements>

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Static site hosting and CDN | CDN / Static | -- | Netlify serves pre-built static files from its CDN edge network |
| Build execution (mkdocs build) | CDN / Static | -- | Netlify build system runs `mkdocs build` and deploys the `site/` output |
| CI build verification | API / Backend | -- | GitHub Actions runs `mkdocs build` as a merge gate check on PRs |
| Redirect rules | CDN / Static | -- | Netlify processes redirect rules at the edge before serving files |
| Security headers | CDN / Static | -- | Netlify applies headers at the edge on every response |
| Python dependency installation | CDN / Static | -- | Netlify build system auto-installs from `requirements.txt` before build command |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Netlify | N/A (SaaS) | Static site hosting with git integration | D-10 decision; native deploy previews, automatic HTTPS, edge CDN |
| GitHub Actions | N/A (SaaS) | PR build verification | D-03 decision; lightweight `mkdocs build` check on pull requests |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `actions/checkout` | v6 | Clone repo in GitHub Actions | Required step in every workflow |
| `actions/setup-python` | v6 | Set Python version in GitHub Actions | Ensures build-check uses same Python version as Netlify |
| `mkdocs` | >=1.6,<2.0 | Static site generator | Build command in both Netlify and GitHub Actions |
| `mkdocs-static-i18n` | 1.3.1 | Bilingual build output | Generates `/` (English) and `/it/` (Italian) paths |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `runtime.txt` for Python version | `PYTHON_VERSION` env var in `netlify.toml` | D-07 locks `runtime.txt`; env var is newer and more flexible but user chose file-based |
| Netlify native git integration | GitHub Actions + Netlify CLI deploy | D-01 locks native integration; Actions+CLI gives more control but adds complexity |
| Public deploy previews | Password-protected previews | D-04 locks public; appropriate for documentation, not sensitive content |

**Installation:**
No npm packages required. Netlify dependencies are the existing `requirements.txt`. GitHub Actions actions (`actions/checkout@v6`, `actions/setup-python@v6`) are referenced by version tag.

**Version verification:**
- `actions/checkout@v6` -- verified via GitHub API (v6.0.2, released 2026-01-09) [VERIFIED: GitHub API]
- `actions/setup-python@v6` -- verified via GitHub API (v6.2.0, released 2026-01-22) [VERIFIED: GitHub API]
- `mkdocs-static-i18n==1.3.1` -- verified via `pip3 show` [VERIFIED: local installation]

## Architecture Patterns

### System Architecture Diagram

```
                    GitHub Repository
                    (main branch)
                         |
          +--------------+---------------+
          |                              |
    Push to main                Pull Request opened
          |                              |
          v                              v
   Netlify Git                +---------+----------+
   Integration                |                    |
   (auto-trigger)             |  Netlify Deploy    |
          |                   |  Preview (auto)    |
          v                   |  + PR bot comment  |
   Netlify Build              +--------------------+
   (pip install +                     |
    mkdocs build)              Preview URL on
          |                    deploy-preview-N--
          v                    --site.netlify.app
   site/ output
   deployed to
   Netlify CDN
          |                            ^
          |                            |
          |              +-------------+-------------+
          |              |                           |
          |        GitHub Actions              Manual review
          |        build-check workflow        of preview
          |        (mkdocs build on PR)        
          |              |                           
          |              v                           
          |        Pass/Fail status            
          |        check on PR                   
          |                                    
   Netlify subdomain                         
   https://SITE.netlify.app/                 
          |                                  
          v                                  
   Root `/` serves English (default)         
   `/it/` serves Italian                      
   Security headers on all responses          
```

### Recommended Project Structure
```
.github/
  workflows/
    build-check.yml    # PR build verification workflow
netlify.toml           # Build config, redirects, security headers
runtime.txt            # Python version for Netlify (3.12)
mkdocs.yml             # Updated site_url to Netlify subdomain
requirements.txt       # Unchanged -- already pinned
```

### Pattern 1: Netlify native git integration for production deploys
**What:** Netlify connects directly to the GitHub repository. On push to main, Netlify automatically pulls the code, installs dependencies, runs the build command, and deploys the output.
**When to use:** When you want zero-maintenance CI/CD for a static site. No GitHub Actions needed for production deploys.
**Example:**
```toml
# netlify.toml
[build]
  command = "mkdocs build"
  publish = "site/"
```
Netlify auto-detects `requirements.txt` and runs `pip install` before the build command. No `pip install` step needed in the command. [CITED: docs.netlify.com/build/configure-builds/manage-dependencies]

### Pattern 2: GitHub Actions build-check on PRs
**What:** A lightweight workflow that runs `mkdocs build` on every pull request targeting main. Serves as a merge gate -- if the build fails, the PR gets a failing status check.
**When to use:** To catch build errors before they reach the production branch. Complements Netlify deploy previews (which also build on PRs) with a visible pass/fail check.
**Example:**
```yaml
# .github/workflows/build-check.yml
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
[VERIFIED: docs.github.com/en/actions/tutorials/build-and-test-code/python]

### Pattern 3: runtime.txt for Python version
**What:** A file in the repo root containing only the Python major.minor version. Netlify reads this automatically to set the build Python version.
**When to use:** When you want the Python version committed to the repository (visible, version-controlled) rather than in a Netlify env var or UI setting.
**Example:**
```
3.12
```
**Rules:**
- Format: `x.y` only (e.g., `3.12`, NOT `3.12.1` or `python-3.12`)
- No trailing newline
- Must be in the site's base directory
- Overrides Pipfile if both exist
[CITED: docs.netlify.com/build/configure-builds/manage-dependencies]

### Anti-Patterns to Avoid
- **Including `pip install` in the Netlify build command:** Netlify automatically runs `pip install -r requirements.txt` when `requirements.txt` is present. Adding it to the command is redundant and can cause version conflicts. [CITED: docs.netlify.com/build/configure-builds/manage-dependencies]
- **Using `navigation.instant` in mkdocs.yml:** Already excluded in CLAUDE.md -- Fetch API fails on file:// protocol. Not a deployment issue per se, but must not be re-enabled.
- **Setting `PYTHON_VERSION` env var alongside `runtime.txt`:** While both methods work, D-07 locks `runtime.txt`. Using both creates confusion about which takes precedence. Use one method only.
- **Configuring deploy previews manually:** Netlify automatically creates deploy previews for PRs when git integration is connected. No custom workflow or configuration needed for basic deploy previews. [CITED: docs.netlify.com/site-deploys/deploy-previews]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Python version detection on Netlify | Custom build script that sets up Python | `runtime.txt` file | Netlify natively reads this file; custom scripts break when build image updates |
| Deploy preview creation | GitHub Actions workflow that deploys to Netlify | Netlify's automatic deploy previews | Netlify creates previews automatically for every PR; custom workflows need secrets, CLI setup, and permission management |
| PR bot comments | Custom GitHub Action that posts preview URLs | Netlify's built-in deploy notifications | Netlify automatically posts preview URLs as PR comments when connected; zero config [CITED: docs.netlify.com/site-deploys/deploy-previews] |
| HTTPS certificates | Custom SSL setup | Netlify automatic HTTPS | Netlify provisions Let's Encrypt certificates automatically; zero management [CITED: D-12] |
| Redirect logic | JavaScript-based routing | Netlify redirect rules in `netlify.toml` | Server-side redirects are faster, SEO-friendly, and handle edge cases (JavaScript disabled, crawlers) [CITED: docs.netlify.com/manage/routing/redirects] |

**Key insight:** Netlify provides deploy previews, PR comments, HTTPS, and redirect processing as built-in platform features. The only custom automation needed is the GitHub Actions build-check workflow for PR merge gating.

## Common Pitfalls

### Pitfall 1: Default language path mismatch with i18n plugin
**What goes wrong:** CONTEXT.md assumes English at `/en/` and a redirect from `/` to `/en/`. But mkdocs-static-i18n v1.3.1 builds the default language at root `/`, not `/en/`. A redirect from `/` to `/en/` would create an infinite loop or 404 because no `/en/` directory exists in the build output.
**Why it happens:** The `force_default_in_subdirectory` option (PR #322 on mkdocs-static-i18n) is still open and unmerged as of 2025-06-17. The plugin has always built the default language at root since v1.0.0.
**How to avoid:** Accept that English lives at `/` and Italian at `/it/`. Add a redirect from `/en/*` to `/:splat` for backward compatibility (in case anyone bookmarks `/en/` URLs). Do NOT redirect `/` to `/en/` (that would 404).
**Warning signs:** If a redirect from `/` to `/en/` is added, the site will return 404 for the homepage. [VERIFIED: local `mkdocs build` test confirmed no `/en/` directory in output]

### Pitfall 2: runtime.txt with trailing newline
**What goes wrong:** If `runtime.txt` contains a trailing newline (e.g., written by an editor that auto-adds one), Netlify may fail to parse the Python version correctly and fall back to a default version.
**Why it happens:** The file format specification explicitly requires "no trailing newline." Many text editors and tools add a trailing newline by default.
**How to avoid:** Write the file with `printf '3.12' > runtime.txt` or verify the file has no trailing newline. Check with `xxd runtime.txt` -- should end with `32` (the character `2`), not `0a` (newline).
**Warning signs:** Netlify build log shows unexpected Python version, or pip fails to install packages that require Python 3.12+. [CITED: docs.netlify.com/build/configure-builds/manage-dependencies]

### Pitfall 3: Forgetting to update site_url in mkdocs.yml
**What goes wrong:** The current `site_url` is `https://docs.airgap-chatbot.example.com/` (placeholder). If not updated to the actual Netlify subdomain, the language switcher generates incorrect URLs, canonical links are wrong, and the sitemap contains invalid URLs.
**Why it happens:** `site_url` is easy to overlook when configuring deployment -- it doesn't break the build, only the generated URLs.
**How to avoid:** Update `site_url` in `mkdocs.yml` to the actual Netlify URL (e.g., `https://docs-airgap-chatbot.netlify.app/`) as part of the deployment configuration.
**Warning signs:** Language switcher links point to `example.com`; sitemap.xml contains placeholder URLs; SEO indexing fails. [VERIFIED: mkdocs-static-i18n issues #261, #289 confirm this causes 404s on language switch]

### Pitfall 4: Netlify build command running pip install unnecessarily
**What goes wrong:** Setting the build command to `pip install -r requirements.txt && mkdocs build` causes double pip installs -- once automatically by Netlify, once explicitly in the command. This wastes build time and can cause version resolution conflicts.
**Why it happens:** Not knowing that Netlify auto-installs from `requirements.txt` when the file exists.
**How to avoid:** Use `mkdocs build` as the build command only. Netlify handles dependency installation automatically.
**Warning signs:** Build log shows two pip install runs; build times are slower than expected. [CITED: docs.netlify.com/build/configure-builds/manage-dependencies]

### Pitfall 5: Netlify git integration not connected to the right branch
**What goes wrong:** If the production branch in Netlify is set to something other than `main`, pushes to main won't trigger production deploys.
**Why it happens:** Netlify defaults to the branch that was first connected. If the repo initially had a `master` branch and later switched to `main`, the production branch setting may not have been updated.
**How to avoid:** When setting up the Netlify site, explicitly set the production branch to `main` in Site settings > Build and deploy > Continuous Deployment. Verify after first deploy.
**Warning signs:** Push to main doesn't trigger a deploy; deploys happen on wrong branch. [ASSUMED]

### Pitfall 6: GitHub Actions build-check uses different Python version than Netlify
**What goes wrong:** If the GitHub Actions workflow uses a different Python version than `runtime.txt` specifies, a build could pass on GitHub Actions but fail on Netlify (or vice versa).
**Why it happens:** Forgetting to align `actions/setup-python` version with `runtime.txt`.
**How to avoid:** Use `python-version: '3.12'` in `actions/setup-python@v6` to match the `runtime.txt` value.
**Warning signs:** Build passes on PR check but fails on Netlify deploy, or vice versa.

## Code Examples

Verified patterns from official sources:

### netlify.toml -- Build configuration
```toml
# Source: [CITED: docs.netlify.com/build/configure-builds/file-based-configuration]
[build]
  command = "mkdocs build"
  publish = "site/"
```

### netlify.toml -- Redirect for /en/ backward compatibility
```toml
# Source: [CITED: docs.netlify.com/manage/routing/redirects]
# Redirect /en/* to /* since mkdocs-static-i18n builds default language at root
[[redirects]]
  from = "/en/*"
  to = "/:splat"
  status = 301
```

### netlify.toml -- Security headers
```toml
# Source: [CITED: docs.netlify.com/manage/routing/headers]
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Content-Security-Policy = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self'; connect-src 'self'"
    Strict-Transport-Security = "max-age=31536000; includeSubDomains; preload"
```
Note: CSP allows `'unsafe-inline'` for scripts and styles because MkDocs Material generates inline styles and scripts. The `fonts.googleapis.com` and `fonts.gstatic.com` origins are needed for Material theme Google Fonts. The offline build (Phase 4) uses the privacy plugin to localize these, so the online build's CSP must allow them.

### runtime.txt -- Python version for Netlify
```
3.12
```
[Source: [CITED: docs.netlify.com/build/configure-builds/manage-dependencies]]
Format: `x.y` only, no trailing newline.

### GitHub Actions build-check workflow
```yaml
# Source: [VERIFIED: docs.github.com/en/actions/tutorials/build-and-test-code/python]
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
Note: `--strict` flag causes MkDocs to treat warnings as errors, making the check stricter than the Netlify build. This catches broken links and other warnings that would otherwise be silently ignored. [VERIFIED: MkDocs documentation confirms `--strict` behavior]

### mkdocs.yml -- site_url update
```yaml
site_url: https://docs-airgap-chatbot.netlify.app/
```
The exact subdomain is Claude's discretion per CONTEXT.md. Replace the placeholder `https://docs.airgap-chatbot.example.com/` with the actual Netlify URL.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Netlify limited Python versions (2.7/3.8) | Any Python version via `PYTHON_VERSION` or `runtime.txt` | Oct 2024 [CITED: netlify.com/blog/announcing-configurable-python-versions] | Can now use Python 3.12+ on Netlify; no longer stuck on 3.8 |
| `actions/checkout@v4` (Node 20) | `actions/checkout@v6` (Node 24, separate credential storage) | Nov 2025 [VERIFIED: GitHub releases] | v6 stores credentials more securely; no workflow changes needed |
| `actions/setup-python@v5` (Node 20) | `actions/setup-python@v6` (Node 24) | Sep 2025 [VERIFIED: GitHub releases] | v6 adds `pip-version` and `pip-install` inputs; Node 24 runtime |
| `mkdocs build` (default) | `mkdocs build --strict` for CI | Standard practice | Using `--strict` in CI catches warnings as errors; keeps production builds non-strict |

**Deprecated/outdated:**
- `X-XSS-Protection` header: Deprecated in favor of Content-Security-Policy. Modern browsers ignore it when CSP is present. Do not include. [ASSUMED -- widely documented but not a single official deprecation notice]
- `actions/checkout@v4` and `@v5`: Still functional but superseded by v6. Use v6 for new workflows.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `X-XSS-Protection` header is deprecated and should be omitted | Security Headers | LOW -- even if not formally deprecated, CSP supersedes it; including it is harmless but adds clutter |
| A2 | Netlify git integration will connect to the `main` branch by default if that's the default branch on GitHub | Pitfall 5 | MEDIUM -- if Netlify defaults to a different branch, production deploys won't trigger on push to main; requires manual verification |
| A3 | Netlify auto-posts deploy preview URLs as PR comments when git integration is connected (D-05) | Don't Hand-Roll | LOW -- confirmed by multiple sources, but the exact behavior may depend on deploy notification settings being enabled |
| A4 | The CSP `unsafe-inline` directive is needed for MkDocs Material's inline styles/scripts | Code Examples | MEDIUM -- if Material generates only nonce-based scripts in a future version, `unsafe-inline` could be removed for better security |

## Open Questions

1. **Default language path conflict (D-08, D-11 vs. mkdocs-static-i18n behavior)**
   - What we know: mkdocs-static-i18n v1.3.1 builds English at root `/`, not `/en/`. PR #322 for `force_default_in_subdirectory` is open but unmerged.
   - What's unclear: Whether the user wants to (a) accept the plugin's default and adjust D-08/D-11, or (b) pursue a workaround.
   - Recommendation: Accept the plugin's default (English at `/`). Add a redirect from `/en/*` to `/:splat` for backward compatibility. Do NOT redirect `/` to `/en/` (that would 404). The planner should treat this as a resolved conflict: English lives at `/`, Italian at `/it/`.

2. **GitHub remote not configured**
   - What we know: `git remote -v` returns empty. The repo has no GitHub remote configured.
   - What's unclear: Whether the GitHub repository already exists, or needs to be created.
   - Recommendation: The planner should include a step to add the GitHub remote and push the repo. Netlify git integration requires a GitHub repository.

3. **Netlify site creation method**
   - What we know: The site needs to be created on Netlify and connected to the GitHub repo.
   - What's unclear: Whether this should be done via `netlify-cli` or the Netlify UI. The UI is simpler for first-time setup.
   - Recommendation: Manual setup via Netlify UI is the simplest path. The plan should document the steps but not automate them (one-time setup).

4. **Content-Security-Policy for MkDocs Material online build**
   - What we know: Material theme loads Google Fonts and uses inline styles/scripts. The online build does NOT use the privacy plugin (that's offline only).
   - What's unclear: Exact CSP directives needed -- depends on what Material 9.7.x actually loads at runtime.
   - Recommendation: Start with a permissive CSP and tighten after deployment. Use `Content-Security-Policy-Report-Only` first if needed. The CSP in Code Examples is a reasonable starting point.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Python 3.12+ | mkdocs build (local + CI) | N/A (local has 3.14) | 3.14.3 | Local dev uses any 3.x; Netlify uses 3.12 via runtime.txt |
| pip | Dependency installation | Available | 26.0.1 | -- |
| mkdocs | Build command | Available | 1.6.1 | -- |
| mkdocs-static-i18n | i18n build | Available | 1.3.1 | -- |
| git | Version control | Available | system | -- |
| GitHub repository | Netlify git integration | Not configured | -- | Must create and push |
| Netlify account | Hosting | Unknown | -- | Must verify account exists |

**Missing dependencies with no fallback:**
- GitHub repository: No remote configured. Must create repo on GitHub and add as git remote before Netlify integration can be set up.
- Netlify account: Must verify the user has a Netlify account. Required for deployment.

**Missing dependencies with fallback:**
- Python 3.12 specifically: Local machine has 3.14, which is compatible. Netlify will use 3.12 from `runtime.txt`. No issue.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | GitHub Actions build-check (no unit test framework) |
| Config file | `.github/workflows/build-check.yml` (to be created) |
| Quick run command | `mkdocs build --strict` |
| Full suite command | `mkdocs build --strict` (same -- this is a static site) |

### Phase Requirements to Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DPL-01 | `netlify.toml` configures build correctly | smoke | `mkdocs build` succeeds on Netlify | No -- Wave 0 |
| DPL-02 | Python 3.12 specified in runtime.txt | smoke | Netlify build log shows Python 3.12 | No -- Wave 0 |
| DPL-03 | Push to main triggers deploy | integration | Push to main, verify Netlify deploy | No -- manual |
| DPL-04 | PR generates deploy preview | integration | Open PR, verify preview URL | No -- manual |
| DPL-03 (partial) | `mkdocs build` succeeds on PR | unit (CI) | `mkdocs build --strict` in GitHub Actions | No -- Wave 0 |

### Sampling Rate
- **Per task commit:** `mkdocs build` (local verification)
- **Per wave merge:** `mkdocs build --strict` (local) + push to PR branch (triggers GitHub Actions check)
- **Phase gate:** Full deploy to Netlify verified (manual)

### Wave 0 Gaps
- [ ] `.github/workflows/build-check.yml` -- covers PR build verification
- [ ] `netlify.toml` -- covers DPL-01 build configuration
- [ ] `runtime.txt` -- covers DPL-02 Python version
- [ ] Manual tests: Netlify site creation, git integration, deploy preview verification (cannot be automated)

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Public documentation site, no user auth |
| V3 Session Management | no | No sessions on static site |
| V4 Access Control | no | No access control needed (public docs) |
| V5 Input Validation | no | Static site, no user input processing |
| V6 Cryptography | no | HTTPS handled by Netlify (Let's Encrypt), no app-level crypto |

### Known Threat Patterns for Static Site on Netlify

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Clickjacking | Tampering | X-Frame-Options: DENY in netlify.toml headers |
| MIME sniffing | Tampering | X-Content-Type-Options: nosniff in headers |
| XSS via injected content | Tampering | Content-Security-Policy in headers; MkDocs sanitizes markdown |
| Referrer info leakage | Information Disclosure | Referrer-Policy: strict-origin-when-cross-origin |
| MITM on HTTP | Spoofing | Strict-Transport-Security (HSTS) + Netlify auto-HTTPS |

Note: This is a public documentation site with no authentication, no user input, and no sensitive data. Security headers are defense-in-depth, not compliance requirements. The threat model is minimal.

## Sources

### Primary (HIGH confidence)
- Context7 /websites/netlify -- netlify.toml configuration, build settings, deploy previews, redirects, headers
- docs.netlify.com/build/configure-builds/manage-dependencies -- Python version via runtime.txt, pip install auto-behavior
- docs.netlify.com/build/configure-builds/file-based-configuration -- netlify.toml full reference
- docs.netlify.com/site-deploys/deploy-previews -- Deploy preview behavior, PR comments
- Context7 /websites/github_en_actions -- GitHub Actions Python workflow patterns, PR triggers

### Secondary (MEDIUM confidence)
- docs.github.com/en/actions/tutorials/build-and-test-code/python -- Python setup with actions/setup-python, pip caching
- github.com/actions/checkout/releases -- v6.0.2 release (2026-01-09)
- github.com/actions/setup-python/releases -- v6.2.0 release (2026-01-22)
- github.com/ultrabug/mkdocs-static-i18n/pull/322 -- force_default_in_subdirectory PR status (open, unmerged)
- netlify.com/blog/announcing-configurable-python-versions -- Configurable Python versions (Oct 2024)
- blog.serghei.pl/posts/configuring-security-headers-with-netlify -- Security header best practices

### Tertiary (LOW confidence)
- Local `mkdocs build` test -- confirmed no `/en/` directory in output (build output was temporary, not committed)
- mkdocs-static-i18n issues #261, #289, #247, #306 -- site_url and default language path issues

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- Netlify and GitHub Actions are well-documented, versions verified via API
- Architecture: HIGH -- Simple static site deployment; well-established patterns
- Pitfalls: HIGH -- Default language path conflict confirmed via actual build test; runtime.txt format confirmed by official docs

**Research date:** 2026-04-23
**Valid until:** 2026-05-23 (stable domain; Netlify and GitHub Actions change slowly)