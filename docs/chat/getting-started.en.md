# Getting Started

Start your first conversation with AirGap AI Chatbot. This guide covers accessing the interface, sending a message, and uploading a document for context.

--8<-- "_snippets/prereq-docker.md"

## Access the Interface

Open your browser and navigate to the chatbot interface:

```
http://localhost:3000
```

If you changed the port during [Installation](../setup/installation.md), adjust the URL accordingly. For example, if you mapped port `8080`, navigate to `http://localhost:8080`.

Verify the service is responding with a health check:

```bash
curl -s http://localhost:3000/api/health
```

A successful response returns a JSON object with status information.

!!! tip "Bookmark the page"

    Save the chatbot URL as a browser bookmark for quick access. The interface remembers your recent conversations within the same browser session.

## Start a Conversation

Once the interface loads, the chat panel appears with a message input at the bottom.

Type a message in the input field and press **Enter** or click the send button:

```
Hello, what can you help me with?
```

The chatbot responds in real time. Each conversation is automatically saved and appears in the sidebar under a generated title.

!!! note "Conversation titles"

    Titles are generated automatically from the first message. You can rename a conversation by clicking the title in the sidebar and editing the text.

To start a new conversation, click the **New Conversation** button in the sidebar. The current conversation remains accessible from the sidebar history.

## Upload a Document

To ask questions about your own documents, upload them into the chat context.

1. Click the **Attach** button (paperclip icon) next to the message input
2. Select a file from your local system
3. The document appears as an attachment in the input area
4. Type your question and press **Enter**

The chatbot processes the document and uses it as context for your question. Supported formats include PDF, plain text, Markdown, and CSV.

!!! note "Document size"

    Each document has a maximum size limit defined by the `AIRGAP_MAX_UPLOAD_SIZE` configuration variable (default: 50 MB). See [Configuration](../setup/configuration.md) for details.

For more information about working with documents, see [Uploading](../documents-rag/uploading.md) and [Querying](../documents-rag/querying.md).