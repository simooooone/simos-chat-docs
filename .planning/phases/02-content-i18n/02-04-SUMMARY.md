---
phase: 02-content-i18n
plan: 04
status: complete
started: 2026-04-22
completed: 2026-04-22
---

## Plan 02-04: Write Procedural Content for 8 Child Page Pairs

### What was built

Wrote complete procedural content for 16 documentation files (8 English + 8 Italian) across four sections: Administration, API, Deployment, and Security.

### Changes made

1. **Administration/RBAC (en/it)** -- Role-based access control guide with API examples for role CRUD, permission assignment, and user management. Uses `!!! danger` for destructive actions, `!!! warning` for cascading permissions, `!!! note` for role explanations. Includes `standard-disclaimer` snippet.

2. **Administration/Settings (en/it)** -- System configuration and API key management. Sections for Access Settings, General Configuration, API Keys, System Maintenance. Uses `!!! warning` for sensitive settings, `!!! tip` for best practices. Includes `standard-disclaimer` snippet.

3. **API/Endpoints (en/it)** -- REST API endpoint reference covering Chat, Document, and Workspace endpoints. Curl examples for each endpoint group. Uses `!!! note` for explanations, `!!! tip` for pagination and filtering. Includes `api-base-url` snippet.

4. **API/Authentication (en/it)** -- API key lifecycle management. Sections for Generate Key, Authenticate Requests, Token Lifecycle, Revoke Key. Uses `!!! danger` for key exposure warnings, `!!! warning` for token expiration. Includes `api-base-url` snippet.

5. **Deployment/Docker (en/it)** -- Most detailed procedural page. Full `docker run` with flags, `docker-compose.yml` example, environment variable table, TLS configuration, health checks. Includes `prereq-docker` snippet.

6. **Deployment/Air-Gap Setup (en/it)** -- Offline deployment guide. Sections for asset preparation, transfer methods (physical media + network), offline installation, configuration, and verification. Uses `!!! danger` for media sanitization and network dependencies. Includes `standard-disclaimer` snippet. Cross-links to Compliance page via `.md` extension.

7. **Security/Overview (en/it)** -- Descriptive overview of security architecture, data handling, threat model, and network security. Trust boundaries table, attack vectors list. Uses `!!! note` for architecture explanations, `!!! warning` for shared infrastructure. Cross-links to Docker and Compliance pages via `.md` extension.

8. **Security/Compliance (en/it)** -- Data residency, GDPR rights (access, erasure, rectification), audit logging with event type table and API examples, compliance reporting. Uses `!!! warning` for irreversible actions, `!!! tip` for retention and review practices. Cross-links to Overview page via `.md` extension.

### Verification

- All 16 files have substantial content (97-187 lines each, well above 20-25 line minimums)
- No content tabs (`===`) found in any page
- Snippet includes use correct paths (`_snippets/` for EN, `_snippets.it/` for IT)
- Admonitions use only standard set (note, warning, tip, danger)
- Internal links use `.md` extension per PIT-06
- Italian pages mirror English structure exactly per D-05
- Technical terms stay in English per D-06
- Docker page is the most detailed procedural guide as specified

### key-files

created:
  - docs/administration/rbac.en.md (101 lines)
  - docs/administration/rbac.it.md (101 lines)
  - docs/administration/settings.en.md (120 lines)
  - docs/administration/settings.it.md (120 lines)
  - docs/api/endpoints.en.md (121 lines)
  - docs/api/endpoints.it.md (121 lines)
  - docs/api/authentication.en.md (105 lines)
  - docs/api/authentication.it.md (105 lines)
  - docs/deployment/docker.en.md (187 lines)
  - docs/deployment/docker.it.md (187 lines)
  - docs/deployment/air-gap.en.md (169 lines)
  - docs/deployment/air-gap.it.md (169 lines)
  - docs/security/overview.en.md (97 lines)
  - docs/security/overview.it.md (97 lines)
  - docs/security/compliance.en.md (153 lines)
  - docs/security/compliance.it.md (153 lines)

### deviations

None -- all changes matched the plan exactly.

### Pending Actions

The following git operations need to be performed manually:
1. `git add docs/deployment/ docs/security/ docs/administration/ docs/api/`
2. `git commit -m "feat(02-04): write Deployment and Security child pages"`
3. `mkdocs build --strict` -- verify build passes
4. `bash scripts/check-bilingual-pairs.sh` -- verify all pairs complete

Note: Task 1 (Administration and API child pages) was already committed as c29f7ad.
Task 2 files are staged but awaiting commit due to a Bash permission issue.