# Usage guide

This guide covers safe installation, version pinning, template inspection, and lifecycle management for charts published in this repository (see the [Chart catalog](chart-catalog.md)).

## Before you begin

Install [Helm](https://helm.sh/docs/intro/install/) (v3.14+ or v4.x) and verify your active Kubernetes context points to the intended cluster:

```bash
kubectl config current-context
```

## Register the chart repository

Add the public repository hosted on GitHub Pages under the `apps` alias:

```bash
helm repo add apps https://fredychivalan.github.io/helm-charts
```

Synchronize your local cache to fetch newly published chart versions:

```bash
helm repo update
```

## Inspect versions and default values

Search all available versions for a chart before selecting a target release:

```bash
helm search repo apps/argocd-gitops-platform --versions
```

Display the documented default `values.yaml` bundled inside a specific chart version:

```bash
helm show values apps/argocd-gitops-platform --version 2.0.0
```

Inspect the strict `values.schema.json` contract when a chart provides schema validation:

```bash
helm show all apps/argocd-gitops-platform --version 2.0.0
```

## Preview and install

Render manifests locally with your values file before touching the cluster:

```bash
helm template argocd-gitops apps/argocd-gitops-platform --version 2.0.0 --namespace argocd --values values.yaml
```

Perform an idempotent server-side install or upgrade pinned to an explicit version:

```bash
helm upgrade --install argocd-gitops apps/argocd-gitops-platform --version 2.0.0 --namespace argocd --values values.yaml
```

> [!IMPORTANT]
> Always pass `--version` in production automation to prevent unintended upgrades when a new major chart version is published.

## Upgrade and uninstall

Review live release history and active revision numbers:

```bash
helm history argocd-gitops --namespace argocd
```

Roll back a release immediately if a configuration change triggers an unexpected reconciliation issue:

```bash
helm rollback argocd-gitops 1 --namespace argocd
```

Remove an existing release and its managed Kubernetes resources cleanly:

```bash
helm uninstall argocd-gitops --namespace argocd
```

## What's next

- Review individual configuration tables in the [argocd-gitops-platform README](../charts/argocd-gitops-platform/README.md), [aspnet README](../charts/aspnet/README.md), or [laravel README](../charts/laravel/README.md).
- Inspect how per-chart tags and releases are produced in the [Release process](release-process.md).
