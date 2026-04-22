# Funzionalita

Esplorare le funzionalita della chat di AirGap AI Chatbot. Questa pagina illustra le conversazioni, il contesto dei documenti e l'integrazione con i workspace.

--8<-- "_snippets.it/api-base-url.md"

## Conversazioni

Le conversazioni sono il modello di interazione principale. Ogni conversazione e un thread indipendente di messaggi tra l'utente e il chatbot.

Creare una conversazione tramite l'interfaccia facendo clic su **Nuova conversazione**, oppure tramite API:

```bash
curl -X POST "$BASE_URL/conversations" \
  -H "Content-Type: application/json" \
  -d '{"title": "Discussione sulla pianificazione del progetto"}'
```

Inviare un messaggio all'interno di una conversazione:

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{"content": "Quali sono le fasi principali di un progetto software?"}'
```

La risposta include il messaggio dell'assistente insieme ai metadati:

```json
{
  "id": "msg_abc123",
  "role": "assistant",
  "content": "Le fasi principali includono tipicamente pianificazione, design, implementazione...",
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! note "Cronologia delle conversazioni"

    Tutti i messaggi vengono salvati in modo persistente. E' possibile recuperare le conversazioni precedenti dalla barra laterale in qualsiasi momento. La cronologia delle conversazioni e limitata al workspace attivo.

## Contesto dei documenti

Caricare documenti per fornire al chatbot conoscenze specifiche del dominio. Quando un documento e allegato a una conversazione, il chatbot lo utilizza come contesto per rispondere alle domande.

Allegare un documento durante l'invio di un messaggio:

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Riassumi i risultati principali di questo rapporto",
    "document_ids": ["doc_abc123"]
  }'
```

Il chatbot recupera i passaggi piu rilevanti dal documento caricato e li incorpora nella risposta. Le citazioni delle fonti appaiono insieme alla risposta.

!!! note "Retrieval-Augmented Generation"

    Il contesto dei documenti utilizza RAG (Retrieval-Augmented Generation) per trovare i passaggi piu rilevanti prima di generare una risposta. Questo garantisce che le risposte siano basate sui documenti effettivi anziche su conoscenze generali.

Per istruzioni dettagliate sul caricamento e l'interrogazione dei documenti, vedere [Caricamento](../documents-rag/uploading.md) e [Interrogazione](../documents-rag/querying.md).

## Integrazione con i workspace

Le conversazioni e i documenti sono organizzati all'interno dei workspace. Ogni workspace fornisce un ambiente isolato con il proprio insieme di conversazioni, documenti caricati e membri del team.

Elencare i propri workspace:

```bash
curl -X GET "$BASE_URL/workspaces" \
  -H "Content-Type: application/json"
```

Cambiare il workspace attivo nell'interfaccia selezionandolo dal menu a discesa dei workspace nella barra laterale. Il contesto del chatbot, i documenti e la cronologia delle conversazioni cambiano in base al workspace attivo.

!!! note "Ambito del workspace"

    I documenti caricati in un workspace non sono visibili in un altro. Questo garantisce l'isolamento dei dati tra team e progetti.

Per maggiori informazioni sulla gestione dei workspace, vedere [Aree di lavoro](../workspaces-projects/workspaces.md).