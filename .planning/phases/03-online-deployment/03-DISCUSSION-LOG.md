# Phase 3: Online Deployment - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-23
**Phase:** 03-online-deployment
**Areas discussed:** CI/CD pipeline design, Branch previews & PR workflow, Netlify configuration, Domain & URL structure

---

## CI/CD Pipeline Design

| Option | Description | Selected |
|--------|-------------|----------|
| Netlify native git integration | Netlify connects to GitHub repo directly — builds on push automatically. Zero workflow files. | ✓ |
| GitHub Actions → Netlify CLI deploy | GitHub Actions workflow controls build then deploys via CLI/API. Full control but more config. | |
| Hybrid: Netlify native + Actions for PRs | Netlify for production, Actions for PR previews and status checks. | |

**User's choice:** Netlify native git integration
**Notes:** Simpler setup for a docs site. Production deploys are handled entirely by Netlify's built-in git integration.

| Option | Description | Selected |
|--------|-------------|----------|
| Push to main only | Only main branch triggers production deploys. PRs get previews. | ✓ |
| Push to main + tagged releases | Both main pushes and version tags trigger deploys. | |

**User's choice:** Push to main only
**Notes:** No tag-based deploys for v1. Simplicity preferred.

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — build check Action on PRs | Lightweight GitHub Actions workflow runs `mkdocs build` on PRs for pass/fail status. | ✓ |
| No — fully Netlify-native | No GitHub Actions at all. Relies on Netlify's built-in PR integration. | |

**User's choice:** Yes — build check Action on PRs
**Notes:** Provides a merge gate. PRs that break the build get a failing check before they can merge.

---

## Branch Previews & PR Workflow

| Option | Description | Selected |
|--------|-------------|----------|
| Public deploy previews | Anyone with the preview URL can view PR deployments. | ✓ |
| Password-protected previews | Require Netlify Identity login to view previews. | |

**User's choice:** Public deploy previews
**Notes:** Documentation is public — visibility is a feature, not a risk.

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — Netlify PR bot comments | Automatic comments on each PR with preview URL and deploy status. | ✓ |
| No — manual review only | Reviewers check Netlify dashboard directly. | |

**User's choice:** Yes — Netlify PR bot comments
**Notes:** Standard behavior, zero additional config. Makes previews discoverable.

| Option | Description | Selected |
|--------|-------------|----------|
| Auto-cleanup on PR close | Netlify removes previews when PRs are closed/merged. | ✓ |
| Keep for N days after PR close | Retain previews for a configurable period. | |

**User's choice:** Auto-cleanup on PR close
**Notes:** Default Netlify behavior. No custom retention policy needed.

---

## Netlify Configuration

| Option | Description | Selected |
|--------|-------------|----------|
| runtime.txt file | Netlify reads runtime.txt automatically for Python version. Standard MkDocs approach. | ✓ |
| netlify.toml env var | Set PYTHON_VERSION in netlify.toml [build.environment]. More explicit but duplicates runtime.txt. | |

**User's choice:** runtime.txt file
**Notes:** Maps directly to DPL-02 requirement. One well-known place for Python version.

| Option | Description | Selected |
|--------|-------------|----------|
| / → /en/ redirect | Explicit redirect from root to English default. Predictable, matches suffix convention. | ✓ |
| Let i18n plugin handle root routing | No redirect — i18n plugin serves default locale at root. Less explicit control. | |

**User's choice:** / → /en/ redirect
**Notes:** Clean, predictable URL structure. Root always redirects to English.

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — standard security headers | X-Frame-Options, X-Content-Type-Options, Referrer-Policy, basic CSP. Best practice. | ✓ |
| No — Netlify defaults only | Skip custom headers. Fine for internal docs, less protection. | |

**User's choice:** Yes — standard security headers
**Notes:** Standard best practice for any production site. Minimal maintenance overhead.

---

## Domain & URL Structure

| Option | Description | Selected |
|--------|-------------|----------|
| Netlify subdomain | e.g., docs-airgap-chatbot.netlify.app. Zero DNS config. Custom domain addable later. | ✓ |
| Custom domain | e.g., docs.airgap-chatbot.com. Requires DNS + SSL setup. | |

**User's choice:** Netlify subdomain
**Notes:** Instant setup for v1. Custom domain can be added later without rebuild.

| Option | Description | Selected |
|--------|-------------|----------|
| /en/ and /it/ paths | Both languages at their own paths. Standard suffix-based i18n. Root redirects to /en/. | ✓ |
| English at root, Italian at /it/ | English at / with Italian at /it/. Breaks symmetry, complex redirect logic. | |

**User's choice:** /en/ and /it/ paths
**Notes:** Matches mkdocs-static-i18n suffix convention. Symmetric and predictable.

| Option | Description | Selected |
|--------|-------------|----------|
| Netlify automatic HTTPS | Let's Encrypt, auto-renewing, zero config. | ✓ |
| Custom certificate setup | Bring your own cert or DNS-01 challenge. | |

**User's choice:** Netlify automatic HTTPS
**Notes:** Default for Netlify sites. No certificate management needed.

---

## Claude's Discretion

- Exact Netlify site name/subdomain
- Specific GitHub Actions workflow file name and job structure
- Exact security header values
- netlify.toml build command and publish directory specifics

## Deferred Ideas

None — discussion stayed within phase scope