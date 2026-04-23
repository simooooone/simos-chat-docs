---
phase: 03-online-deployment
plan: 01
subsystem: infra
tags: [netlify, github-actions, mkdocs, security-headers, ci-cd]

# Dependency graph
requires:
  - phase: 02-content-i18n
    provides: "Bilingual content and mkdocs.yml i18n configuration"
provides:
  - "netlify.toml with build config, /en/* redirect, and 5 security headers"
  - "runtime.txt specifying Python 3.12 for Netlify build env"
  - "GitHub Actions build-check workflow for PR merge gating"
  - "Updated site_url in mkdocs.yml pointing to Netlify subdomain"
affects: [04-offline-distribution]

# Tech tracking
tech-stack:
  added: [netlify, github-actions, actions/checkout@v6, actions/setup-python@v6]
  patterns: [netlify-toml-build-config, runtime-txt-python-version, github-actions-pr-build-check]

key-files:
  created:
    - netlify.toml
    - runtime.txt
    - .github/workflows/build-check.yml
  modified:
    - mkdocs.yml

key-decisions:
  - "Accepted mkdocs-static-i18n default behavior: English at / not /en/, with /en/* redirect for backward compatibility"
  - "Subdomain docs-airgap-chatbot.netlify.app chosen per Claude's discretion"
  - "CSP includes unsafe-inline for MkDocs Material inline content and Google Fonts origins for online build"

patterns-established:
  - "Root config file convention: comment header with phase reference and decision IDs (D-07, D-09)"
  - "Python version alignment: runtime.txt and build-check.yml python-version must match"
  - "Build command split: Netlify uses plain mkdocs build, GitHub Actions uses mkdocs build --strict"

requirements-completed: [DPL-01, DPL-02, DPL-03]

# Metrics
duration: 10min
completed: 2026-04-23
---

# Phase 3 Plan 01: Online Deployment Config Summary

**Netlify deployment configuration with build settings, /en/* redirect, 5 security headers, Python 3.12 runtime, and GitHub Actions PR build-check workflow**

## Performance

- **Duration:** 10 min
- **Started:** 2026-04-23T10:13:37Z
- **Completed:** 2026-04-23T10:23:55Z
- **Tasks:** 3
- **Files modified:** 4

## Accomplishments
- netlify.toml with build command, publish directory, /en/* backward-compatible redirect, and 5 security headers (X-Frame-Options, X-Content-Type-Options, Referrer-Policy, CSP, HSTS)
- runtime.txt with Python 3.12 (no trailing newline, 4 bytes) for Netlify build environment
- GitHub Actions build-check.yml triggering mkdocs build --strict on pull_request to main
- mkdocs.yml site_url updated from placeholder to https://docs-airgap-chatbot.netlify.app/

## Task Commits

Each task was committed atomically:

1. **Task 1: Create netlify.toml** - `8f2dfc8` (feat)
2. **Task 2: Create runtime.txt and update site_url** - `58bacfc` (feat)
3. **Task 3: Create GitHub Actions build-check workflow** - `e25b725` (feat)

**Plan metadata:** (docs: to be committed)

## Files Created/Modified
- `netlify.toml` - Netlify build config, /en/* redirect, security headers
- `runtime.txt` - Python 3.12 version specification (no trailing newline)
- `.github/workflows/build-check.yml` - PR build verification workflow
- `mkdocs.yml` - site_url updated from placeholder to Netlify subdomain

## Decisions Made
- Accepted mkdocs-static-i18n default behavior: English at `/` not `/en/`, added `/en/*` to `/:splat` 301 redirect for backward compatibility (overrides CONTEXT.md D-08/D-11)
- Subdomain `docs-airgap-chatbot.netlify.app` chosen per Claude's discretion (CONTEXT.md D-10)
- CSP includes `unsafe-inline` for scripts/styles (MkDocs Material inline content) and Google Fonts origins (online build only; privacy plugin localizes these in offline build)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required

None - no external service configuration required by this plan. Netlify site creation and GitHub repository connection remain manual steps (documented in RESEARCH.md Open Questions 2-3) but are out of scope for this plan.

## Next Phase Readiness
- Online deployment configuration complete and verified with `mkdocs build --strict`
- All 4 files in place for Netlify to build and serve the site
- Phase 4 (Offline Distribution) can proceed with offline-specific build-offline.sh and ZIP packaging
- Blocker: GitHub remote not configured -- must create repo and connect to Netlify before deployment works

## Self-Check: PASSED

- All 3 created files verified: netlify.toml, runtime.txt, .github/workflows/build-check.yml
- All 3 task commits verified: 8f2dfc8, 58bacfc, e25b725
- mkdocs.yml modification verified: site_url updated to Netlify subdomain
- mkdocs build --strict passes locally with all changes

---
*Phase: 03-online-deployment*
*Completed: 2026-04-23*