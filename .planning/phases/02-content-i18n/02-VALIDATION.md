---
phase: 2
slug: content-i18n
status: approved
nyquist_compliant: true
wave_0_complete: false
created: 2026-04-22
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Manual verification + `mkdocs build --strict` |
| **Config file** | none — static site, no test framework |
| **Quick run command** | `mkdocs build --strict 2>&1` |
| **Full suite command** | `mkdocs build --strict 2>&1 && diff <(find docs/ -name "*.en.md" \| sed 's/.en.md//') <(find docs/ -name "*.it.md" \| sed 's/.it.md//')` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run `mkdocs build --strict 2>&1`
- **After every plan wave:** Full bilingual file-pair check + manual browser verification
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 01 | 1 | CNT-04 | — | N/A | unit | `grep -c "custom_dir" mkdocs.yml` | ✅ W0 | ⬜ pending |
| 02-01-02 | 01 | 1 | CNT-04 | — | N/A | unit | `grep -c "nav_translations" mkdocs.yml` | ✅ W0 | ⬜ pending |
| 02-01-03 | 01 | 1 | CNT-02 | — | N/A | unit | `test -f docs/overrides/main.html` | ✅ W0 | ⬜ pending |
| 02-02-01 | 02 | 1 | CNT-01 | — | N/A | unit | `diff <(find docs/ -name "*.en.md" \| sed 's/.en.md//') <(find docs/ -name "*.it.md" \| sed 's/.it.md//')` | ❌ W0 | ⬜ pending |
| 02-03-01 | 03 | 2 | CNT-01 | — | N/A | unit | `wc -l docs/index.en.md` (must be > 5) | ✅ W0 | ⬜ pending |
| 02-03-02 | 03 | 2 | CNT-05 | — | N/A | manual | Compare English and Italian versions side-by-side in browser | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `scripts/check-bilingual-pairs.sh` — automated script to verify every .en.md has a matching .it.md
- [ ] `docs/overrides/main.html` — announce bar template (created in Plan 01)
- [ ] `docs/_snippets/` — shared English snippets directory (created in Plan 02)
- [ ] `docs/_snippets.it/` — shared Italian snippets directory (created in Plan 02)

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Language switcher stays on same page | CNT-02 | Browser interaction required | Switch language on /setup/installation/, verify you land on /it/setup/installation/ |
| Search works with Italian stemming | CNT-03 | Interactive search required | Search "installazione" on Italian page, verify Italian results appear |
| Nav labels display in Italian | CNT-04 | Visual inspection required | View Italian page, check sidebar/breadcrumb labels are Italian |
| Admonitions, tabs, code copy identical in both languages | CNT-05 | Visual comparison required | Compare English and Italian versions of same page side-by-side |
| Announce bar displays bilingual content | D-07 | Visual inspection required | Check announce bar shows Italian text on Italian pages |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending