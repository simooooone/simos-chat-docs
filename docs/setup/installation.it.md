# Installazione

Installare AirGap AI Chatbot sulla propria infrastruttura con Docker. Questa guida illustra il download dell'immagine container, l'esecuzione e la verifica che l'applicazione sia attiva e funzionante.

--8<-- "_snippets.it/prereq-docker.md"

## Scaricare l'immagine

Scaricare l'immagine container piu recente di AirGap AI Chatbot dal GitHub Container Registry:

```bash
docker pull ghcr.io/elia/airgap-chatbot:latest
```

!!! note "Versioni specifiche"

    Sostituire `latest` con un tag di versione (ad esempio `v1.2.0`) per fissare una release specifica. Consultare la [pagina delle release su GitHub](https://github.com/elia/simos-chat-docs/releases) per i tag disponibili.

## Eseguire il container

Avviare il container del chatbot con la configurazione predefinita:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v ./data:/app/data \
  ghcr.io/elia/airgap-chatbot:latest
```

Il comando sopra:

- Esegue il container in modalita detached (`-d`)
- Assegna al container il nome `airgap-chatbot` per una gestione semplice
- Mappa la porta `3000` dell'host sulla porta `3000` del container
- Monta la directory `./data` per l'archiviazione persistente

!!! warning "Requisiti di sistema"

    Assicurarsi che il sistema abbia almeno 4 GB di RAM disponibili per il container. Il chatbot carica modelli linguistici in memoria all'avvio e richiede risorse sufficienti per funzionare correttamente.

!!! warning "Persistenza dei dati"

    Montare sempre un volume su `/app/data`. Senza un volume, tutte le conversazioni, i documenti caricati e le impostazioni del workspace vengono persi alla rimozione del container.

## Verificare l'installazione

Dopo l'avvio del container, confermare che AirGap AI Chatbot sia in esecuzione:

```bash
docker ps --filter name=airgap-chatbot
```

E' possibile verificare anche l'endpoint di health:

```bash
curl -s http://localhost:3000/api/health | head -1
```

!!! tip "Primo accesso"

    Aprire [http://localhost:3000](http://localhost:3000) nel browser per accedere all'interfaccia del chatbot. Se la pagina non si carica, verificare i log del container con `docker logs airgap-chatbot`.

Per arrestare il container, eseguire:

```bash
docker stop airgap-chatbot
```

Per rimuovere il container completamente:

```bash
docker rm -f airgap-chatbot
```

Dopo aver verificato l'installazione, passare a [Configurazione](configuration.md) per personalizzare le impostazioni del proprio ambiente.