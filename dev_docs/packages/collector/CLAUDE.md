# CLAUDE.md — Collector

Express microservice (port 3210). Document ingestion: parse, chunk, embed, store. Communicates with server via HTTP, not direct imports.

## Structure

- **Routes**: `src/routes/` — ingest endpoints (upload, query, YouTube)
- **Services**: `src/services/` — parser, chunker, embeddings, vectorStore
- **Config**: `src/config/env.ts` — collector-specific env vars

## Key Rules

### Communication with Server
- Communicates with server via HTTP APIs only. No shared imports beyond `@simos-chat/shared`.
- Document upload goes through server → collector HTTP call, not shared imports.

### Parsing Pipeline
- Supported formats and their libraries:
  - **PDF**: `pdf-parse` with OCR fallback via `tesseract.js` for image-only PDFs
  - **DOCX/PPTX**: `mammoth` + `officeparser` for complex office files
  - **XLSX**: `node-xlsx`
  - **TXT/MD/CSV**: Direct read
  - **YouTube**: `youtube-transcriptPlus` for transcript extraction

### Chunking
- `@langchain/textsplitters` — `RecursiveCharacterTextSplitter`
- Default: 1000 chars per chunk, 200 chars overlap
- Tries to split on paragraphs → sentences → characters, keeping semantic coherence

### Embedding Strategy Pattern
- **Local (default)**: `@xenova/transformers` — air-gap compatible, runs locally
- **OpenAI**: Cloud embedding provider for non-air-gapped deployments
- User selects the embedding model at upload time

### Vector Store Strategy Pattern
- **LanceDB (default)**: Local, air-gap compatible
- **Qdrant**: Enterprise deployments
- Each vector entry stores metadata for NotebookLM-style citations: `documentId`, `workspaceId`, `pageNumber`, `lineStart`, `lineEnd`, `paragraph`

### .env Location
- Loads `.env` from `process.cwd()` (i.e., `packages/collector/`), NOT the monorepo root.