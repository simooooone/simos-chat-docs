# Overview

AirGap AI Chatbot is designed with security as a foundational principle. This page describes the security architecture, data handling practices, threat model, and network security considerations that protect your data and deployment.

--8<-- "_snippets/standard-disclaimer.md"

## Security Architecture

AirGap AI Chatbot follows a defense-in-depth architecture with multiple security layers protecting user data and system integrity.

The application runs as a self-hosted single-container service with no external dependencies by default. All data processing occurs within the deployment boundary, and no user data is transmitted to external services unless explicitly configured.

!!! note "Component Isolation"

    Each major component (API server, document processor, RAG engine) operates within the same container but communicates through internal APIs with input validation and rate limiting. This separation prevents lateral movement within the application.

Key architectural principles:

- **Self-hosted deployment** -- All data stays on your infrastructure
- **No phone-home** -- Telemetry and update checks are disabled in offline mode
- **Least privilege** -- RBAC controls access at the workspace level
- **Input validation** -- All API inputs are validated and sanitized before processing

## Data Handling

Understanding how AirGap AI Chatbot handles data is critical for security planning.

### Data at Rest

Uploaded documents and conversation data are stored in the configured database (SQLite by default). The database file resides in the mounted data volume and is protected by the host operating system's file permissions.

!!! note "Volume Encryption"

    For production deployments, use encrypted volumes or full-disk encryption on the host to protect data at rest. The application does not implement its own encryption layer for stored data.

### Data in Transit

All API communication should use TLS in production. The application supports TLS termination via mounted certificates or through a reverse proxy.

- **Internal communication** -- Service-to-service calls within the container use HTTP on localhost
- **External communication** -- Client-to-server communication should use HTTPS
- **Document processing** -- Uploaded documents are processed in-memory and not written to temporary disk locations

### Data Retention

Conversation history and uploaded documents persist until explicitly deleted through the API or administration interface. There is no automatic data expiration policy.

!!! warning "Backup Security"

    Database backups contain all user data, including document content. Treat backups with the same security controls as the production database. Encrypt backups and restrict access to authorized personnel only.

## Threat Model

AirGap AI Chatbot's threat model identifies the primary risks and mitigations for self-hosted deployments.

### Trust Boundaries

| Boundary | Description | Mitigation |
|----------|-------------|------------|
| Client to API | Untrusted input from web browsers and API clients | Input validation, rate limiting, RBAC |
| API to Database | Trusted internal communication | Localhost-only binding, volume permissions |
| Container to Host | Container escape risk | Minimal container privileges, read-only mounts where possible |
| Air-gapped network | No external connectivity | `OFFLINE_MODE=true` disables all external calls |

### Attack Vectors

- **Injection attacks** -- All user inputs are validated and sanitized. Document uploads are processed in a sandboxed environment.
- **Authentication bypass** -- API keys are required for all endpoints. Keys are hashed at rest and never logged.
- **Data exfiltration** -- In air-gapped mode, all external network calls are disabled. Document content is not included in logs.
- **Privilege escalation** -- RBAC enforces workspace-level access control. Admin-level operations require explicit role assignment.

!!! warning "Shared Infrastructure"

    When deploying on shared infrastructure, ensure that the data volume is not accessible to other containers or users. Use Docker volumes or bind mounts with restricted permissions.

## Network Security

AirGap AI Chatbot is designed to operate in network-restricted environments.

### Network Configuration

- The application listens on a single HTTP port (default 3000)
- All internal services communicate over localhost
- No outbound connections are required for core functionality
- In offline mode, all outbound connections are blocked

### TLS Configuration

For production deployments, enable TLS either directly in the container or through a reverse proxy:

- **Container TLS** -- Mount certificates and set `TLS_CERT` and `TLS_KEY` environment variables
- **Reverse proxy TLS** -- Terminate TLS at a reverse proxy (nginx, Caddy, Traefik) and forward to the container over localhost

!!! note "Reverse Proxy Benefits"

    Using a reverse proxy provides TLS termination, request logging, and additional rate limiting. See [Docker](../deployment/docker.md) for deployment examples with TLS configuration.

For regulatory requirements and audit logging, see [Compliance](compliance.md).