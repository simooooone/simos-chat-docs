# Installation

Install AirGap AI Chatbot on your infrastructure using Docker. This guide walks you through pulling the container image, running it, and verifying that the application is up and running.

--8<-- "_snippets/prereq-docker.md"

## Pull the Image

Pull the latest AirGap AI Chatbot container image from the GitHub Container Registry:

```bash
docker pull ghcr.io/elia/airgap-chatbot:latest
```

!!! note "Specific versions"

    Replace `latest` with a version tag (for example, `v1.2.0`) to pin a specific release. Check the [GitHub releases page](https://github.com/elia/simos-chat-docs/releases) for available tags.

## Run the Container

Start the chatbot container with the default configuration:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v ./data:/app/data \
  ghcr.io/elia/airgap-chatbot:latest
```

The command above:

- Runs the container in detached mode (`-d`)
- Names the container `airgap-chatbot` for easy management
- Maps port `3000` on the host to port `3000` in the container
- Mounts the `./data` directory for persistent storage

!!! warning "Resource requirements"

    Ensure your system has at least 4 GB of RAM available for the container. The chatbot loads language models into memory at startup and requires sufficient resources to function correctly.

!!! warning "Data persistence"

    Always mount a volume to `/app/data`. Without a volume mount, all conversations, uploaded documents, and workspace settings are lost when the container is removed.

## Verify the Installation

After the container starts, confirm that AirGap AI Chatbot is running:

```bash
docker ps --filter name=airgap-chatbot
```

You can also check the health endpoint:

```bash
curl -s http://localhost:3000/api/health | head -1
```

!!! tip "First access"

    Open [http://localhost:3000](http://localhost:3000) in your browser to access the chatbot interface. If the page does not load, check the container logs with `docker logs airgap-chatbot`.

To stop the container, run:

```bash
docker stop airgap-chatbot
```

To remove the container entirely:

```bash
docker rm -f airgap-chatbot
```

Once installation is verified, proceed to [Configuration](configuration.md) to customize settings for your environment.