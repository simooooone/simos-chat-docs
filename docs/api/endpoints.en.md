# Endpoints

Available REST API endpoints for AirGap AI Chatbot, including request and response formats for chat, document, and workspace operations.

--8<-- "_snippets/api-base-url.md"

## Chat Endpoints

Interact with the chatbot through the chat API to send messages and retrieve conversation history.

### Send a Message

```bash
curl -X POST "${BASE_URL}/chat/messages" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "workspace_id": "ws-1",
    "message": "Summarize the quarterly report",
    "context_documents": ["doc-42"]
  }'
```

Response:

```json
{
  "id": "msg-abc123",
  "content": "The quarterly report shows a 12% increase...",
  "sources": ["doc-42"],
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! note "Context Documents"

    Include `context_documents` to restrict the chatbot response to specific uploaded documents. Without this parameter, the chatbot uses all documents in the workspace.

### List Conversations

```bash
curl -X GET "${BASE_URL}/chat/conversations?workspace_id=ws-1" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Pagination"

    Use `?limit=20&offset=0` query parameters to paginate through large result sets. The response includes a `total` count for calculating subsequent offsets.

## Document Endpoints

Upload, list, and manage documents used for retrieval-augmented generation.

### Upload a Document

```bash
curl -X POST "${BASE_URL}/documents/upload" \
  -H "Authorization: Bearer ${API_KEY}" \
  -F "file=@report.pdf" \
  -F "workspace_id=ws-1"
```

!!! note "Supported Formats"

    The API accepts PDF, TXT, DOCX, and MD files. Maximum file size is controlled by the `max_upload_size_mb` system setting.

### List Documents

```bash
curl -X GET "${BASE_URL}/documents?workspace_id=ws-1" \
  -H "Authorization: Bearer ${API_KEY}"
```

### Delete a Document

```bash
curl -X DELETE "${BASE_URL}/documents/doc-42" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Batch Operations"

    To delete multiple documents, use the `DELETE /documents/batch` endpoint with a JSON array of document IDs in the request body.

## Workspace Endpoints

Create and manage workspaces that organize conversations, documents, and team access.

### Create a Workspace

```bash
curl -X POST "${BASE_URL}/workspaces" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Marketing Team",
    "description": "Workspace for marketing documents and conversations"
  }'
```

### List Workspaces

```bash
curl -X GET "${BASE_URL}/workspaces" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Filtering"

    Use `?role=admin` to list only workspaces where you have a specific role. This is useful for finding workspaces where you have management permissions.

### Update a Workspace

```bash
curl -X PUT "${BASE_URL}/workspaces/ws-1" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Marketing Team - Updated",
    "description": "Updated description"
  }'
```