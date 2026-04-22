# Phase 2: Content & i18n - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-22
**Phase:** 02-content-i18n
**Areas discussed:** Content depth & style, Translation approach, Announce bar & index pages, Content patterns & reuse

---

## Content depth & style

| Option | Description | Selected |
|--------|-------------|----------|
| Concise reference | 1-2 paragraphs per page, key facts only | |
| Procedural guides | Step-by-step procedures with code examples and screenshots where needed | ✓ |
| Comprehensive deep-dives | Detailed explanations with context, rationale, multiple examples | |

**User's choice:** Procedural guides
**Notes:** Each page covers one task end-to-end. Thorough enough to be useful, not so deep it becomes a book.

### Code examples

| Option | Description | Selected |
|--------|-------------|----------|
| Inline code blocks | Show API calls, CLI commands, config snippets inline. Users copy-paste and adapt. | ✓ |
| Tabbed alternatives | Use content tabs to show multiple approaches. More complete but doubles translation burden. | |

**User's choice:** Inline code blocks
**Notes:** One approach per code snippet. Halves translation burden compared to tabbed alternatives.

## Translation approach

| Option | Description | Selected |
|--------|-------------|----------|
| Strict structural mirror | Italian pages mirror English exactly — same headings, sections, order | ✓ |
| Natural Italian phrasing | Italian pages can rephrase headings or split/merge sections for natural flow | |

**User's choice:** Strict structural mirror
**Notes:** Only grammar-driven differences allowed. Makes parity easy to verify.

### Technical terms

| Option | Description | Selected |
|--------|-------------|----------|
| Keep tech terms in English | API, Docker, RBAC, RAG stay untranslated in Italian | ✓ |
| Hybrid — translate where natural | Translate common terms, keep acronyms in English | |

**User's choice:** Keep tech terms in English
**Notes:** Standard practice in Italian tech docs. Readers expect these terms in English.

## Announce bar & index pages

### Announce bar

| Option | Description | Selected |
|--------|-------------|----------|
| Bilingual version notice | Show version/status with link to getting-started page, in both languages | ✓ |
| Simple site name only | Minimal "AirGap AI Chatbot Docs" with no version or link | |
| Disable announce bar | Remove it for v1, add later when there are announcements | |

**User's choice:** Bilingual version notice
**Notes:** English: "v1 Documentation — Getting started with AirGap AI Chatbot". Italian: "Documentazione v1 — Inizia con AirGap AI Chatbot".

### Section index pages

| Option | Description | Selected |
|--------|-------------|----------|
| Introductory landing pages | 2-3 paragraphs introducing the topic + links to child pages | ✓ |
| Simple link listings | Just list child pages as links, minimal content | |

**User's choice:** Introductory landing pages
**Notes:** Section indexes get real introductory content, not just navigation.

## Content patterns & reuse

### Admonitions

| Option | Description | Selected |
|--------|-------------|----------|
| Standardized set of types | Consistent use of note, warning, tip, danger across all pages | ✓ |
| Freeform per page | Each page uses whatever fits. Flexible but inconsistent. | |

**User's choice:** Standardized set of admonition types
**Notes:** note for info, warning for cautions, tip for recommendations, danger for destructive actions.

### Snippets

| Option | Description | Selected |
|--------|-------------|----------|
| Shared snippets for repeated content | Define once in docs/_snippets/, include via --8<-- syntax. DRY, translate once. | ✓ |
| Self-contained pages | Each page is independent. Duplicate common content. | |

**User's choice:** Shared snippets for repeated content
**Notes:** Reduces translation cost. Translate a prerequisite block once, include it in multiple pages.

---

## Claude's Discretion

- Exact wording and tone of procedural steps
- Specific code examples content
- Exact Italian translations of non-technical prose
- Snippet file organization within docs/_snippets/
- Section index page introductory content specifics

## Deferred Ideas

None — discussion stayed within phase scope