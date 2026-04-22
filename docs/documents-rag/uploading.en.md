# Uploading

Upload documents to your workspace so the chatbot can use them as context for answering questions. This guide covers supported formats, uploading via the UI, and uploading via the API.

--8<-- "_snippets/api-base-url.md"

--8<-- "_snippets/standard-disclaimer.md"

## Supported Formats

AirGap AI Chatbot processes the following document formats:

| Format | Extension | Notes |
|--------|-----------|-------|
| PDF | `.pdf` | Text extracted from PDF; scanned images are not supported |
| Plain text | `.txt` | UTF-8 encoded text files |
| Markdown | `.md` | Rendered and indexed as structured content |
| CSV | `.csv` | Tabular data indexed row by row |

!!! note "File size limit"

    The maximum upload size per document is controlled by the `AIRGAP_MAX_UPLOAD_SIZE` configuration variable (default: 50 MB). Documents exceeding this limit are rejected with an error message.

## Upload via UI

To upload a document through the chatbot interface:

1. Open a conversation in the active workspace
2. Click the **Attach** button (paperclip icon) next to the message input
3. Select a file from your local system
4. The document appears as an attachment in the input area
5. Type your question and press **Enter**

The chatbot processes the document and indexes it for retrieval. You can reference the document in follow-up questions within the same conversation.

!!! tip "Batch uploads"

    To upload multiple documents at once, use the API endpoint described below. The UI supports one document per message.

## Upload via API

Upload a document programmatically using the API:

```bash
curl -X POST "$BASE_URL/documents" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@report.pdf" \
  -F "workspace_id=ws_abc123"
```

The response includes the document ID and processing status:

```json
{
  "id": "doc_abc123",
  "filename": "report.pdf",
  "status": "processing",
  "created_at": "2025-01-15T10:30:00Z"
}
```

Check the processing status:

```bash
curl -X GET "$BASE_URL/documents/doc_abc123" \
  -H "Content-Type: application/json"
```

When the status changes to `ready`, the document is indexed and available for queries.

!!! warning "Duplicate uploads"

    Uploading the same file twice creates a new document entry. To avoid duplicates, check the document list before uploading.

!!! note "Processing time"

    Document processing time depends on file size and complexity. Most text files are processed in seconds; large PDF files may take up to a minute.

For instructions on querying uploaded documents, see [Querying](querying.md).