# Phase 1: Foundation - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-22
**Phase:** 01-foundation
**Areas discussed:** Nav structure & sections, Theme & appearance, Plugin config & features, Placeholder content style

---

## Nav structure & sections

| Option | Description | Selected |
|--------|-------------|----------|
| Audience-based | Sections organized by user persona (user, admin, developer) | |
| Learning-path-based | Sections organized by learning path (what to read first) | |
| Feature-area-based | Sections organized by product area (what feature are you using?) | ✓ |

**User's choice:** Feature-area-based
**Notes:** 8 top-level sections, 2-3 levels deep. Matches how chatbot users look up information by feature.

---

## Theme & appearance

| Option | Description | Selected |
|--------|-------------|----------|
| Default Material palette | Blue/teal, no brand customization | |
| Dark-first with toggle | Dark mode default, light mode toggle | ✓ |
| Custom brand colors | Match chatbot brand colors (requires hex values) | |

**User's choice:** Dark-first with toggle

| Option | Description | Selected |
|--------|-------------|----------|
| Title only, no logo | Just the site title in header | |
| Text/SVG logo | Logo in header, asset provided later | ✓ |

**User's choice:** Text/SVG logo (asset to be provided later)

---

## Plugin config & features

| Option | Description | Selected |
|--------|-------------|----------|
| Explicit plugin order | Define i18n -> search -> offline/privacy order in mkdocs.yml | ✓ |
| Default order, fix later | Let plugins load in default order | |

**User's choice:** Explicit order (addresses PIT-13)

| Option | Description | Selected |
|--------|-------------|----------|
| Separate per-language indexes | en + it with Italian stemming, reconfigure_search: true | ✓ |
| Mixed single index | Both languages in one index | |

**User's choice:** Separate indexes (addresses CNT-03 requirement)

**Extra features selected (all four):**
- Print-to-PDF support
- Announcement bar
- TOC sidebar
- Footer navigation

---

## Placeholder content style

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal stubs | Title + one-liner + "coming soon" note | ✓ |
| Rich template stubs | Full heading structure with sample admonitions, code blocks | |
| Claude's discretion | Just ensure bilingual pairing is clear | |

**User's choice:** Minimal stubs

---

## Claude's Discretion

- Exact nav section labels and ordering
- Specific heading structure within minimal stubs
- Exact dark palette colors (Material defaults)
- Plugin version pins beyond requirements

## Deferred Ideas

None — discussion stayed within phase scope