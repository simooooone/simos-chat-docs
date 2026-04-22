# CLAUDE.md — AirGap AI Chatbot Documentation Portal

## Project

Bilingual (en/it) MkDocs Material documentation portal for the AirGap AI Chatbot. Dual distribution: Netlify online + air-gapped offline ZIP.

## GSD Workflow

This project uses the Get Shit Done (GSD) methodology. Planning artifacts are in `.planning/`.

- **Roadmap**: `.planning/ROADMAP.md` — 4 phases (Foundation → Content/i18n → Online Deploy → Offline Dist)
- **State**: `.planning/STATE.md` — current position, decisions, blockers
- **Requirements**: `.planning/REQUIREMENTS.md` — 17 v1 requirements with REQ-IDs
- **Config**: `.planning/config.json` — workflow preferences

### Key Commands

- `/gsd-plan-phase N` — Plan a phase
- `/gsd-execute-phase` — Execute the current plan
- `/gsd-verify-work` — Verify completed work
- `/gsd-progress` — View overall progress

## Technical Constraints

- **MkDocs version**: Must pin `>=1.6,<2.0` — MkDocs 2.0 is incompatible with Material theme
- **i18n plugin**: Use `mkdocs-static-i18n` (NOT `mkdocs-i18n`)
- **Offline builds**: Use `!ENV [OFFLINE, false]` conditionals on privacy/offline plugins (NOT Insiders-only `group` plugin)
- **navigation.instant**: Do NOT enable — Fetch API fails on file:// protocol
- **File naming**: Bilingual content uses `.en.md`/`.it.md` suffix convention

## Build Commands

- `mkdocs serve` — Local development server
- `mkdocs build` — Build online version (default)
- `BUILD=offline mkdocs build` — Build offline/air-gapped version
- `./build-offline.sh` — Build offline + ZIP packaging

## Structure

```
docs/
  index.en.md          # English homepage
  index.it.md          # Italian homepage
  guides/
    getting-started.en.md
    getting-started.it.md
  api/
    endpoints.en.md
    endpoints.it.md
mkdocs.yml             # Single config for both build modes
requirements.txt       # Python dependencies (pinned)
netlify.toml           # Netlify deployment config
runtime.txt            # Python version for Netlify
build-offline.sh       # Offline build + ZIP script
```