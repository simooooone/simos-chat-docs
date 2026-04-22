# Features

Explore the chat features of AirGap AI Chatbot. This page covers conversations, document context, and workspace integration.

--8<-- "_snippets/api-base-url.md"

## Conversations

Conversations are the core interaction model. Each conversation is an independent thread of messages between you and the chatbot.

Create a conversation through the UI by clicking **New Conversation**, or via the API:

```bash
curl -X POST "$BASE_URL/conversations" \
  -H "Content-Type: application/json" \
  -d '{"title": "Project planning discussion"}'
```

Send a message within a conversation:

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{"content": "What are the key phases of a software project?"}'
```

The response includes the assistant's reply along with metadata:

```json
{
  "id": "msg_abc123",
  "role": "assistant",
  "content": "Key phases typically include planning, design, implementation...",
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! note "Conversation history"

    All messages are stored persistently. You can retrieve previous conversations from the sidebar at any time. Conversation history is scoped to the active workspace.

## Document Context

Upload documents to provide the chatbot with domain-specific knowledge. When a document is attached to a conversation, the chatbot uses it as context for answering questions.

Attach a document when sending a message:

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Summarize the key findings in this report",
    "document_ids": ["doc_abc123"]
  }'
```

The chatbot retrieves relevant passages from the uploaded document and incorporates them into its response. Source citations appear alongside the answer.

!!! note "Retrieval-Augmented Generation"

    Document context uses RAG (Retrieval-Augmented Generation) to find the most relevant passages before generating a response. This ensures answers are grounded in your actual documents rather than general knowledge.

For detailed instructions on uploading and querying documents, see [Uploading](../documents-rag/uploading.md) and [Querying](../documents-rag/querying.md).

## Workspace Integration

Conversations and documents are organized within workspaces. Each workspace provides an isolated environment with its own set of conversations, uploaded documents, and team members.

List your workspaces:

```bash
curl -X GET "$BASE_URL/workspaces" \
  -H "Content-Type: application/json"
```

Switch the active workspace in the UI by selecting it from the workspace dropdown in the sidebar. The chatbot's context, documents, and conversation history change based on the active workspace.

!!! note "Workspace scope"

    Documents uploaded in one workspace are not visible in another. This ensures data isolation between teams and projects.

To learn more about managing workspaces, see [Workspaces](../workspaces-projects/workspaces.md).