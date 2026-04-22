# AirGap AI Chatbot Docs

AirGap AI Chatbot is an enterprise-grade, self-hosted AI chat workspace with
RAG (Retrieval-Augmented Generation) capabilities, designed for air-gapped
environments where internet access is restricted or unavailable. Run it on your
own infrastructure, keep full control of your data, and query your documents
with AI-powered intelligence.

--8<-- "_snippets/prereq-docker.md"

## Quick Start

!!! tip "Get started in under a minute"

    Pull and run the AirGap AI Chatbot container with Docker:

    ```bash
    docker pull ghcr.io/elia/airgap-chatbot:latest
    docker run -d -p 3000:3000 \
      -v ./data:/app/data \
      ghcr.io/elia/airgap-chatbot:latest
    ```

    Open `http://localhost:3000` in your browser to access the chat interface.

## Features

**Self-hosted deployment** -- Deploy AirGap AI Chatbot on your own
infrastructure using Docker or bare metal. No external dependencies, no cloud
services, and no data leaves your network. Configuration is straightforward with
environment variables and Docker Compose.

**Air-gapped operation** -- Run the full application in environments with no
internet access. All models, embeddings, and document processing happen
on-premises. Updates and model upgrades can be transferred via offline
packages, keeping your deployment completely disconnected from external
networks.

**RAG-powered document intelligence** -- Upload PDFs, text files, and other
documents to your workspace, then ask questions about their content. The
retrieval-augmented generation pipeline indexes your documents and uses them as
context for AI responses, providing answers grounded in your own data.

**Workspace-based organization** -- Organize conversations, documents, and team
members into workspaces and projects. Share context across your team while
maintaining clear boundaries between projects and departments.

## Documentation Sections

- **[Setup](setup/index.md)** -- Install and configure AirGap AI Chatbot for
  your environment
- **[Chat](chat/index.md)** -- Learn the chat interface, from your first
  conversation to advanced features
- **[Documents & RAG](documents-rag/index.md)** -- Upload documents and query
  them with retrieval-augmented generation
- **[Workspaces & Projects](workspaces-projects/index.md)** -- Organize
  conversations and collaborate with your team
- **[Administration](administration/index.md)** -- Manage users, roles, and
  system settings
- **[API](api/index.md)** -- Integrate with the programmatic interface
- **[Deployment](deployment/index.md)** -- Deploy with Docker or set up an
  air-gapped installation
- **[Security](security/index.md)** -- Understand the security architecture,
  threat model, and compliance features