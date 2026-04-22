# RBAC

Role-Based Access Control lets you manage user permissions by assigning roles with predefined capabilities. This guide covers creating roles, assigning permissions, and managing users in AirGap AI Chatbot.

--8<-- "_snippets/standard-disclaimer.md"

## Understand Roles

AirGap AI Chatbot uses a role-based permission model. Each role defines a set of permissions that determine what actions a user can perform.

!!! note "Default Roles"

    The system provides three built-in roles:

    - **Admin** — Full access to all features, including user management and system configuration
    - **Editor** — Can create and modify workspaces, projects, and documents, but cannot manage users
    - **Viewer** — Read-only access to workspaces and documents assigned to their teams

Roles are assigned per workspace. A user can hold different roles in different workspaces.

## Create a Role

Use the roles API to create a custom role with specific permissions.

```bash
curl -X POST "${BASE_URL}/roles" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "data-analyst",
    "permissions": [
      "documents:read",
      "documents:query",
      "workspaces:read"
    ]
  }'
```

!!! danger "Overwrite Risk"

    Creating a role with a name that already exists overwrites the existing role and its permissions. List roles first to avoid accidental overwrites.

## Assign Permissions

Permissions control access to specific resources and actions. Assign them to roles rather than to individual users.

```bash
curl -X PUT "${BASE_URL}/roles/data-analyst/permissions" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "permissions": [
      "documents:read",
      "documents:query",
      "documents:upload",
      "workspaces:read"
    ]
  }'
```

!!! warning "Permission Cascading"

    Assigning a parent permission automatically grants all child permissions. For example, `documents:write` includes `documents:upload` and `documents:delete`. Review the permission hierarchy before assigning parent-level permissions.

Available permission categories:

| Category | Permissions |
|----------|------------|
| `documents` | `read`, `upload`, `query`, `write`, `delete` |
| `workspaces` | `read`, `create`, `update`, `delete`, `manage` |
| `projects` | `read`, `create`, `update`, `delete` |
| `users` | `read`, `create`, `update`, `delete` |
| `settings` | `read`, `update` |

## Manage Users

Assign roles to users through the workspace membership API.

```bash
curl -X POST "${BASE_URL}/workspaces/ws-1/members" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user-42",
    "role": "data-analyst"
  }'
```

!!! note "User Management"

    Users must be added to a workspace before they can access any resources within it. The Admin role can manage members across all workspaces.

To remove a user from a workspace:

```bash
curl -X DELETE "${BASE_URL}/workspaces/ws-1/members/user-42" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! danger "Revocation Immediate"

    Removing a user from a workspace immediately revokes access to all resources within that workspace, including active sessions and API tokens scoped to that workspace.