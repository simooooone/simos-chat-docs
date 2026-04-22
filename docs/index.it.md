# AirGap AI Chatbot - Documentazione

Benvenuti nel portale di documentazione di AirGap AI Chatbot.

!!! info "Documentazione in Costruzione"

    Questo portale di documentazione e in fase di costruzione. Il contenuto per ogni sezione sara aggiunto a breve.

## Guida Rapida

```python
# Esempio: Utilizzo dell'API di AirGap AI Chatbot
import requests

response = requests.get("https://localhost:3000/api/health")
print(response.json())
```

## Funzionalita

=== "Self-Hosted"

    Distribuzione sulla propria infrastruttura con Docker o bare metal.

=== "Air-Gapped"

    Funzionalita completa senza accesso a Internet per ambienti sicuri.

=== "RAG-Powered"

    Caricare documenti e interrogarli con generazione aumentata dal recupero.