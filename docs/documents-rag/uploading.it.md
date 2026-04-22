# Caricamento

Caricare documenti nel proprio workspace affinche il chatbot possa utilizzarli come contesto per rispondere alle domande. Questa guida illustra i formati supportati, il caricamento tramite l'interfaccia e il caricamento tramite API.

--8<-- "_snippets.it/api-base-url.md"

--8<-- "_snippets.it/standard-disclaimer.md"

## Formati supportati

AirGap AI Chatbot elabora i seguenti formati di documento:

| Formato | Estensione | Note |
|---------|------------|-------|
| PDF | `.pdf` | Testo estratto dal PDF; le immagini scansionate non sono supportate |
| Testo semplice | `.txt` | File di testo con codifica UTF-8 |
| Markdown | `.md` | Reso e indicizzato come contenuto strutturato |
| CSV | `.csv` | Dati tabulari indicizzati riga per riga |

!!! note "Limite di dimensione"

    La dimensione massima di caricamento per documento e controllata dalla variabile di configurazione `AIRGAP_MAX_UPLOAD_SIZE` (predefinito: 50 MB). I documenti che superano questo limite vengono rifiutati con un messaggio di errore.

## Caricare tramite l'interfaccia

Per caricare un documento tramite l'interfaccia del chatbot:

1. Aprire una conversazione nel workspace attivo
2. Fare clic sul pulsante **Allega** (icona della graffetta) accanto al campo di inserimento
3. Selezionare un file dal sistema locale
4. Il documento appare come allegato nell'area di inserimento
5. Digitare la domanda e premere **Invio**

Il chatbot elabora il documento e lo indicizza per il recupero. E' possibile fare riferimento al documento nelle domande di follow-up all'interno della stessa conversazione.

!!! tip "Caricamenti multipli"

    Per caricare piu documenti contemporaneamente, utilizzare l'endpoint API descritto di seguito. L'interfaccia supporta un documento per messaggio.

## Caricare tramite API

Caricare un documento tramite API:

```bash
curl -X POST "$BASE_URL/documents" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@report.pdf" \
  -F "workspace_id=ws_abc123"
```

La risposta include l'ID del documento e lo stato di elaborazione:

```json
{
  "id": "doc_abc123",
  "filename": "report.pdf",
  "status": "processing",
  "created_at": "2025-01-15T10:30:00Z"
}
```

Verificare lo stato di elaborazione:

```bash
curl -X GET "$BASE_URL/documents/doc_abc123" \
  -H "Content-Type: application/json"
```

Quando lo stato passa a `ready`, il documento e indicizzato e disponibile per le interrogazioni.

!!! warning "Caricamenti duplicati"

    Il caricamento dello stesso file due volte crea una nuova voce di documento. Per evitare duplicati, verificare l'elenco dei documenti prima di caricare.

!!! note "Tempo di elaborazione"

    Il tempo di elaborazione dei documenti dipende dalla dimensione e dalla complessita del file. La maggior parte dei file di testo viene elaborata in pochi secondi; i file PDF di grandi dimensioni possono richiedere fino a un minuto.

Per le istruzioni su come interrogare i documenti caricati, vedere [Interrogazione](querying.md).