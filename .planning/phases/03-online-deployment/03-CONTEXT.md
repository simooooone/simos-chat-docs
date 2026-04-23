# Phase 3: Online Deployment - Context

**Gathered:** 2026-04-23
**Status:** Ready for planning

<domain>
## Phase Boundary

Deploy the documentation site to Netlify with CI/CD: automatic production deploys on push to main, deploy previews for pull requests, and a GitHub Actions build-check workflow for PRs. Configure netlify.toml with build settings, redirects, and security headers.

This phase delivers the online deployment pipeline — not the content (Phase 2, done), not the offline build (Phase 4).

</domain>

<decisions>
## Implementation Decisions

### CI/CD pipeline design
- **D-01:** Netlify native git integration for production deploys — Netlify connects directly to the GitHub repo, builds on push to main. No GitHub Actions workflow for production deploys.
- **D-02:** Push to main triggers production deploys only. No tag-based or release-based deploys for v1.
- **D-03:** GitHub Actions workflow for build verification on PRs — a lightweight check that `mkdocs build` succeeds, separate from Netlify's deploy preview. Catches build errors before merge.

### Branch previews & PR workflow
- **D-04:** Public deploy previews — anyone with the preview URL can view PR deployments. Appropriate for public documentation.
- **D-05:** Netlify PR bot comments — automatic comments on each PR with the deploy preview URL and status. Zero additional config needed.
- **D-06:** Auto-cleanup on PR close — Netlify automatically removes deploy previews when a PR is closed or merged. No custom retention policy.

### Netlify configuration
- **D-07:** Python version specified via `runtime.txt` file (not netlify.toml env var). Netlify reads this automatically. Maps directly to DPL-02 requirement.
- **D-08:** Root URL redirect `/` → `/en/` via netlify.toml redirect rule. Explicit, predictable, matches i18n suffix convention.
- **D-09:** Standard security headers in netlify.toml: X-Frame-Options, X-Content-Type-Options, Referrer-Policy, and basic Content-Security-Policy. Best practice for any production site.

### Domain & URL structure
- **D-10:** Netlify subdomain for v1 (e.g., docs-airgap-chatbot.netlify.app). Zero DNS configuration, instant setup. Custom domain can be added later.
- **D-11:** Language paths: English at `/en/`, Italian at `/it/`. Standard suffix-based i18n pattern matching mkdocs-static-i18n defaults. Root `/` redirects to `/en/` per D-08.
- **D-12:** Netlify automatic HTTPS via Let's Encrypt. Zero certificate management.

### Claude's Discretion
- Exact Netlify site name/subdomain (as long as it's descriptive)
- Specific GitHub Actions workflow file name and job structure (as long as it runs `mkdocs build`)
- Exact security header values (as long as they follow current best practices)
- netlify.toml build command and publish directory (must be `mkdocs build` and `site/`)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project requirements
- `.planning/REQUIREMENTS.md` — 17 v1 requirements; Phase 3 covers DPL-01 through DPL-04
- `.planning/PROJECT.md` — Project vision, constraints, key decisions table
- `.planning/ROADMAP.md` — Phase 3 goal, success criteria, dependencies

### Prior phase context
- `.planning/phases/01-foundation/01-CONTEXT.md` — Phase 1 decisions (nav structure, i18n config, plugin order, suffix convention)
- `.planning/phases/02-content-i18n/02-CONTEXT.md` — Phase 2 decisions (content style, translation approach, snippet patterns)

### Technical constraints
- `CLAUDE.md` — MkDocs >=1.6,<2.0, mkdocs-static-i18n (not mkdocs-i18n), !ENV conditionals, no navigation.instant
- `mkdocs.yml` — Current configuration with i18n plugin, search, nav structure, extensions
- `requirements.txt` — Pinned Python dependencies for both local dev and Netlify build

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `mkdocs.yml` — Fully configured with i18n plugin, search, nav structure, extensions. Netlify will run `mkdocs build` against this config.
- `requirements.txt` — Pinned dependencies already defined. Netlify will install from this file.
- `docs/overrides/main.html` — Custom template override for announce bar (Phase 2 bilingual content).

### Established Patterns
- `!ENV [OFFLINE, false]` conditionals for offline/privacy plugins — online build omits these naturally
- `.en.md`/`.it.md` suffix convention for bilingual content — mkdocs-static-i18n builds `/en/` and `/it/` paths from these
- `nav_translations` in mkdocs.yml — Italian labels already defined for all sections and child pages

### Integration Points
- `netlify.toml` — New file at project root (Phase 3 creates this)
- `runtime.txt` — New file at project root (Phase 3 creates this)
- `.github/workflows/` — New directory with build-check workflow (Phase 3 creates this)
- `mkdocs.yml` → `site_url` — Currently placeholder `https://docs.airgap-chatbot.example.com/`, needs updating to actual Netlify subdomain

</code_context>

<specifics>
## Specific Ideas

- Netlify native git integration is simpler and sufficient for a docs site — no need for GitHub Actions to control production deploys
- The build-check Action on PRs provides a merge gate: PRs that break `mkdocs build` get a failing status check, preventing accidental broken deploys
- `/en/` and `/it/` paths with root redirect is the standard pattern for bilingual MkDocs sites using the suffix convention

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-online-deployment*
*Context gathered: 2026-04-23*