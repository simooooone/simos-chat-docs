# AirGap AI Chatbot - Documentazione

AirGap AI Chatbot e un workspace di chat AI enterprise-grade, self-hosted, con
funzionalita RAG (Retrieval-Augmented Generation), progettato per ambienti
air-gapped in cui l'accesso a Internet e limitato o non disponibile. Esecuzione
sulla propria infrastruttura, controllo completo dei dati e interrogazione dei
documenti con intelligenza AI.

--8<-- "_snippets.it/prereq-docker.md"

## Guida Rapida

!!! tip "Inizia in meno di un minuto"

    Scaricare ed eseguire il container AirGap AI Chatbot con Docker:

    ```bash
    docker pull ghcr.io/elia/airgap-chatbot:latest
    docker run -d -p 3000:3000 \
      -v ./data:/app/data \
      ghcr.io/elia/airgap-chatbot:latest
    ```

    Aprire `http://localhost:3000` nel browser per accedere all'interfaccia di chat.

## Funzionalita

**Distribuzione self-hosted** -- Distribuire AirGap AI Chatbot sulla propria
infrastruttura con Docker o bare metal. Nessuna dipendenza esterna, nessun
servizio cloud e nessun dato esce dalla rete. La configurazione e immediata con
variabili d'ambiente e Docker Compose.

**Funzionamento air-gapped** -- Eseguire l'applicazione completa in ambienti
senza accesso a Internet. Tutti i modelli, gli embeddings e l'elaborazione dei
documenti avvengono on-premises. Aggiornamenti e upgrade dei modelli possono
essere trasferiti tramite pacchetti offline, mantenendo la distribuzione
completamente scollegata da reti esterne.

**Intelligenza documentale basata su RAG** -- Caricare PDF, file di testo e
altri documenti nel proprio workspace, quindi porre domande sul loro contenuto.
La pipeline di generazione aumentata dal recupero indicizza i documenti e li
utilizza come contesto per le risposte AI, fornendo risposte fondate sui dati
propri.

**Organizzazione basata su workspace** -- Organizzare conversazioni, documenti e
membri del team in workspace e progetti. Condividere il contesto tra i membri
del team mantenendo confini chiari tra progetti e dipartimenti.

## Sezioni della Documentazione

- **[Installazione e configurazione](setup/index.md)** -- Installare e
  configurare AirGap AI Chatbot per il proprio ambiente
- **[Chat](chat/index.md)** -- Imparare a usare l'interfaccia di chat, dalla
  prima conversazione alle funzionalita avanzate
- **[Documenti e RAG](documents-rag/index.md)** -- Caricare documenti e
  interrogarli con la generazione aumentata dal recupero
- **[Aree di lavoro e Progetti](workspaces-projects/index.md)** -- Organizzare
  conversazioni e collaborare con il team
- **[Amministrazione](administration/index.md)** -- Gestire utenti, ruoli e
  impostazioni di sistema
- **[API](api/index.md)** -- Integrare con l'interfaccia programmatica
- **[Distribuzione](deployment/index.md)** -- Distribuire con Docker o
  configurare un'installazione air-gapped
- **[Sicurezza](security/index.md)** -- Comprendere l'architettura di
  sicurezza, il modello di minacce e le funzionalita di conformita