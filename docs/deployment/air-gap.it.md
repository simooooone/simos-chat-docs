# Configurazione Air-Gap

Distribuire AirGap AI Chatbot in ambienti isolati (air-gapped) dove l'accesso a Internet e limitato o non disponibile. Questa guida illustra la preparazione degli asset, il trasferimento alla rete isolata e la verifica della funzionalita offline.

--8<-- "_snippets.it/standard-disclaimer.md"

## Preparare gli asset

Prima di trasferire alla rete air-gap, creare il pacchetto di distribuzione offline su una macchina con accesso a Internet.

### Creare il pacchetto offline

```bash
./build-offline.sh
```

Questo script scarica tutte le dipendenze, compila il sito statico e crea un archivio compresso nella radice del progetto.

!!! tip "Verificare l'archivio"

    Dopo il completamento della compilazione, verificare che l'archivio esista e controllarne le dimensioni:

    ```bash
    ls -lh airgap-chatbot-offline-*.tar.gz
    ```

    L'archivio dovrebbe contenere tutti i file HTML, CSS, JavaScript e font necessari per il funzionamento offline.

### Preparare l'immagine Docker

Esportare l'immagine Docker per il trasferimento alla rete air-gap:

```bash
docker pull ghcr.io/elia/airgap-chatbot:1.2.0
docker save ghcr.io/elia/airgap-chatbot:1.2.0 -o airgap-chatbot-image.tar
```

!!! warning "Dimensione dell'immagine"

    Il file tar dell'immagine Docker puo essere di diverse centinaia di megabyte. Assicurarsi che il supporto di trasferimento abbia capacita sufficiente.

## Trasferire alla rete air-gap

Spostare gli asset offline nell'ambiente isolato utilizzando un metodo di trasferimento sicuro.

### Trasferimento tramite supporto fisico

Copiare entrambi i file su un supporto rimovibile:

```bash
cp airgap-chatbot-offline-*.tar.gz /media/usb/
cp airgap-chatbot-image.tar /media/usb/
```

!!! danger "Sanitizzazione dei supporti"

    Sanitizzare tutti i supporti di trasferimento prima e dopo l'uso. I malware sui dispositivi USB possono compromettere le reti air-gap. Utilizzare supporti verificati come puliti ed etichettati esclusivamente per i trasferimenti air-gap.

### Trasferimento tramite rete

Se disponibile un diodo dati sicuro unidirezionale:

```bash
scp airgap-chatbot-offline-*.tar.gz airgap-chatbot-image.tar user@isolated-host:/opt/airgap/
```

!!! tip "Verifica dei checksum"

    Generare i checksum sulla macchina sorgente e verificarli sulla destinazione:

    ```bash
    sha256sum airgap-chatbot-offline-*.tar.gz airgap-chatbot-image.tar > checksums.txt
    ```

    Sulla macchina air-gap:

    ```bash
    sha256sum -c checksums.txt
    ```

## Installare offline

Caricare l'immagine Docker ed estrarre l'archivio della documentazione sulla macchina air-gap.

### Caricare l'immagine Docker

```bash
docker load -i airgap-chatbot-image.tar
```

### Estrarre l'archivio della documentazione

```bash
tar -xzf airgap-chatbot-offline-*.tar.gz
```

!!! warning "Spazio su disco"

    Assicurarsi che la macchina di destinazione abbia almeno 2 GB di spazio libero su disco per i file estratti e l'immagine Docker.

## Configurare per il funzionamento offline

Configurare AirGap AI Chatbot per il funzionamento completamente offline senza dipendenze di rete esterne.

### Variabili d'ambiente

Impostare le seguenti variabili d'ambiente per disabilitare le funzionalita esterne:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v airgap-data:/app/data \
  -e NODE_ENV=production \
  -e OFFLINE_MODE=true \
  -e DISABLE_TELEMETRY=true \
  -e DISABLE_UPDATES=true \
  -e FONT_STRATEGY=local \
  ghcr.io/elia/airgap-chatbot:1.2.0
```

!!! danger "Dipendenze di rete"

    L'impostazione `OFFLINE_MODE=true` disabilita tutte le chiamate di rete esterne. Verificare che nessuna funzionalita del proprio deployment richieda accesso a Internet prima di abilitare questa modalita. Funzionalita come il caricamento di font esterni, i controlli di aggiornamento e la telemetria sono disabilitate in modalita offline.

### Configurazione della build offline

Per il sito di documentazione, utilizzare la modalita di build offline:

```bash
BUILD=offline mkdocs build
```

Questo genera un sito autonomo con tutti gli asset incorporati, adatto per l'hosting sulla rete air-gap.

## Verificare la funzionalita offline

Confermare che il deployment funzioni correttamente senza connettivita Internet.

### Verificare l'applicazione

```bash
docker ps --filter name=airgap-chatbot
curl -s http://localhost:3000/api/health
```

### Verificare il sito di documentazione

Aprire la documentazione ospitata localmente nel browser sulla rete air-gap. Tutte le pagine, gli stili e i font devono essere renderizzati senza richieste esterne.

### Verificare l'assenza di chiamate esterne

Monitorare la rete per confermare l'assenza di connessioni in uscita:

```bash
docker exec airgap-chatbot netstat -tun | grep ESTABLISHED
```

!!! tip "Test completo"

    Testare tutti i flussi di lavoro critici nell'ambiente air-gap:

    - Accesso utente e autorizzazioni RBAC
    - Caricamento documenti e query RAG
    - Gestione workspace e progetti
    - Generazione chiavi API e autenticazione

    Qualsiasi flusso di lavoro che dipende da un servizio esterno deve essere confermato come disabilitato o sostituito con un'alternativa offline.

Per considerazioni sulla conformita normativa negli ambienti air-gap, vedere [Conformita](compliance.md).