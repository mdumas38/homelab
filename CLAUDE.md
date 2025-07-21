# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Kubernetes-based homelab infrastructure repository using GitOps principles with FluxCD. The repository manages personal cloud applications, infrastructure controllers, and monitoring solutions across a staging environment.

## Architecture

### GitOps Structure
- **FluxCD**: Manages the entire cluster state from Git
- **Kustomize**: Used for configuration management and overlays
- **SOPS**: Handles secret encryption with age keys
- **Git Repository**: Source of truth for all cluster configurations

### Directory Structure
```
├── apps/                    # Application deployments
│   ├── base/               # Base application configurations
│   └── staging/            # Staging environment overlays
├── clusters/               # Cluster bootstrap configurations
│   └── staging/            # Staging cluster manifests
├── infrastructure/         # Infrastructure controllers
│   ├── controllers/        # Infrastructure components
│   └── nvidia-gpu-operator/ # GPU operator for AI workloads
├── monitoring/             # Monitoring stack (Prometheus, Grafana, Headlamp)
└── local/                  # Local development tools and scripts
```

### Key Components

#### Applications Stack
The homelab runs a comprehensive media and productivity stack:
- **Media**: Plex, Jellyfin, Jellyseerr for media management
- ***Arr Stack**: Radarr, Sonarr, Prowlarr, Readarr for media automation
- **Downloads**: qBittorrent for torrenting
- **Books**: Calibre, Kavita, Audiobookshelf for book/audiobook management
- **Productivity**: Home Assistant, Open WebUI, n8n, Linkding
- **Dashboard**: Homarr for unified interface

#### Infrastructure Controllers
- **Synology CSI**: Persistent storage integration with Synology NAS
- **Renovate**: Automated dependency updates
- **NVIDIA GPU Operator**: GPU support for AI/ML workloads

#### Monitoring
- **Kube-Prometheus-Stack**: Complete monitoring solution
- **Headlamp**: Kubernetes dashboard
- **Grafana**: Visualization and alerting

### Environments
- **Base**: Common configurations shared across environments
- **Staging**: Production environment (currently the only active environment)

## Development Workflow

### Cluster Management
Since this uses GitOps, all changes should be made via Git commits. FluxCD automatically syncs changes to the cluster.

### Adding New Applications
1. Create base configuration in `apps/base/<app-name>/`
2. Create staging overlay in `apps/staging/<app-name>/`  
3. Add application to `apps/staging/kustomization.yaml`
4. Commit changes - FluxCD will deploy automatically

### Ingress and TLS
Applications use Cloudflare for external access with automatic TLS certificate management. Each staging application includes:
- Cloudflare tunnel configuration
- TLS secret management
- Ingress routing

### Secret Management
Secrets are encrypted using SOPS with age keys. The staging cluster has SOPS configured for automatic decryption during deployment.

### GPU Workloads
The cluster includes NVIDIA GPU operator for AI/ML workloads. GPU resources can be requested in pod specifications for applications requiring GPU acceleration.

## Key Files to Understand

- `clusters/staging/flux-system/gotk-sync.yaml`: FluxCD bootstrap configuration
- `clusters/staging/*.yaml`: Main cluster kustomizations for apps, infrastructure, and monitoring
- `apps/staging/kustomization.yaml`: Lists all active applications
- `infrastructure/nvidia-gpu-operator/base/helm-release.yaml`: GPU operator configuration
- `renovate.json`: Automated dependency update configuration

## Common Operations

### Viewing Cluster State
Use FluxCD CLI or Kubernetes tools to check deployment status:
```bash
flux get kustomizations
kubectl get pods -A
```

### Checking Application Status
Applications are deployed across various namespaces. Use kubectl to check specific applications:
```bash
kubectl get pods -n <namespace>
kubectl logs -n <namespace> <pod-name>
```

### Managing Secrets
Secrets are SOPS-encrypted. Use sops to edit encrypted files:
```bash
sops <encrypted-file.yaml>
```

The staging cluster automatically decrypts secrets during deployment using the configured age key.