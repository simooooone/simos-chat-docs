# Projects

Create and manage projects within workspaces to organize conversations around specific topics or goals. This guide covers creating a project, adding conversations, and managing project members.

--8<-- "_snippets/standard-disclaimer.md"

## Create a Project

Projects group related conversations within a workspace. Use projects to organize work by topic, sprint, or deliverable.

Create a project via the UI by navigating to your workspace and clicking **New Project**, or via the API:

```bash
curl -X POST "$BASE_URL/workspaces/ws_abc123/projects" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Q1 Security Review",
    "description": "Project for the Q1 security audit and compliance review"
  }'
```

The response returns the project details:

```json
{
  "id": "proj_abc123",
  "workspace_id": "ws_abc123",
  "name": "Q1 Security Review",
  "description": "Project for the Q1 security audit and compliance review",
  "created_at": "2025-01-15T11:00:00Z",
  "conversation_count": 0
}
```

!!! tip "Project naming"

    Use clear, descriptive project names that reflect the topic or goal. This makes it easier for team members to find relevant conversations.

## Add Conversations

Add existing conversations to a project to keep related discussions organized.

Assign a conversation to a project:

```bash
curl -X POST "$BASE_URL/projects/proj_abc123/conversations" \
  -H "Content-Type: application/json" \
  -d '{
    "conversation_id": "conv_xyz789"
  }'
```

You can also start a new conversation directly within a project by selecting the project in the sidebar before typing your message.

List all conversations in a project:

```bash
curl -X GET "$BASE_URL/projects/proj_abc123/conversations" \
  -H "Content-Type: application/json"
```

Remove a conversation from a project:

```bash
curl -X DELETE "$BASE_URL/projects/proj_abc123/conversations/conv_xyz789" \
  -H "Content-Type: application/json"
```

!!! note "Conversation ownership"

    Removing a conversation from a project does not delete the conversation. It simply removes the association. The conversation remains accessible from the workspace conversation list.

## Manage Project Members

Control who can access a project by managing its member list. Project members inherit the workspace role but can be granted additional project-specific permissions.

Add a member to a project:

```bash
curl -X POST "$BASE_URL/projects/proj_abc123/members" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "usr_def456",
    "permissions": ["read", "write"]
  }'
```

List project members:

```bash
curl -X GET "$BASE_URL/projects/proj_abc123/members" \
  -H "Content-Type: application/json"
```

Remove a member from a project:

```bash
curl -X DELETE "$BASE_URL/projects/proj_abc123/members/usr_def456" \
  -H "Content-Type: application/json"
```

!!! tip "Project vs workspace members"

    All workspace members can view projects by default, but project-specific permissions control who can add conversations and manage project settings. Use project membership to restrict access to sensitive discussions.

For workspace-level management, see [Workspaces](workspaces.md).