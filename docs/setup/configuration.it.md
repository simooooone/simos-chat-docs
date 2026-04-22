# Configurazione

Configurare AirGap AI Chatbot per il proprio ambiente. Questa guida illustra le variabili d'ambiente, il file di configurazione e l'applicazione delle modifiche a un'istanza in esecuzione.

--8<-- "_snippets.it/standard-disclaimer.md"

## Variabili d'ambiente

AirGap AI Chatbot legge la configurazione dalle variabili d'ambiente all'avvio. Passarle al container tramite il flag `-e`:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v ./data:/app/data \
  -e AIRGAP_LOG_LEVEL=info \
  -e AIRGAP_MAX_UPLOAD_SIZE=50 \
  ghcr.io/elia/airgap-chatbot:latest
```

Variabili d'ambiente comuni:

| Variabile | Predefinito | Descrizione |
|-----------|-------------|-------------|
| `AIRGAP_LOG_LEVEL` | `info` | Livello di verbosita dei log: `debug`, `info`, `warn`, `error` |
| `AIRGAP_MAX_UPLOAD_SIZE` | `50` | Dimensione massima del caricamento documenti in MB |
| `AIRGAP_DEFAULT_MODEL` | `default` | Modello linguistico predefinito per le conversazioni |
| `AIRGAP_ENABLE_SIGNUP` | `true` | Consenti la registrazione di nuovi utenti |

!!! note "Precedenza delle variabili d'ambiente"

    Le variabili d'ambiente hanno la precedenza sui valori nel file di configurazione. Se la stessa impostazione e definita in entrambi, la variabile d'ambiente prevale.

## File di configurazione

Per impostazioni piu dettagliate, utilizzare un file di configurazione YAML montato nel container:

```yaml
# config.yaml
server:
  host: "0.0.0.0"
  port: 3000

models:
  default: "default"
  available:
    - "default"
    - "code-optimized"

documents:
  max_upload_size_mb: 50
  supported_formats:
    - pdf
    - txt
    - md
    - csv

workspaces:
  max_members: 50
  default_quota_mb: 500
```

Montare il file all'avvio del container:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v ./data:/app/data \
  -v ./config.yaml:/app/config.yaml \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! note "Posizione del file di configurazione"

    L'applicazione cerca il file di configurazione in `/app/config.yaml` all'interno del container. Montare il proprio file esattamente in questo percorso.

!!! warning "Sintassi YAML"

    I file di configurazione utilizzano la sintassi YAML. Un'indentazione o una formattazione errata causano errori di avvio. Validare la configurazione con un lint YAML online prima del deployment.

## Applicare la configurazione

Dopo aver modificato le variabili d'ambiente o il file di configurazione, riavviare il container per applicare le modifiche:

```bash
docker restart airgap-chatbot
```

Per verificare la configurazione attiva, controllare i log di avvio:

```bash
docker logs airgap-chatbot 2>&1 | grep -i "config loaded"
```

!!! warning "Riavvio necessario"

    Le modifiche alla configurazione richiedono un riavvio del container per avere effetto. L'esecuzione di `docker restart` interrompe brevemente le conversazioni attive. Pianificare i riavvii durante le finestre di manutenzione in ambienti di produzione.

!!! note "Persistenza della configurazione"

    I file di configurazione montati come volumi persistono tra i riavvii e gli aggiornamenti del container. Le variabili d'ambiente impostate con `-e` devono essere specificate nuovamente ogni volta che si ricrea il container con `docker run`.

Per le impostazioni di workspace e progetti, vedere [Aree di lavoro](../workspaces-projects/workspaces.md) e [Progetti](../workspaces-projects/projects.md).