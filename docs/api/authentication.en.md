# Authentication

Manage API keys and authenticate requests to the AirGap AI Chatbot API. This guide covers key generation, request authentication, token lifecycle, and key revocation.

--8<-- "_snippets/api-base-url.md"

## Generate an API Key

Create an API key through the settings interface or the API. Each key is scoped to a workspace and a set of permissions.

```bash
curl -X POST "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "integration-key",
    "permissions": ["documents:read", "documents:query"],
    "workspace_scope": "ws-1"
  }'
```

Response:

```json
{
  "id": "key-xyz789",
  "name": "integration-key",
  "key": "agc_live_4d5e6f7a8b9c0d1e2f3a",
  "permissions": ["documents:read", "documents:query"],
  "workspace_scope": "ws-1",
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! danger "Store Keys Securely"

    The API key value is returned only once at creation time. It cannot be retrieved later. Store it in a secrets manager or environment variable immediately. Never commit API keys to version control.

## Authenticate Requests

Include the API key in the `Authorization` header as a Bearer token for every authenticated request.

```bash
curl -X GET "${BASE_URL}/documents?workspace_id=ws-1" \
  -H "Authorization: Bearer agc_live_4d5e6f7a8b9c0d1e2f3a"
```

!!! danger "HTTPS Only"

    Always use HTTPS when transmitting API keys. Sending credentials over plain HTTP exposes them to interception. Production deployments must enforce TLS.

### Authentication Header Format

All authenticated requests must include the following header:

```
Authorization: Bearer <your-api-key>
```

The key prefix `agc_live_` identifies the key type. Keys prefixed with `agc_test_` are test keys that interact with sandbox data only.

!!! note "Test Keys"

    Test keys (`agc_test_`) do not affect production data. Use them for integration testing and development environments.

## Token Lifecycle

API keys have a configurable lifecycle. By default, keys do not expire, but you can set an expiration date during creation.

### Create a Key with Expiration

```bash
curl -X POST "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "temporary-access",
    "permissions": ["documents:read"],
    "workspace_scope": "ws-1",
    "expires_at": "2025-12-31T23:59:59Z"
  }'
```

!!! warning "Token Expiration"

    Expired keys return a `401 Unauthorized` response. Set up monitoring to detect key expiration before it causes service disruptions. Check key expiration dates with the `GET /settings/api-keys` endpoint.

## Revoke a Key

Remove an API key when it is no longer needed or when you suspect it has been compromised.

```bash
curl -X DELETE "${BASE_URL}/settings/api-keys/key-xyz789" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! danger "Immediate Revocation"

    Key revocation takes effect immediately. All active requests using the revoked key will receive `401 Unauthorized` responses within seconds. Rotate keys proactively by creating a replacement key before revoking the old one.

To list all keys and identify which ones to revoke:

```bash
curl -X GET "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}"
```