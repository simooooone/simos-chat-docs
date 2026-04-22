---
phase: 1
slug: foundation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-04-22
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Manual verification via `mkdocs serve` + `mkdocs build --strict` |
| **Config file** | mkdocs.yml (validates at build time) |
| **Quick run command** | `mkdocs build --strict && echo "OK"` |
| **Full suite command** | `mkdocs build --strict && grep -r "fonts.googleapis\|http://" site/` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `mkdocs build --strict`
- **After every plan wave:** Run `mkdocs serve` and verify all FDN-04 features render
- **Before `/gsd-verify-work`:** Full `mkdocs build --strict` + manual browser verification
- **Max feedback latency:** ~10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | FDN-02 | T-1-01 | Pin exact version ranges preventing 2.x upgrade | unit | `pip install -r requirements.txt && mkdocs --version` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | FDN-01 | T-1-03 | YAML config validates with strict build | smoke | `mkdocs build --strict && echo "OK"` | ❌ W0 | ⬜ pending |
| 01-02-01 | 02 | 1 | FDN-03 | — | Every .en.md has corresponding .it.md | unit | `diff <(find docs/ -name "*.en.md" \| sed 's/.en.md//') <(find docs/ -name "*.it.md" \| sed 's/.it.md//')` | ❌ W0 | ⬜ pending |
| 01-02-02 | 02 | 1 | FDN-03 | — | Bilingual stub files follow suffix convention | unit | `find docs/ -name "*.en.md" \| wc -l` | ❌ W0 | ⬜ pending |
| 01-03-01 | 03 | 2 | FDN-04 | — | Syntax highlighting renders in code blocks | manual | Visual check on `mkdocs serve` | N/A | ⬜ pending |
| 01-03-01 | 03 | 2 | FDN-04 | — | Admonitions render (note, warning, tip) | manual | Visual check on `mkdocs serve` | N/A | ⬜ pending |
| 01-03-01 | 03 | 2 | FDN-04 | — | Content tabs render with `===` syntax | manual | Visual check on `mkdocs serve` | N/A | ⬜ pending |
| 01-03-01 | 03 | 2 | FDN-04 | — | Code copy button appears on code blocks | manual | Visual check on `mkdocs serve` | N/A | ⬜ pending |
| 01-01-02 | 01 | 1 | D-07 | — | Plugin load order is i18n -> search -> offline/privacy | unit | `grep -A1 "plugins:" mkdocs.yml` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | D-13 | — | offline/privacy use `!ENV [OFFLINE, false]` | unit | `grep "OFFLINE" mkdocs.yml` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | D-14 | — | `navigation.instant` is NOT in features list | unit | `grep "navigation.instant" mkdocs.yml && echo "FAIL" \|\| echo "OK"` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | D-04 | — | Dark mode is default palette | manual | Visual check on `mkdocs serve` | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `requirements.txt` — pinned dependencies with version constraints (FDN-02)
- [ ] `mkdocs.yml` — complete configuration (FDN-01, FDN-03, FDN-04)
- [ ] `docs/` directory structure — bilingual stub files (FDN-03)
- [ ] No automated test framework needed — validation is `mkdocs build --strict` + manual browser check

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Dark mode is default palette | D-04 | Visual appearance check | Run `mkdocs serve`, open browser, verify dark theme loads first |
| Syntax highlighting renders | FDN-04 | Requires browser rendering | Run `mkdocs serve`, open a code block page, verify syntax colors |
| Admonitions render | FDN-04 | Requires browser rendering | Run `mkdocs serve`, open a page with note/warning/tip, verify styling |
| Content tabs render | FDN-04 | Requires browser rendering | Run `mkdocs serve`, open a page with `===` tabs, verify tab switching |
| Code copy button appears | FDN-04 | Requires browser rendering | Run `mkdocs serve`, hover over a code block, verify copy button appears |
| Language switcher works | D-03 | Requires browser rendering | Run `mkdocs serve`, click language toggle, verify stay-on-page behavior |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending