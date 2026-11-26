# Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release](https://github.com/fredychivalan/helm-charts/actions/workflows/release.yml/badge.svg)](https://github.com/fredychivalan/helm-charts/actions/workflows/release.yml)
[![Releases downloads](https://img.shields.io/github/downloads/fredychivalan/helm-charts/total.svg)](https://github.com/fredychivalan/helm-charts/releases)

This repository publishes production Helm charts as independent, semantically versioned packages from a single source repository and serves their index through GitHub Pages.

## Before you begin

Install [Helm](https://helm.sh/docs/intro/install/) (v3.14+ or v4.x) and verify access to your target Kubernetes cluster with `kubectl`.

## Available charts

Each chart is packaged and tagged independently (`<chart>-<version>`) so upgrades to one chart never impact consumers of another chart.

| Chart | Version | App version | Kubernetes range | Status | Documentation |
| --- | --- | --- | --- | --- | --- |
| **argocd-gitops-platform** | 2.0.0 | 3.6.3 | >=1.35.0-0 <1.38.0-0 | *Active* | [argocd-gitops-platform README](https://github.com/fredychivalan/helm-charts/blob/main/charts/argocd-gitops-platform/README.md) |
| **aspnet** | 1.1.6 | 1.3.0 | >=1.20.0-0 | *Active* | [aspnet README](https://github.com/fredychivalan/helm-charts/blob/main/charts/aspnet/README.md) |
| **laravel** | 1.2.8 | 1.6 | >=1.20.0-0 | *Active* | [laravel README](https://github.com/fredychivalan/helm-charts/blob/main/charts/laravel/README.md) |

## Quick start

Add the Helm chart repository:

```bash
helm repo add apps https://fredychivalan.github.io/helm-charts
```

Refresh your local repository cache:

```bash
helm repo update
```

List all available charts and published versions:

```bash
helm search repo apps --versions
```

Install a chart with an explicit release name and values file (for example **argocd-gitops-platform**):

```bash
helm upgrade --install argocd-gitops apps/argocd-gitops-platform --namespace argocd --values values.yaml
```

## Documentation

<!-- Keep full GitHub URLs in root README.md because release automation mirrors this file to gh-pages. -->

| Document | Coverage |
| --- | --- |
| [Chart catalog](https://github.com/fredychivalan/helm-charts/blob/main/docs/chart-catalog.md) | Full inventory, capability highlights, and compatibility matrix across active and archived charts |
| [Usage guide](https://github.com/fredychivalan/helm-charts/blob/main/docs/usage-guide.md) | Version pinning, dry-run rendering, values inspection, upgrades, and cleanup commands |
| [Release process](https://github.com/fredychivalan/helm-charts/blob/main/docs/release-process.md) | Independent per-chart semantic versioning, GitHub Releases, and index publishing |
| [Contributing guidelines](https://github.com/fredychivalan/helm-charts/blob/main/CONTRIBUTING.md) | Chart authoring checks, required SemVer rules, and pull request workflow |
| [Security policy](https://github.com/fredychivalan/helm-charts/blob/main/SECURITY.md) | Vulnerability disclosure channel, response targets, and supported versions |
| [Apache 2.0 License](https://github.com/fredychivalan/helm-charts/blob/main/LICENSE) | Open-source licensing terms |

## What's next

- Browse compatibility ranges and feature highlights in the [Chart catalog](https://github.com/fredychivalan/helm-charts/blob/main/docs/chart-catalog.md).
- Pin versions safely and preview rendered manifests using the [Usage guide](https://github.com/fredychivalan/helm-charts/blob/main/docs/usage-guide.md).
