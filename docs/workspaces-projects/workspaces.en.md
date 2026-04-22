# Workspaces

Create and manage workspaces to organize your team's conversations and documents. This guide covers creating a workspace, configuring settings, and sharing access with team members.

--8<-- "_snippets/standard-disclaimer.md"

## Create a Workspace

Workspaces provide isolated environments for organizing conversations, documents, and team members. Each workspace has its own document library and conversation history.

Create a workspace via the UI by clicking **New Workspace** in the sidebar, or via the API:

```bash
curl -X POST "$BASE_URL/workspaces" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Engineering Team",
    "description": "Workspace for engineering discussions and documentation"
  }'
```

The response returns the workspace details:

```json
{
  "id": "ws_abc123",
  "name": "Engineering Team",
  "description": "Workspace for engineering discussions and documentation",
  "created_at": "2025-01-15T10:00:00Z",
  "members": [
    {
      "user_id": "usr_xyz789",
      "role": "owner"
    }
  ]
}
```

!!! note "Workspace isolation"

    Documents and conversations in one workspace are not visible in other workspaces. This ensures data isolation between teams and projects.

## Configure Workspace Settings

After creating a workspace, adjust its settings to match your team's needs.

Update a workspace configuration:

```bash
curl -X PATCH "$BASE_URL/workspaces/ws_abc123" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Engineering Team - Updated",
    "description": "Workspace for all engineering activities",
    "settings": {
      "max_members": 25,
      "default_model": "code-optimized"
    }
  }'
```

Retrieve the current workspace settings:

```bash
curl -X GET "$BASE_URL/workspaces/ws_abc123" \
  -H "Content-Type: application/json"
```

!!! warning "Owner permissions"

    Only workspace owners can change workspace settings. Members with the `admin` or `member` role cannot modify settings such as the default model or member limits.

## Share a Workspace

Invite team members to a workspace by adding them with a specific role.

Add a member to a workspace:

```bash
curl -X POST "$BASE_URL/workspaces/ws_abc123/members" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "usr_def456",
    "role": "member"
  }'
```

Available roles:

| Role | Description |
|------|-------------|
| `owner` | Full control: settings, members, and data |
| `admin` | Manage members and conversations; cannot change settings |
| `member` | Participate in conversations and upload documents |

!!! warning "Role changes"

    Changing a member's role to a lower privilege level takes effect immediately. The affected user loses access to restricted features right away.

Remove a member from a workspace:

```bash
curl -X DELETE "$BASE_URL/workspaces/ws_abc123/members/usr_def456" \
  -H "Content-Type: application/json"
```

For organizing work within a workspace, see [Projects](projects.md).