# Docker

Deploy AirGap AI Chatbot with Docker and Docker Compose for containerized, reproducible installations.

--8<-- "_snippets/prereq-docker.md"

## Deploy with Docker

Run AirGap AI Chatbot as a single Docker container with the minimum required configuration.

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v airgap-data:/app/data \
  -e NODE_ENV=production \
  -e LOG_LEVEL=info \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! warning "Resource Requirements"

    The container requires at least 4 GB of RAM. Assign 2 CPU cores and 4 GB of memory to Docker for optimal performance:

    ```bash
    docker update --memory 4g --cpus 2 airgap-chatbot
    ```

### Verify the Container

After starting the container, confirm it is running:

```bash
docker ps --filter name=airgap-chatbot
```

Check the application health endpoint:

```bash
curl -s http://localhost:3000/api/health | head -1
```

A successful response returns:

```json
{ "status": "ok" }
```

!!! tip "View Container Logs"

    Monitor the container logs to troubleshoot startup issues:

    ```bash
    docker logs -f airgap-chatbot
    ```

## Deploy with Docker Compose

Docker Compose simplifies multi-container deployments and makes configuration reproducible across environments.

Create a `docker-compose.yml` file:

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

Start the deployment:

```bash
docker compose up -d
```

!!! tip "Production Configuration"

    For production deployments, pin the image tag to a specific version instead of using `latest`:

    ```yaml
    image: ghcr.io/elia/airgap-chatbot:1.2.0
    ```

    This prevents unexpected upgrades and ensures reproducible deployments.

## Configure Environment

Control AirGap AI Chatbot behavior through environment variables.

### Core Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `development` | Application environment. Set to `production` for deployments |
| `LOG_LEVEL` | `info` | Logging verbosity: `debug`, `info`, `warn`, `error` |
| `PORT` | `3000` | HTTP port the application listens on |
| `MAX_UPLOAD_SIZE_MB` | `100` | Maximum file upload size in megabytes |
| `SESSION_TIMEOUT_MINUTES` | `60` | User session timeout in minutes |
| `ENABLE_REGISTRATION` | `true` | Allow new user self-registration |

### Database Configuration

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v airgap-data:/app/data \
  -e NODE_ENV=production \
  -e DATABASE_URL=sqlite:///app/data/chatbot.db \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! note "SQLite Default"

    The default database is SQLite, stored in the mounted volume. The database file persists across container restarts as long as the volume is preserved.

### TLS Configuration

For production deployments, enable TLS by mounting certificates:

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

!!! warning "Certificate Permissions"

    Ensure the Docker process can read the TLS certificate and key files. Mount them as read-only (`:ro`) to prevent accidental modification.

## Verify Deployment

After starting AirGap AI Chatbot, verify that all components are functioning correctly.

### Check Service Health

```bash
curl -f http://localhost:3000/api/health
```

### Check Docker Compose Status

```bash
docker compose ps
```

The output should show the `chatbot` service with a status of `healthy`.

### Test the Web Interface

Open `http://localhost:3000` in a browser. The chat interface should load without errors.

!!! tip "Troubleshooting"

    If the container fails to start, check the following:

    - Docker has at least 4 GB of RAM allocated
    - Port 3000 is not in use by another process
    - The volume directory is writable by the Docker process
    - Environment variables are correctly formatted