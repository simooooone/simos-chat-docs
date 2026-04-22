# Impostazioni

Configurare le impostazioni di sistema di AirGap AI Chatbot, gestire le chiavi API e svolgere le attivita di manutenzione ordinaria.

--8<-- "_snippets.it/standard-disclaimer.md"

## Accedere alle impostazioni

Aprire la pagina Impostazioni dalla sezione Amministrazione nella barra di navigazione laterale. Solo gli utenti con ruolo Admin o autorizzazione `settings:read` possono visualizzare le impostazioni di sistema.

```bash
curl -X GET "${BASE_URL}/settings" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! tip "Accesso rapido"

    Aggiungere `/settings` all'URL del proprio workspace per accedere direttamente alla pagina delle impostazioni.

## Configurazione generale

Le impostazioni di sistema controllano il comportamento di AirGap AI Chatbot in tutti i workspace.

```bash
curl -X PUT "${BASE_URL}/settings/general" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "default_language": "en",
    "max_upload_size_mb": 100,
    "session_timeout_minutes": 60,
    "enable_registration": true
  }'
```

!!! warning "Riavvio necessario"

    Alcune modifiche alla configurazione generale richiedono un riavvio del servizio per avere effetto. La risposta dell'API include il flag `restart_required` quando applicabile.

Impostazioni generali disponibili:

| Impostazione | Tipo | Predefinito | Descrizione |
|-------------|------|-------------|-------------|
| `default_language` | string | `en` | Lingua predefinita dell'interfaccia per i nuovi utenti |
| `max_upload_size_mb` | integer | `100` | Dimensione massima del caricamento documenti in megabyte |
| `session_timeout_minutes` | integer | `60` | Durata della sessione in minuti |
| `enable_registration` | boolean | `true` | Consenti la registrazione autonoma dei nuovi utenti |

## Chiavi API

Le chiavi API autenticano le applicazioni e gli script esterni. Ogni chiave puo essere limitata a workspace e autorizzazioni specifici.

### Generare una chiave API

```bash
curl -X POST "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ci-pipeline",
    "permissions": ["documents:read", "documents:upload"],
    "workspace_scope": "ws-1"
  }'
```

La risposta restituisce il valore della chiave una sola volta. Conservarlo in modo sicuro perche non puo essere recuperato successivamente.

```json
{
  "id": "key-abc123",
  "name": "ci-pipeline",
  "key": "agc_live_9a8b7c6d5e4f3a2b1c0d",
  "created_at": "2025-01-15T10:30:00Z"
}
```

!!! tip "Convenzione di denominazione"

    Utilizzare nomi descrittivi per le chiavi API che indichino lo scopo e l'ambiente, come `ci-pipeline-production` o `analytics-dashboard-staging`.

### Gestire le chiavi API

Elencare tutte le chiavi API per il workspace corrente:

```bash
curl -X GET "${BASE_URL}/settings/api-keys" \
  -H "Authorization: Bearer ${API_KEY}"
```

Revocare una chiave specifica quando non e piu necessaria:

```bash
curl -X DELETE "${BASE_URL}/settings/api-keys/key-abc123" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! warning "Effetto immediato"

    La revoca di una chiave API ha effetto immediato. Qualsiasi applicazione che utilizza la chiave ricevera errori di autenticazione.

## Manutenzione del sistema

### Visualizzare lo stato del sistema

```bash
curl -X GET "${BASE_URL}/settings/status" \
  -H "Authorization: Bearer ${API_KEY}"
```

L'endpoint di stato restituisce informazioni sull'integrita del sistema, inclusi l'utilizzo dell'archiviazione, le sessioni attive e il tempo di attivita del servizio.

### Cancellare le cache

```bash
curl -X POST "${BASE_URL}/settings/maintenance/clear-cache" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! warning "Impatto sulle prestazioni"

    La cancellazione delle cache provoca rallentamenti temporanei durante la ricostruzione delle cache delle query. Pianificare le operazioni di manutenzione durante i periodi di basso traffico.