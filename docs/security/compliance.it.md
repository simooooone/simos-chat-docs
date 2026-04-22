# Conformita

Residenza dei dati, conformita GDPR e registrazione di audit per i deployment di AirGap AI Chatbot.

--8<-- "_snippets.it/standard-disclaimer.md"

## Residenza dei dati

AirGap AI Chatbot memorizza tutti i dati all'interno dell'infrastruttura di deployment per impostazione predefinita. Nessun dato lascia l'ambiente configurato a meno che non vengano abilitate esplicitamente integrazioni esterne.

!!! note "Comportamento predefinito"

    Nella configurazione predefinita, tutto il contenuto dei documenti, la cronologia delle conversazioni e i dati utente risiedono nel database SQLite locale all'interno del volume di dati montato. Nessun dato viene trasmesso a servizi esterni.

### Configurare la posizione dei dati

Il punto di montaggio del volume di dati determina dove sono memorizzati i dati persistenti:

```bash
docker run -d \
  -v /data/airgap:/app/data \
  ghcr.io/elia/airgap-chatbot:latest
```

Per garantire che i dati rimangano all'interno di una giurisdizione specifica, montare il volume su un archivio che risiede in tale regione.

!!! tip "Conformita alla residenza dei dati"

    Per le organizzazioni con requisiti di residenza dei dati, distribuire l'intero stack (applicazione, database, backup) all'interno della giurisdizione richiesta. Verificare che i processi di backup e i siti di disaster recovery siano conformi ai requisiti di residenza.

## Conformita GDPR

AirGap AI Chatbot supporta la conformita GDPR attraverso la minimizzazione dei dati, i diritti degli utenti e la conservazione configurabile dei dati.

### Diritto di accesso

Recuperare tutti i dati associati a un utente tramite l'API:

```bash
curl -X GET "${BASE_URL}/users/user-42/data-export" \
  -H "Authorization: Bearer ${API_KEY}"
```

Questo endpoint restituisce un'esportazione completa delle conversazioni dell'utente, dei documenti caricati e delle appartenenze ai workspace.

### Diritto alla cancellazione

Eliminare tutti i dati associati a un utente:

```bash
curl -X DELETE "${BASE_URL}/users/user-42" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"confirm": true, "delete_documents": true}'
```

!!! warning "Cancellazione irreversibile"

    La cancellazione dell'utente e permanente e non puo essere annullata. Il flag `delete_documents` rimuove anche i documenti di proprieta dell'utente da tutti i workspace. Confermare l'ambito della cancellazione prima di eseguire questa richiesta.

### Diritto di rettifica

Aggiornare le informazioni del profilo utente:

```bash
curl -X PUT "${BASE_URL}/users/user-42/profile" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Nome Aggiornato",
    "email": "aggiornato@esempio.com"
  }'
```

!!! note "Registri del trattamento"

    AirGap AI Chatbot non agisce come responsabile del trattamento per terze parti. Come soluzione self-hosted, l'organizzazione che distribuisce e il titolare del trattamento. Mantenere il proprio registro delle attivita di trattamento secondo l'Articolo 30 del GDPR.

## Registrazione di audit

AirGap AI Chatbot registra le azioni amministrative e di sicurezza rilevanti per la conformita e la revisione forense.

### Eventi del registro di audit

Il sistema registra i seguenti tipi di eventi:

| Tipo di evento | Descrizione |
|---------------|-------------|
| `user.login` | Eventi di autenticazione utente |
| `user.login_failed` | Tentativi di autenticazione falliti |
| `user.create` | Creazione di nuovi utenti |
| `user.delete` | Cancellazione di utenti |
| `role.assign` | Modifiche nell'assegnazione dei ruoli |
| `role.revoke` | Revoca dei ruoli |
| `api_key.create` | Creazione di chiavi API |
| `api_key.revoke` | Revoca di chiavi API |
| `document.upload` | Eventi di caricamento documenti |
| `document.delete` | Cancellazione di documenti |
| `settings.update` | Modifiche alla configurazione di sistema |

### Interrogare i registri di audit

Recuperare i registri di audit tramite l'API:

```bash
curl -X GET "${BASE_URL}/audit-logs?limit=100&offset=0" \
  -H "Authorization: Bearer ${API_KEY}"
```

Filtrare per tipo di evento o intervallo di date:

```bash
curl -X GET "${BASE_URL}/audit-logs?event_type=role.assign&from=2025-01-01&to=2025-01-31" \
  -H "Authorization: Bearer ${API_KEY}"
```

### Esportare i registri di audit

Esportare i registri di audit per l'archiviazione a lungo termine e la revisione di conformita:

```bash
curl -X GET "${BASE_URL}/audit-logs/export?format=json&from=2025-01-01" \
  -H "Authorization: Bearer ${API_KEY}" \
  -o audit-logs-2025-01.json
```

!!! tip "Conservazione dei log"

    Configurare la conservazione dei log di audit per soddisfare i requisiti di conformita. Molte normative richiedono un minimo di 12 mesi di conservazione dei log. Archiviare i log esportati su archivi immodificabili per trail di audit a prova di manomissione.

## Reporting di conformita

Generare report di conformita che riassumono la postura di sicurezza e le pratiche di gestione dei dati del proprio deployment.

### Riepilogo di conformita del sistema

```bash
curl -X GET "${BASE_URL}/settings/compliance-summary" \
  -H "Authorization: Bearer ${API_KEY}"
```

Questo endpoint restituisce un riepilogo di:

- Numero di utenti attivi e distribuzione dei ruoli
- Configurazione della residenza dei dati
- Stato TLS e crittografia
- Periodo di copertura dei log di audit
- Conteggio delle chiavi API e stato di scadenza

!!! tip "Revisioni regolari"

    Pianificare revisioni mensili di conformita utilizzando l'endpoint di riepilogo di conformita. Monitorare le modifiche nel tempo per dimostrare la conformita continua agli auditor e ai regolatori.

Per i dettagli sull'architettura di sicurezza e il modello di minaccia, vedere [Panoramica](overview.md).