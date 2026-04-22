# Compliance

Data residency, GDPR compliance, and audit logging for AirGap AI Chatbot deployments.

--8<-- "_snippets/standard-disclaimer.md"

## Data Residency

AirGap AI Chatbot stores all data within the deployment infrastructure by default. No data leaves the configured environment unless you explicitly enable external integrations.

!!! note "Default Behavior"

    In the default configuration, all document content, conversation history, and user data reside in the local SQLite database within the mounted data volume. No data is transmitted to external services.

### Configure Data Location

The data volume mount point determines where persistent data is stored:

```bash
docker run -d \
  -v /data/airgap:/app/data \
  ghcr.io/elia/airgap-chatbot:latest
```

To ensure data remains within a specific jurisdiction, mount the volume to storage that resides in that region.

!!! tip "Data Residency Compliance"

    For organizations with data residency requirements, deploy the entire stack (application, database, backups) within the required jurisdiction. Verify that backup processes and disaster recovery sites also comply with residency requirements.

## GDPR Compliance

AirGap AI Chatbot supports GDPR compliance through data minimization, user rights, and configurable data retention.

### Right to Access

Retrieve all data associated with a user through the API:

```bash
curl -X GET "${BASE_URL}/users/user-42/data-export" \
  -H "Authorization: Bearer ${API_KEY}"
```

This endpoint returns a complete export of the user's conversations, uploaded documents, and workspace memberships.

### Right to Erasure

Delete all data associated with a user:

```bash
curl -X DELETE "${BASE_URL}/users/user-42" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"confirm": true, "delete_documents": true}'
```

!!! warning "Irreversible Deletion"

    User deletion is permanent and cannot be undone. The `delete_documents` flag also removes documents owned by the user from all workspaces. Confirm the scope of deletion before executing this request.

### Right to Rectification

Update user profile information:

```bash
curl -X PUT "${BASE_URL}/users/user-42/profile" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Name",
    "email": "updated@example.com"
  }'
```

!!! note "Processing Records"

    AirGap AI Chatbot does not act as a data processor for third parties. As a self-hosted solution, the deploying organization is the data controller. Maintain your own record of processing activities per Article 30 of GDPR.

## Audit Logging

AirGap AI Chatbot logs administrative and security-relevant actions for compliance and forensic review.

### Audit Log Events

The system records the following event types:

| Event Type | Description |
|------------|-------------|
| `user.login` | User authentication events |
| `user.login_failed` | Failed authentication attempts |
| `user.create` | New user creation |
| `user.delete` | User deletion |
| `role.assign` | Role assignment changes |
| `role.revoke` | Role revocation |
| `api_key.create` | API key creation |
| `api_key.revoke` | API key revocation |
| `document.upload` | Document upload events |
| `document.delete` | Document deletion |
| `settings.update` | System configuration changes |

### Query Audit Logs

Retrieve audit logs through the API:

```bash
curl -X GET "${BASE_URL}/audit-logs?limit=100&offset=0" \
  -H "Authorization: Bearer ${API_KEY}"
```

Filter by event type or date range:

```bash
curl -X GET "${BASE_URL}/audit-logs?event_type=role.assign&from=2025-01-01&to=2025-01-31" \
  -H "Authorization: Bearer ${API_KEY}"
```

### Export Audit Logs

Export audit logs for long-term storage and compliance review:

```bash
curl -X GET "${BASE_URL}/audit-logs/export?format=json&from=2025-01-01" \
  -H "Authorization: Bearer ${API_KEY}" \
  -o audit-logs-2025-01.json
```

!!! tip "Log Retention"

    Configure audit log retention to meet your compliance requirements. Many regulations require a minimum of 12 months of log retention. Archive exported logs to immutable storage for tamper-proof audit trails.

## Compliance Reporting

Generate compliance reports summarizing the security posture and data handling practices of your deployment.

### System Compliance Summary

```bash
curl -X GET "${BASE_URL}/settings/compliance-summary" \
  -H "Authorization: Bearer ${API_KEY}"
```

This endpoint returns a summary of:

- Active user count and role distribution
- Data residency configuration
- TLS and encryption status
- Audit log coverage period
- API key count and expiration status

!!! tip "Regular Reviews"

    Schedule monthly compliance reviews using the compliance summary endpoint. Track changes over time to demonstrate ongoing compliance to auditors and regulators.

For security architecture and threat model details, see [Overview](overview.md).