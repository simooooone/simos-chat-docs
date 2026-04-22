# Autenticazione

Gestire le chiavi API e autenticare le richieste all'API di AirGap AI Chatbot. Questa guida illustra la generazione delle chiavi, l'autenticazione delle richieste, il ciclo di vita dei token e la revoca delle chiavi.

--8<-- "_snippets.it/api-base-url.md"

## Generare una chiave API

Creare una chiave API tramite l'interfaccia delle impostazioni o l'API. Ogni chiave e limitata a un workspace e a un insieme di autorizzazioni.

```bash
curl -X POST "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "integration-key",
    "permissions": ["documents:read", "documents:query"],
    "workspace_scope": "ws-1"
  }'
```

Risposta:

```json
{
  "id": "key-xyz789",
  "name": "integration-key",
  "key": "agc_live_4d5e6f7a8b9c0d1e2f3a",
  "permissions": ["documents:read", "documents:query"],
  "workspace_scope": "ws-1",
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! danger "Conservare le chiavi in modo sicuro"

    Il valore della chiave API viene restituito una sola volta al momento della creazione. Non puo essere recuperato successivamente. Conservarlo immediatamente in un gestore di segreti o in una variabile d'ambiente. Non inserire mai le chiavi API nel controllo di versione.

## Autenticare le richieste

Includere la chiave API nell'intestazione `Authorization` come token Bearer per ogni richiesta autenticata.

```bash
curl -X GET "${BASE_URL}/documents?workspace_id=ws-1" \
  -H "Authorization: Bearer agc_live_4d5e6f7a8b9c0d1e2f3a"
```

!!! danger "Solo HTTPS"

    Utilizzare sempre HTTPS quando si trasmettono chiavi API. L'invio di credenziali su HTTP semplice le espone all'intercettazione. I deployment di produzione devono applicare TLS.

### Formato dell'intestazione di autenticazione

Tutte le richieste autenticate devono includere la seguente intestazione:

```
Authorization: Bearer <your-api-key>
```

Il prefisso della chiave `agc_live_` identifica il tipo di chiave. Le chiavi con prefisso `agc_test_` sono chiavi di test che interagiscono solo con i dati sandbox.

!!! note "Chiavi di test"

    Le chiavi di test (`agc_test_`) non influiscono sui dati di produzione. Utilizzarle per test di integrazione e ambienti di sviluppo.

## Ciclo di vita dei token

Le chiavi API hanno un ciclo di vita configurabile. Per impostazione predefinita, le chiavi non scadono, ma e possibile impostare una data di scadenza durante la creazione.

### Creare una chiave con scadenza

```bash
curl -X POST "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "temporary-access",
    "permissions": ["documents:read"],
    "workspace_scope": "ws-1",
    "expires_at": "2025-12-31T23:59:59Z"
  }'
```

!!! warning "Scadenza dei token"

    Le chiavi scadute restituiscono una risposta `401 Unauthorized`. Configurare il monitoraggio per rilevare la scadenza delle chiavi prima che causi interruzioni del servizio. Verificare le date di scadenza delle chiavi con l'endpoint `GET /settings/api-keys`.

## Revocare una chiave

Rimuovere una chiave API quando non e piu necessaria o quando si sospetta che sia stata compromessa.

```bash
curl -X DELETE "${BASE_URL}/settings/api-keys/key-xyz789" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! danger "Revoca immediata"

    La revoca della chiave ha effetto immediato. Tutte le richieste attive che utilizzano la chiave revocata riceveranno risposte `401 Unauthorized` entro pochi secondi. Ruotare le chiavi proattivamente creando una chiave sostitutiva prima di revocare quella vecchia.

Per elencare tutte le chiavi e identificare quali revocare:

```bash
curl -X GET "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}"
```