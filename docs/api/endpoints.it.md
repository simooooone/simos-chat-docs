# Endpoint

Endpoint API REST disponibili per AirGap AI Chatbot, inclusi i formati di richiesta e risposta per le operazioni di chat, documenti e workspace.

--8<-- "_snippets.it/api-base-url.md"

## Endpoint Chat

Interagire con il chatbot tramite l'API di chat per inviare messaggi e recuperare la cronologia delle conversazioni.

### Inviare un messaggio

```bash
curl -X POST "${BASE_URL}/chat/messages" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "workspace_id": "ws-1",
    "message": "Riassumi il rapporto trimestrale",
    "context_documents": ["doc-42"]
  }'
```

Risposta:

```json
{
  "id": "msg-abc123",
  "content": "The quarterly report shows a 12% increase...",
  "sources": ["doc-42"],
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! note "Documenti di contesto"

    Includere `context_documents` per limitare la risposta del chatbot a documenti specifici caricati. Senza questo parametro, il chatbot utilizza tutti i documenti nel workspace.

### Elencare le conversazioni

```bash
curl -X GET "${BASE_URL}/chat/conversations?workspace_id=ws-1" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Paginazione"

    Utilizzare i parametri di query `?limit=20&offset=0` per paginare attraverso set di risultati ampi. La risposta include un conteggio `total` per calcolare gli offset successivi.

## Endpoint Documenti

Caricare, elencare e gestire i documenti utilizzati per la generazione aumentata dal recupero.

### Caricare un documento

```bash
curl -X POST "${BASE_URL}/documents/upload" \
  -H "Authorization: Bearer ${API_KEY}" \
  -F "file=@report.pdf" \
  -F "workspace_id=ws-1"
```

!!! note "Formati supportati"

    L'API accetta file PDF, TXT, DOCX e MD. La dimensione massima del file e controllata dall'impostazione di sistema `max_upload_size_mb`.

### Elencare i documenti

```bash
curl -X GET "${BASE_URL}/documents?workspace_id=ws-1" \
  -H "Authorization: Bearer ${API_KEY}"
```

### Eliminare un documento

```bash
curl -X DELETE "${BASE_URL}/documents/doc-42" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Operazioni batch"

    Per eliminare piu documenti, utilizzare l'endpoint `DELETE /documents/batch` con un array JSON di ID documento nel corpo della richiesta.

## Endpoint Workspace

Creare e gestire workspace che organizzano conversazioni, documenti e accesso del team.

### Creare un workspace

```bash
curl -X POST "${BASE_URL}/workspaces" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Team Marketing",
    "description": "Workspace per i documenti e le conversazioni del team marketing"
  }'
```

### Elencare i workspace

```bash
curl -X GET "${BASE_URL}/workspaces" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Filtraggio"

    Utilizzare `?role=admin` per elencare solo i workspace in cui si ha un ruolo specifico. Utile per trovare i workspace in cui si hanno autorizzazioni di gestione.

### Aggiornare un workspace

```bash
curl -X PUT "${BASE_URL}/workspaces/ws-1" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Team Marketing - Aggiornato",
    "description": "Descrizione aggiornata"
  }'
```