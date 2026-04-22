# Progetti

Creare e gestire progetti all'interno dei workspace per organizzare le conversazioni attorno a specifici argomenti o obiettivi. Questa guida illustra la creazione di un progetto, l'aggiunta di conversazioni e la gestione dei membri del progetto.

--8<-- "_snippets.it/standard-disclaimer.md"

## Creare un progetto

I progetti raggruppano le conversazioni correlate all'interno di un workspace. Utilizzare i progetti per organizzare il lavoro per argomento, sprint o deliverable.

Creare un progetto tramite l'interfaccia navigando nel proprio workspace e facendo clic su **Nuovo progetto**, oppure tramite API:

```bash
curl -X POST "$BASE_URL/workspaces/ws_abc123/projects" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Revisione sicurezza Q1",
    "description": "Progetto per l'audit di sicurezza e la revisione di conformita del Q1"
  }'
```

La risposta restituisce i dettagli del progetto:

```json
{
  "id": "proj_abc123",
  "workspace_id": "ws_abc123",
  "name": "Revisione sicurezza Q1",
  "description": "Progetto per l'audit di sicurezza e la revisione di conformita del Q1",
  "created_at": "2025-01-15T11:00:00Z",
  "conversation_count": 0
}
```

!!! tip "Nomenclatura dei progetti"

    Utilizzare nomi di progetto chiari e descrittivi che riflettano l'argomento o l'obiettivo. Questo rende piu facile per i membri del team trovare le conversazioni rilevanti.

## Aggiungere conversazioni

Aggiungere conversazioni esistenti a un progetto per mantenere organizzate le discussioni correlate.

Assegnare una conversazione a un progetto:

```bash
curl -X POST "$BASE_URL/projects/proj_abc123/conversations" \
  -H "Content-Type: application/json" \
  -d '{
    "conversation_id": "conv_xyz789"
  }'
```

E' possibile anche iniziare una nuova conversazione direttamente all'interno di un progetto selezionando il progetto nella barra laterale prima di digitare il messaggio.

Elencare tutte le conversazioni in un progetto:

```bash
curl -X GET "$BASE_URL/projects/proj_abc123/conversations" \
  -H "Content-Type: application/json"
```

Rimuovere una conversazione da un progetto:

```bash
curl -X DELETE "$BASE_URL/projects/proj_abc123/conversations/conv_xyz789" \
  -H "Content-Type: application/json"
```

!!! note "Proprieta delle conversazioni"

    La rimozione di una conversazione da un progetto non elimina la conversazione. Rimuove semplicemente l'associazione. La conversazione rimane accessibile dall'elenco delle conversazioni del workspace.

## Gestire i membri del progetto

Controllare chi puo accedere a un progetto gestendo il suo elenco di membri. I membri del progetto ereditano il ruolo del workspace ma possono ricevere permessi specifici del progetto.

Aggiungere un membro a un progetto:

```bash
curl -X POST "$BASE_URL/projects/proj_abc123/members" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "usr_def456",
    "permissions": ["read", "write"]
  }'
```

Elencare i membri del progetto:

```bash
curl -X GET "$BASE_URL/projects/proj_abc123/members" \
  -H "Content-Type: application/json"
```

Rimuovere un membro da un progetto:

```bash
curl -X DELETE "$BASE_URL/projects/proj_abc123/members/usr_def456" \
  -H "Content-Type: application/json"
```

!!! tip "Membri del progetto vs membri del workspace"

    Tutti i membri del workspace possono visualizzare i progetti per impostazione predefinita, ma i permessi specifici del progetto controllano chi puo aggiungere conversazioni e gestire le impostazioni del progetto. Utilizzare l'appartenenza al progetto per limitare l'accesso alle discussioni sensibili.

Per la gestione a livello di workspace, vedere [Aree di lavoro](workspaces.md).