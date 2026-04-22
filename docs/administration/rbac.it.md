# RBAC

Il controllo degli accessi basato sui ruoli permette di gestire le autorizzazioni degli utenti assegnando ruoli con capacita predefinite. Questa guida illustra la creazione di ruoli, l'assegnazione delle autorizzazioni e la gestione degli utenti in AirGap AI Chatbot.

--8<-- "_snippets.it/standard-disclaimer.md"

## Comprendere i ruoli

AirGap AI Chatbot utilizza un modello di autorizzazione basato sui ruoli. Ogni ruolo definisce un insieme di autorizzazioni che determinano le azioni che un utente puo eseguire.

!!! note "Ruoli predefiniti"

    Il sistema fornisce tre ruoli integrati:

    - **Admin** — Accesso completo a tutte le funzionalita, inclusa la gestione degli utenti e la configurazione di sistema
    - **Editor** — Puo creare e modificare workspace, progetti e documenti, ma non puo gestire gli utenti
    - **Viewer** — Accesso in sola lettura ai workspace e ai documenti assegnati ai propri team

I ruoli vengono assegnati per workspace. Un utente puo avere ruoli diversi in workspace diversi.

## Creare un ruolo

Utilizzare l'API dei ruoli per creare un ruolo personalizzato con autorizzazioni specifiche.

```bash
curl -X POST "${BASE_URL}/roles" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "data-analyst",
    "permissions": [
      "documents:read",
      "documents:query",
      "workspaces:read"
    ]
  }'
```

!!! danger "Rischio di sovrascrittura"

    La creazione di un ruolo con un nome gia esistente sovrascrive il ruolo esistente e le relative autorizzazioni. Elencare prima i ruoli per evitare sovrascritture accidentali.

## Assegnare le autorizzazioni

Le autorizzazioni controllano l'accesso a risorse e azioni specifiche. Assegnarle ai ruoli anziche ai singoli utenti.

```bash
curl -X PUT "${BASE_URL}/roles/data-analyst/permissions" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "permissions": [
      "documents:read",
      "documents:query",
      "documents:upload",
      "workspaces:read"
    ]
  }'
```

!!! warning "Cascata di autorizzazioni"

    L'assegnazione di un'autorizzazione padre concede automaticamente tutte le autorizzazioni figlio. Ad esempio, `documents:write` include `documents:upload` e `documents:delete`. Verificare la gerarchia delle autorizzazioni prima di assegnare autorizzazioni di livello padre.

Categorie di autorizzazioni disponibili:

| Categoria | Autorizzazioni |
|-----------|--------------|
| `documents` | `read`, `upload`, `query`, `write`, `delete` |
| `workspaces` | `read`, `create`, `update`, `delete`, `manage` |
| `projects` | `read`, `create`, `update`, `delete` |
| `users` | `read`, `create`, `update`, `delete` |
| `settings` | `read`, `update` |

## Gestire gli utenti

Assegnare ruoli agli utenti tramite l'API di appartenenza al workspace.

```bash
curl -X POST "${BASE_URL}/workspaces/ws-1/members" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user-42",
    "role": "data-analyst"
  }'
```

!!! note "Gestione degli utenti"

    Gli utenti devono essere aggiunti a un workspace prima di poter accedere alle risorse al suo interno. Il ruolo Admin puo gestire i membri in tutti i workspace.

Per rimuovere un utente da un workspace:

```bash
curl -X DELETE "${BASE_URL}/workspaces/ws-1/members/user-42" \
  -H "Authorization: Bearer ${API_KEY}"
```

!!! danger "Revoca immediata"

    La rimozione di un utente da un workspace revoca immediatamente l'accesso a tutte le risorse al suo interno, incluse le sessioni attive e i token API con ambito limitato a quel workspace.