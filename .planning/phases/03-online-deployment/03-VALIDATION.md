---
phase: 03
slug: online-deployment
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-04-23
---

# Phase 03 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | GitHub Actions build-check (no unit test framework — static site) |
| **Config file** | `.github/workflows/build-check.yml` (Wave 0 creates) |
| **Quick run command** | `mkdocs build` |
| **Full suite command** | `mkdocs build --strict` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run `mkdocs build`
- **After every plan wave:** Run `mkdocs build --strict` + push to PR branch (triggers GitHub Actions)
- **Before `/gsd-verify-work`:** Full suite must be green + Netlify deploy verified
- **Max feedback latency:** 60 seconds (local build)

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | DPL-01 | T-03-01 / — | Build config in netlify.toml serves site correctly | smoke | `mkdocs build` | ❌ W0 | ⬜ pending |
| 03-01-02 | 01 | 1 | DPL-02 | — | runtime.txt specifies Python 3.12 | smoke | `cat runtime.txt` shows `3.12` | ❌ W0 | ⬜ pending |
| 03-01-03 | 01 | 1 | DPL-01 | — | Redirect /en/* to /:splat works | smoke | `mkdocs build` + file check | ❌ W0 | ⬜ pending |
| 03-01-04 | 01 | 1 | DPL-01 | — | Security headers present in netlify.toml | smoke | `grep` for header values | ❌ W0 | ⬜ pending |
| 03-02-01 | 02 | 1 | DPL-03 | — | GitHub Actions build-check runs on PRs | unit (CI) | `mkdocs build --strict` in Actions | ❌ W0 | ⬜ pending |
| 03-02-02 | 02 | 1 | DPL-03 | — | Build-check uses Python 3.12 | unit (CI) | Workflow YAML check | ❌ W0 | ⬜ pending |
| 03-03-01 | 03 | 2 | DPL-01 | — | site_url updated to Netlify subdomain | smoke | `grep site_url mkdocs.yml` | ❌ W0 | ⬜ pending |
| 03-03-02 | 03 | 2 | DPL-01 | — | Netlify site created and connected | manual | Verify deploy URL | ❌ manual | ⬜ pending |
| 03-03-03 | 03 | 2 | DPL-04 | — | Deploy preview generated for PR | manual | Open PR, verify preview | ❌ manual | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `.github/workflows/build-check.yml` — PR build verification workflow
- [ ] `netlify.toml` — Build config, redirects, security headers
- [ ] `runtime.txt` — Python 3.12 version specification
- [ ] `mkdocs.yml` site_url update — actual Netlify subdomain

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Netlify site creation and git integration | DPL-01 | Requires Netlify account and UI interaction | Create site on Netlify, connect to GitHub repo, verify first deploy |
| Production deploy on push to main | DPL-01 | Requires push to main and Netlify integration | Push to main, verify deploy appears in Netlify dashboard and site is live |
| Deploy preview on PR | DPL-04 | Requires opening a PR and Netlify integration | Open PR, verify deploy preview URL appears in PR comment |
| Security headers in browser | DPL-01 | Requires deployed site | Open site in browser, check response headers in dev tools |
| Root redirect behavior | DPL-01 | Requires deployed site | Visit `/en/some-page`, verify redirect to `/some-page` works |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 60s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending