# Interrogazione

Interrogare i documenti caricati utilizzando RAG (Retrieval-Augmented Generation). Questa guida illustra come porre domande, visualizzare le fonti e perfezionare le interrogazioni per ottenere risultati migliori.

--8<-- "_snippets.it/api-base-url.md"

## Porre una domanda

Una volta caricati ed elaborati i documenti, porre domande sul loro contenuto tramite l'interfaccia della chat o tramite API.

Per interrogare dall'interfaccia, aprire una conversazione con documenti allegati e digitare la domanda nel campo di inserimento. Il chatbot cerca i passaggi rilevanti nell'indice dei documenti prima di generare una risposta.

Per interrogare tramite API:

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Quali sono i principali requisiti di sicurezza elencati nella politica?",
    "document_ids": ["doc_abc123"]
  }'
```

La risposta include la risposta e i riferimenti ai passaggi delle fonti:

```json
{
  "id": "msg_def456",
  "role": "assistant",
  "content": "La politica elenca tre requisiti di sicurezza principali: crittografia a riposo, registrazione degli accessi e autenticazione a piu fattori...",
  "sources": [
    {
      "document_id": "doc_abc123",
      "page": 12,
      "excerpt": "Tutti i dati archiviati devono essere crittografati a riposo utilizzando AES-256..."
    }
  ],
  "created_at": "2025-01-15T10:35:00Z"
}
```

!!! tip "Essere specifici"

    Piu specifica e la domanda, piu rilevanti saranno i passaggi recuperati. Invece di "parlami della sicurezza", provare "quali standard di crittografia sono richiesti per i dati a riposo?"

## Visualizzare le fonti

Ogni risposta che utilizza il contesto dei documenti include citazioni delle fonti. Queste citazioni mostrano quali passaggi del documento sono stati utilizzati per generare la risposta.

Nell'interfaccia, le citazioni delle fonti appaiono come sezioni espandibili sotto la risposta. Fare clic su una citazione per visualizzare il brano completo dal documento originale.

Tramite API, le fonti vengono restituite nell'array `sources`:

```bash
curl -X GET "$BASE_URL/conversations/{conversation_id}/messages/msg_def456" \
  -H "Content-Type: application/json"
```

Il campo `sources` contiene l'ID del documento, il numero di pagina e il brano per ciascun passaggio citato.

!!! note "Accuratezza delle fonti"

    Le fonti indicano i passaggi esatti utilizzati dal modello. Se il modello non riesce a trovare contenuto rilevante nei documenti caricati, lo indichera nella risposta anziche inventare fonti.

## Perfezionare l'interrogazione

Se la risposta iniziale non risponde completamente alla domanda, perfezionare l'interrogazione utilizzando queste tecniche:

- **Aggiungere contesto:** Includere maggiori dettagli su cio che si sta cercando
- **Specificare il documento:** Fare riferimento a un documento particolare quando si hanno piu caricamenti
- **Porre domande di follow-up:** Costruire sulle risposte precedenti all'interno della stessa conversazione

```bash
curl -X POST "$BASE_URL/conversations/{conversation_id}/messages" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Puoi fornire maggiori dettagli sul requisito di registrazione degli accessi menzionato prima?",
    "document_ids": ["doc_abc123"]
  }'
```

!!! tip "Contesto della conversazione"

    Le domande di follow-up all'interno della stessa conversazione mantengono il contesto dai messaggi precedenti. Il chatbot ricorda cosa e stato discusso e quali documenti sono stati referenziati, quindi non e necessario ripetere le informazioni.

Per le istruzioni sul caricamento dei documenti, vedere [Caricamento](uploading.md).