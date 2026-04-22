# Panoramica

AirGap AI Chatbot e progettato con la sicurezza come principio fondamentale. Questa pagina descrive l'architettura di sicurezza, le pratiche di gestione dei dati, il modello di minaccia e le considerazioni sulla sicurezza di rete che proteggono i dati e il deployment.

--8<-- "_snippets.it/standard-disclaimer.md"

## Architettura di sicurezza

AirGap AI Chatbot segue un'architettura di difesa in profondita con piu livelli di sicurezza che proteggono i dati utente e l'integrita del sistema.

L'applicazione viene eseguita come servizio a singolo container self-hosted senza dipendenze esterne per impostazione predefinita. Tutta l'elaborazione dei dati avviene all'interno del perimetro di deployment e nessun dato utente viene trasmesso a servizi esterni se non configurato esplicitamente.

!!! note "Isolamento dei componenti"

    Ogni componente principale (server API, processore di documenti, motore RAG) opera all'interno dello stesso container ma comunica tramite API interne con validazione degli input e limitazione delle richieste. Questa separazione impedisce lo spostamento laterale all'interno dell'applicazione.

Principi architetturali chiave:

- **Deployment self-hosted** -- Tutti i dati rimangono sulla propria infrastruttura
- **Nessuna comunicazione esterna** -- Telemetria e controlli di aggiornamento sono disabilitati in modalita offline
- **Minimo privilegio** -- RBAC controlla l'accesso a livello di workspace
- **Validazione degli input** -- Tutti gli input API sono validati e sanificati prima dell'elaborazione

## Gestione dei dati

Comprendere come AirGap AI Chatbot gestisce i dati e fondamentale per la pianificazione della sicurezza.

### Dati a riposo

I documenti caricati e i dati delle conversazioni sono memorizzati nel database configurato (SQLite per impostazione predefinita). Il file del database risiede nel volume di dati montato ed e protetto dai permessi dei file del sistema operativo host.

!!! note "Crittografia del volume"

    Per i deployment di produzione, utilizzare volumi crittografati o crittografia completa del disco sull'host per proteggere i dati a riposo. L'applicazione non implementa un proprio livello di crittografia per i dati memorizzati.

### Dati in transito

Tutta la comunicazione API deve utilizzare TLS in produzione. L'applicazione supporta la terminazione TLS tramite certificati montati o attraverso un reverse proxy.

- **Comunicazione interna** -- Le chiamate da servizio a servizio all'interno del container utilizzano HTTP su localhost
- **Comunicazione esterna** -- La comunicazione da client a server deve utilizzare HTTPS
- **Elaborazione dei documenti** -- I documenti caricati sono elaborati in memoria e non scritti in posizioni temporanee su disco

### Conservazione dei dati

La cronologia delle conversazioni e i documenti caricati persistono finche non vengono eliminati esplicitamente tramite l'API o l'interfaccia di amministrazione. Non esiste una politica automatica di scadenza dei dati.

!!! warning "Sicurezza dei backup"

    I backup del database contengono tutti i dati utente, incluso il contenuto dei documenti. Trattare i backup con gli stessi controlli di sicurezza del database di produzione. Crittografare i backup e limitare l'accesso al personale autorizzato.

## Modello di minaccia

Il modello di minaccia di AirGap AI Chatbot identifica i rischi principali e le mitigazioni per i deployment self-hosted.

### Confini di fiducia

| Confine | Descrizione | Mitigazione |
|---------|-------------|-------------|
| Client verso API | Input non attendibile da browser e client API | Validazione input, limitazione richieste, RBAC |
| API verso database | Comunicazione interna attendibile | Binding solo localhost, permessi volume |
| Container verso host | Rischio di evasione del container | Privilegi minimi del container, mount in sola lettura ove possibile |
| Rete air-gap | Nessuna connettivita esterna | `OFFLINE_MODE=true` disabilita tutte le chiamate esterne |

### Vettori di attacco

- **Attacchi di injection** -- Tutti gli input utente sono validati e sanificati. I caricamenti di documenti sono elaborati in un ambiente sandbox.
- **Bypass dell'autenticazione** -- Le chiavi API sono richieste per tutti gli endpoint. Le chiavi sono hashate a riposo e mai registrate nei log.
- **Esfiltrazione dei dati** -- In modalita air-gap, tutte le connessioni di rete esterne sono disabilitate. Il contenuto dei documenti non e incluso nei log.
- **Escalation dei privilegi** -- RBAC applica il controllo degli accessi a livello di workspace. Le operazioni a livello Admin richiedono l'assegnazione esplicita del ruolo.

!!! warning "Infrastruttura condivisa"

    Quando si distribuisce su infrastruttura condivisa, assicurarsi che il volume di dati non sia accessibile ad altri container o utenti. Utilizzare volumi Docker o bind mount con permessi limitati.

## Sicurezza di rete

AirGap AI Chatbot e progettato per operare in ambienti con restrizioni di rete.

### Configurazione di rete

- L'applicazione e in ascolto su una singola porta HTTP (predefinita 3000)
- Tutti i servizi interni comunicano su localhost
- Nessuna connessione in uscita e richiesta per la funzionalita principale
- In modalita offline, tutte le connessioni in uscita sono bloccate

### Configurazione TLS

Per i deployment di produzione, abilitare TLS direttamente nel container o attraverso un reverse proxy:

- **TLS nel container** -- Montare i certificati e impostare le variabili d'ambiente `TLS_CERT` e `TLS_KEY`
- **TLS nel reverse proxy** -- Terminare TLS su un reverse proxy (nginx, Caddy, Traefik) e inoltrare al container su localhost

!!! note "Vantaggi del reverse proxy"

    L'utilizzo di un reverse proxy fornisce terminazione TLS, registrazione delle richieste e limitazione aggiuntiva delle richieste. Vedere [Docker](../deployment/docker.md) per esempi di deployment con configurazione TLS.

Per i requisiti normativi e la registrazione di audit, vedere [Conformita](compliance.md).