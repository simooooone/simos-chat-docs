# Air-Gap Setup

Deploy AirGap AI Chatbot in air-gapped environments where internet access is restricted or unavailable. This guide covers preparing assets, transferring them to the isolated network, and verifying offline functionality.

--8<-- "_snippets/standard-disclaimer.md"

## Prepare Assets

Before transferring to the air-gapped network, build the offline distribution package on a machine with internet access.

### Build the Offline Package

```bash
./build-offline.sh
```

This script downloads all dependencies, builds the static site, and creates a compressed archive in the project root.

!!! tip "Verify the Archive"

    After the build completes, verify the archive exists and check its size:

    ```bash
    ls -lh airgap-chatbot-offline-*.tar.gz
    ```

    The archive should contain all HTML, CSS, JavaScript, and font files needed for offline operation.

### Prepare the Docker Image

Export the Docker image for transfer to the air-gapped network:

```bash
docker pull ghcr.io/elia/airgap-chatbot:1.2.0
docker save ghcr.io/elia/airgap-chatbot:1.2.0 -o airgap-chatbot-image.tar
```

!!! warning "Image Size"

    The Docker image tar file can be several hundred megabytes. Ensure your transfer medium has sufficient capacity.

## Transfer to Air-Gapped Network

Move the offline assets to the isolated environment using a secure transfer method.

### Physical Media Transfer

Copy both files to removable storage:

```bash
cp airgap-chatbot-offline-*.tar.gz /media/usb/
cp airgap-chatbot-image.tar /media/usb/
```

!!! danger "Media Sanitization"

    Sanitize all transfer media before and after use. Malware on USB devices can compromise air-gapped networks. Use media that has been verified clean and labeled for air-gap transfers only.

### Network Transfer

If a secure one-way data diode is available:

```bash
scp airgap-chatbot-offline-*.tar.gz airgap-chatbot-image.tar user@isolated-host:/opt/airgap/
```

!!! tip "Checksum Verification"

    Generate checksums on the source machine and verify them on the destination:

    ```bash
    sha256sum airgap-chatbot-offline-*.tar.gz airgap-chatbot-image.tar > checksums.txt
    ```

    On the air-gapped machine:

    ```bash
    sha256sum -c checksums.txt
    ```

## Install Offline

Load the Docker image and extract the documentation archive on the air-gapped machine.

### Load the Docker Image

```bash
docker load -i airgap-chatbot-image.tar
```

### Extract the Documentation Archive

```bash
tar -xzf airgap-chatbot-offline-*.tar.gz
```

!!! warning "Disk Space"

    Ensure the target machine has at least 2 GB of free disk space for the extracted files and Docker image.

## Configure for Offline Operation

Configure AirGap AI Chatbot for fully offline operation with no external network dependencies.

### Environment Variables

Set the following environment variables to disable external features:

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

!!! danger "Network Dependencies"

    Setting `OFFLINE_MODE=true` disables all external network calls. Verify that no features in your deployment require internet access before enabling this mode. Features like external font loading, update checks, and telemetry are disabled in offline mode.

### Offline Build Configuration

For the documentation site, use the offline build mode:

```bash
BUILD=offline mkdocs build
```

This generates a self-contained site with all assets embedded, suitable for hosting on the air-gapped network.

## Verify Offline Functionality

Confirm that the deployment operates correctly without any internet connectivity.

### Verify the Application

```bash
docker ps --filter name=airgap-chatbot
curl -s http://localhost:3000/api/health
```

### Verify the Documentation Site

Open the locally-hosted documentation in a browser on the air-gapped network. All pages, styles, and fonts must render without external requests.

### Verify No External Calls

Monitor the network to confirm no outbound connections:

```bash
docker exec airgap-chatbot netstat -tun | grep ESTABLISHED
```

!!! tip "Comprehensive Testing"

    Test all critical workflows in the air-gapped environment:

    - User login and RBAC permissions
    - Document upload and RAG queries
    - Workspace and project management
    - API key generation and authentication

    Any workflow that depends on an external service must be confirmed as disabled or replaced with an offline alternative.

For regulatory compliance considerations in air-gapped environments, see [Compliance](compliance.md).