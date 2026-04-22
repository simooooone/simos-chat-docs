# Docker

Distribuire AirGap AI Chatbot con Docker e Docker Compose per installazioni containerizzate e riproducibili.

--8<-- "_snippets.it/prereq-docker.md"

## Distribuire con Docker

Eseguire AirGap AI Chatbot come singolo container Docker con la configurazione minima richiesta.

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v airgap-data:/app/data \
  -e NODE_ENV=production \
  -e LOG_LEVEL=info \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! warning "Requisiti di sistema"

    Il container richiede almeno 4 GB di RAM. Assegnare 2 core CPU e 4 GB di memoria a Docker per prestazioni ottimali:

    ```bash
    docker update --memory 4g --cpus 2 airgap-chatbot
    ```

### Verificare il container

Dopo aver avviato il container, confermare che sia in esecuzione:

```bash
docker ps --filter name=airgap-chatbot
```

Verificare l'endpoint di salute dell'applicazione:

```bash
curl -s http://localhost:3000/api/health | head -1
```

Una risposta corretta restituisce:

```json
{ "status": "ok" }
```

!!! tip "Visualizzare i log del container"

    Monitorare i log del container per risolvere i problemi di avvio:

    ```bash
    docker logs -f airgap-chatbot
    ```

## Distribuire con Docker Compose

Docker Compose semplifica i deployment multi-container e rende la configurazione riproducibile tra gli ambienti.

Creare un file `docker-compose.yml`:

```yaml
version: "3.8"

services:
  chatbot:
    image: ghcr.io/elia/airgap-chatbot:latest
    container_name: airgap-chatbot
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - airgap-data:/app/data
    environment:
      - NODE_ENV=production
      - LOG_LEVEL=info
      - MAX_UPLOAD_SIZE_MB=100
      - SESSION_TIMEOUT_MINUTES=60
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

volumes:
  airgap-data:
    driver: local
```

Avviare il deployment:

```bash
docker compose up -d
```

!!! tip "Configurazione di produzione"

    Per i deployment di produzione, fissare il tag dell'immagine a una versione specifica anziche utilizzare `latest`:

    ```yaml
    image: ghcr.io/elia/airgap-chatbot:1.2.0
    ```

    Questo previene aggiornamenti imprevisti e garantisce deployment riproducibili.

## Configurare l'ambiente

Controllare il comportamento di AirGap AI Chatbot tramite le variabili d'ambiente.

### Variabili principali

| Variabile | Predefinito | Descrizione |
|-----------|-------------|-------------|
| `NODE_ENV` | `development` | Ambiente dell'applicazione. Impostare `production` per i deployment |
| `LOG_LEVEL` | `info` | Dettaglio dei log: `debug`, `info`, `warn`, `error` |
| `PORT` | `3000` | Porta HTTP su cui l'applicazione e in ascolto |
| `MAX_UPLOAD_SIZE_MB` | `100` | Dimensione massima del caricamento file in megabyte |
| `SESSION_TIMEOUT_MINUTES` | `60` | Timeout della sessione utente in minuti |
| `ENABLE_REGISTRATION` | `true` | Consenti la registrazione autonoma dei nuovi utenti |

### Configurazione del database

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v airgap-data:/app/data \
  -e NODE_ENV=production \
  -e DATABASE_URL=sqlite:///app/data/chatbot.db \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! note "SQLite predefinito"

    Il database predefinito e SQLite, memorizzato nel volume montato. Il file del database persiste tra i riavvii del container finche il volume viene preservato.

### Configurazione TLS

Per i deployment di produzione, abilitare TLS montando i certificati:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 443:3000 \
  -v airgap-data:/app/data \
  -v /etc/ssl/certs/chatbot.pem:/app/ssl/cert.pem:ro \
  -v /etc/ssl/private/chatbot.key:/app/ssl/key.pem:ro \
  -e TLS_CERT=/app/ssl/cert.pem \
  -e TLS_KEY=/app/ssl/key.pem \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! warning "Permessi dei certificati"

    Assicurarsi che il processo Docker possa leggere i file di certificato e chiave TLS. Montarli in sola lettura (`:ro`) per evitare modifiche accidentali.

## Verificare il deployment

Dopo aver avviato AirGap AI Chatbot, verificare che tutti i componenti funzionino correttamente.

### Verificare la salute del servizio

```bash
curl -f http://localhost:3000/api/health
```

### Verificare lo stato di Docker Compose

```bash
docker compose ps
```

L'output dovrebbe mostrare il servizio `chatbot` con stato `healthy`.

### Verificare l'interfaccia web

Aprire `http://localhost:3000` nel browser. L'interfaccia di chat dovrebbe caricarsi senza errori.

!!! tip "Risoluzione dei problemi"

    Se il container non si avvia, verificare:

    - Docker ha almeno 4 GB di RAM allocati
    - La porta 3000 non e in uso da un altro processo
    - La directory del volume e scrivibile dal processo Docker
    - Le variabili d'ambiente sono formattate correttamente