# Querying

Query your uploaded documents using RAG (Retrieval-Augmented Generation). This guide covers asking questions, viewing sources, and refining your queries for better results.

--8<-- "_snippets/api-base-url.md"

## Ask a Question

Once documents are uploaded and processed, ask questions about their content through the chat interface or the API.

To query from the UI, open a conversation that has documents attached and type your question in the message input. The chatbot searches the document index for relevant passages before generating a response.

To query via the API:

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "What are the main security requirements listed in the policy?",
    "document_ids": ["doc_abc123"]
  }'
```

The response includes the answer and references to the source passages:

```json
{
  "id": "msg_def456",
  "role": "assistant",
  "content": "The policy lists three main security requirements: encryption at rest, access logging, and multi-factor authentication...",
  "sources": [
    {
      "document_id": "doc_abc123",
      "page": 12,
      "excerpt": "All stored data must be encrypted at rest using AES-256..."
    }
  ],
  "created_at": "2025-01-15T10:35:00Z"
}
```

!!! tip "Be specific"

    The more specific your question, the more relevant the retrieved passages will be. Instead of "tell me about security," try "what encryption standards are required for data at rest?"

## View Sources

Each response that uses document context includes source citations. These citations show which document passages were used to generate the answer.

In the UI, source citations appear as expandable sections below the response. Click a citation to view the full excerpt from the original document.

Via the API, sources are returned in the `sources` array:

```bash
curl -X GET "$BASE_URL/conversations/{conversation_id}/messages/msg_def456" \
  -H "Content-Type: application/json"
```

The `sources` field contains the document ID, page number, and excerpt for each cited passage.

!!! note "Source accuracy"

    Sources point to the exact passages used by the model. If the model could not find relevant content in the uploaded documents, it will indicate this in the response rather than fabricating sources.

## Refine Your Query

If the initial response does not fully answer your question, refine your query using these techniques:

- **Add context:** Include more details about what you are looking for
- **Specify the document:** Reference a particular document when you have multiple uploads
- **Ask follow-up questions:** Build on previous answers within the same conversation

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Can you provide more detail on the access logging requirement mentioned earlier?",
    "document_ids": ["doc_abc123"]
  }'
```

!!! tip "Conversation context"

    Follow-up questions within the same conversation retain context from previous messages. The chatbot remembers what was discussed and which documents were referenced, so you do not need to repeat information.

For document upload instructions, see [Uploading](uploading.md).