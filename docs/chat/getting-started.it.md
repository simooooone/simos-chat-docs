# Per Iniziare

Iniziare la prima conversazione con AirGap AI Chatbot. Questa guida illustra l'accesso all'interfaccia, l'invio di un messaggio e il caricamento di un documento per contesto.

--8<-- "_snippets.it/prereq-docker.md"

## Accedere all'interfaccia

Aprire il browser e navigare all'interfaccia del chatbot:

```
http://localhost:3000
```

Se la porta e stata modificata durante l'[Installazione](../setup/installation.md), aggiornare l'URL di conseguenza. Ad esempio, se la porta mappata e `8080`, navigare verso `http://localhost:8080`.

Verificare che il servizio risponda con un health check:

```bash
curl -s http://localhost:3000/api/health
```

Una risposta corretta restituisce un oggetto JSON con informazioni sullo stato.

!!! tip "Salvare la pagina come segnalibro"

    Salvare l'URL del chatbot come segnalibro nel browser per un accesso rapido. L'interfaccia ricorda le conversazioni recenti nella stessa sessione del browser.

## Iniziare una conversazione

Una volta caricata l'interfaccia, il pannello della chat appare con un campo di inserimento dei messaggi nella parte inferiore.

Digitare un messaggio nel campo di inserimento e premere **Invio** o fare clic sul pulsante di invio:

```
Ciao, con cosa puoi aiutarmi?
```

Il chatbot risponde in tempo reale. Ogni conversazione viene salvata automaticamente e appare nella barra laterale con un titolo generato.

!!! note "Titoli delle conversazioni"

    I titoli vengono generati automaticamente dal primo messaggio. E' possibile rinominare una conversazione facendo clic sul titolo nella barra laterale e modificando il testo.

Per iniziare una nuova conversazione, fare clic sul pulsante **Nuova conversazione** nella barra laterale. La conversazione corrente rimane accessibile dalla cronologia della barra laterale.

## Caricare un documento

Per porre domande sui propri documenti, caricarli nel contesto della chat.

1. Fare clic sul pulsante **Allega** (icona della graffetta) accanto al campo di inserimento
2. Selezionare un file dal sistema locale
3. Il documento appare come allegato nell'area di inserimento
4. Digitare la domanda e premere **Invio**

Il chatbot elabora il documento e lo utilizza come contesto per la domanda. I formati supportati includono PDF, testo semplice, Markdown e CSV.

!!! note "Dimensione dei documenti"

    Ogni documento ha un limite massimo di dimensione definito dalla variabile di configurazione `AIRGAP_MAX_UPLOAD_SIZE` (predefinito: 50 MB). Vedere [Configurazione](../setup/configuration.md) per i dettagli.

Per ulteriori informazioni sull'utilizzo dei documenti, vedere [Caricamento](../documents-rag/uploading.md) e [Interrogazione](../documents-rag/querying.md).