# Settings

Configure AirGap AI Chatbot system settings, manage API keys, and perform routine maintenance tasks.

--8<-- "_snippets/standard-disclaimer.md"

## Access Settings

Open the Settings page from the Administration section in the navigation sidebar. Only users with the Admin role or `settings:read` permission can view system settings.

```bash
curl -X GET "${BASE_URL}/settings" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Quick Access"

    Append `/settings` to your workspace URL to go directly to the settings page.

## General Configuration

System-wide settings control the behavior of AirGap AI Chatbot across all workspaces.

```bash
curl -X PUT "${BASE_URL}/settings/general" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "default_language": "en",
    "max_upload_size_mb": 100,
    "session_timeout_minutes": 60,
    "enable_registration": true
  }'
```

!!! warning "Restart Required"

    Some general configuration changes require a service restart to take effect. The API response includes a `restart_required` flag when applicable.

Available general settings:

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `default_language` | string | `en` | Default UI language for new users |
| `max_upload_size_mb` | integer | `100` | Maximum document upload size in megabytes |
| `session_timeout_minutes` | integer | `60` | Session timeout duration in minutes |
| `enable_registration` | boolean | `true` | Allow new user self-registration |

## API Keys

API keys authenticate external applications and scripts. Each key can be scoped to specific workspaces and permissions.

### Generate an API Key

```bash
curl -X POST "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ci-pipeline",
    "permissions": ["documents:read", "documents:upload"],
    "workspace_scope": "ws-1"
  }'
```

The response returns the key value once. Store it securely because it cannot be retrieved later.

```json
{
  "id": "key-abc123",
  "name": "ci-pipeline",
  "key": "agc_live_9a8b7c6d5e4f3a2b1c0d",
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! tip "Naming Convention"

    Use descriptive names for API keys that indicate their purpose and environment, such as `ci-pipeline-production` or `analytics-dashboard-staging`.

### Manage API Keys

List all API keys for the current workspace:

```bash
curl -X GET "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}"
```

Revoke a specific key when it is no longer needed:

```bash
curl -X DELETE "${BASE_URL}/settings/api-keys/key-abc123" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! warning "Immediate Effect"

    Revoking an API key takes effect immediately. Any applications using the key will receive authentication errors.

## System Maintenance

### View System Status

```bash
curl -X GET "${BASE_URL}/settings/status" \
  -H "Authorization: Bearer ${API_KEY}"
```

The status endpoint returns system health information, including storage usage, active sessions, and service uptime.

### Clear Caches

```bash
curl -X POST "${BASE_URL}/settings/maintenance/clear-cache" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! warning "Performance Impact"

    Clearing caches causes temporary slowdowns while the system rebuilds query caches. Schedule maintenance operations during low-traffic periods.