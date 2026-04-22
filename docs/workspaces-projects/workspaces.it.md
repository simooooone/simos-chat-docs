# Aree di lavoro

Creare e gestire aree di lavoro per organizzare le conversazioni e i documenti del team. Questa guida illustra la creazione di un workspace, la configurazione delle impostazioni e la condivisione dell'accesso con i membri del team.

--8<-- "_snippets.it/standard-disclaimer.md"

## Creare un workspace

I workspace forniscono ambienti isolati per organizzare conversazioni, documenti e membri del team. Ogni workspace ha una propria libreria di documenti e una cronologia delle conversazioni.

Creare un workspace tramite l'interfaccia facendo clic su **Nuovo workspace** nella barra laterale, oppure tramite API:

```bash
curl -X POST "$BASE_URL/workspaces" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Team di ingegneria",
    "description": "Workspace per discussioni e documentazione di ingegneria"
  }'
```

La risposta restituisce i dettagli del workspace:

```json
{
  "id": "ws_abc123",
  "name": "Team di ingegneria",
  "description": "Workspace per discussioni e documentazione di ingegneria",
  "created_at": "2025-01-15T10:00:00Z",
  "members": [
    {
      "user_id": "usr_xyz789",
      "role": "owner"
    }
  ]
}
```

!!! note "Isolamento del workspace"

    I documenti e le conversazioni in un workspace non sono visibili in altri workspace. Questo garantisce l'isolamento dei dati tra team e progetti.

## Configurare le impostazioni del workspace

Dopo aver creato un workspace, regolarne le impostazioni in base alle esigenze del team.

Aggiornare la configurazione di un workspace:

```bash
curl -X PATCH "$BASE_URL/workspaces/ws_abc123" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Team di ingegneria - Aggiornato",
    "description": "Workspace per tutte le attivita di ingegneria",
    "settings": {
      "max_members": 25,
      "default_model": "code-optimized"
    }
  }'
```

Recuperare le impostazioni correnti del workspace:

```bash
curl -X GET "$BASE_URL/workspaces/ws_abc123" \
  -H "Content-Type: application/json"
```

!!! warning "Permessi del proprietario"

    Solo i proprietari del workspace possono modificare le impostazioni. I membri con ruolo `admin` o `member` non possono modificare impostazioni come il modello predefinito o i limiti dei membri.

## Condividere un workspace

Invitare membri del team in un workspace aggiungendoli con un ruolo specifico.

Aggiungere un membro a un workspace:

```bash
curl -X POST "$BASE_URL/workspaces/ws_abc123/members" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "usr_def456",
    "role": "member"
  }'
```

Ruoli disponibili:

| Ruolo | Descrizione |
|-------|-------------|
| `owner` | Controllo completo: impostazioni, membri e dati |
| `admin` | Gestire membri e conversazioni; non puo modificare le impostazioni |
| `member` | Partecipare alle conversazioni e caricare documenti |

!!! warning "Modifiche ai ruoli"

    La modifica del ruolo di un membro a un livello di privilegio inferiore ha effetto immediato. L'utente interessato perde l'accesso alle funzionalita con restrizioni subito.

Rimuovere un membro da un workspace:

```bash
curl -X DELETE "$BASE_URL/workspaces/ws_abc123/members/usr_def456" \
  -H "Content-Type: application/json"
```

Per organizzare il lavoro all'interno di un workspace, vedere [Progetti](projects.md).