# Configuration

Configure AirGap AI Chatbot for your environment. This guide covers environment variables, the configuration file, and applying changes to a running instance.

--8<-- "_snippets/standard-disclaimer.md"

## Environment Variables

AirGap AI Chatbot reads configuration from environment variables at startup. Pass them to the container using the `-e` flag:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v ./data:/app/data \
  -e AIRGAP_LOG_LEVEL=info \
  -e AIRGAP_MAX_UPLOAD_SIZE=50 \
  ghcr.io/elia/airgap-chatbot:latest
```

Common environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `AIRGAP_LOG_LEVEL` | `info` | Logging verbosity: `debug`, `info`, `warn`, `error` |
| `AIRGAP_MAX_UPLOAD_SIZE` | `50` | Maximum document upload size in MB |
| `AIRGAP_DEFAULT_MODEL` | `default` | Default language model for conversations |
| `AIRGAP_ENABLE_SIGNUP` | `true` | Allow new user registration |

!!! note "Environment variable precedence"

    Environment variables take precedence over values in the configuration file. If the same setting is defined in both places, the environment variable wins.

## Configuration File

For more detailed settings, use a YAML configuration file mounted into the container:

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

Mount the file when starting the container:

```bash
docker run -d \
  --name airgap-chatbot \
  -p 3000:3000 \
  -v ./data:/app/data \
  -v ./config.yaml:/app/config.yaml \
  ghcr.io/elia/airgap-chatbot:latest
```

!!! note "Configuration file location"

    The application expects the configuration file at `/app/config.yaml` inside the container. Mount your file to this exact path.

!!! warning "YAML syntax"

    Configuration files use YAML syntax. Incorrect indentation or formatting causes startup errors. Validate your configuration with an online YAML linter before deploying.

## Apply Configuration

After modifying environment variables or the configuration file, restart the container to apply changes:

```bash
docker restart airgap-chatbot
```

To verify the active configuration, check the startup logs:

```bash
docker logs airgap-chatbot 2>&1 | grep -i "config loaded"
```

!!! warning "Restart required"

    Configuration changes require a container restart to take effect. Running `docker restart` briefly interrupts active conversations. Schedule restarts during maintenance windows in production environments.

!!! note "Persisting configuration"

    Configuration files mounted as volumes persist across container restarts and updates. Environment variables set with `-e` must be re-specified each time you recreate the container with `docker run`.

For workspace and project settings, see [Workspaces](../workspaces-projects/workspaces.md) and [Projects](../workspaces-projects/projects.md).