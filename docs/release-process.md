# Release process

This document explains how this unified multi-chart repository packages, tags, and publishes independent Helm chart versions (see the [repository overview](../README.md)).

## Before you begin

Every chart under `charts/` maintains its own semantic version (`version` field in `Chart.yaml`), independent of sibling charts in the same repository.

## Independent semantic versioning

Each chart follows Semantic Versioning 2.0.0:

| Segment | When it increments | Consumer impact |
| --- | --- | --- |
| MAJOR | Breaking value schema changes, renamed helpers, or removed resource defaults | Requires reviewing changelog notes and updating consumer values before upgrading |
| MINOR | Backwards-compatible features, new optional values, or extended Kubernetes version support | Safe to adopt after reviewing new optional defaults |
| PATCH | Template bug fixes, security hardening without schema breaks, or chart metadata/docs fixes | Safe drop-in upgrade within the same minor line |

## Automated packaging and index publishing

Merging changes for a chart into `main` triggers the release workflow:

1. **Change detection:** `chart-releaser` scans `charts/` and packages only charts whose `Chart.yaml` `version` does not yet have a corresponding release tag.
2. **Scoped tag and archive:** A release tag named `<chart>-<version>` (for example `argocd-gitops-platform-2.0.0`) is created alongside its packaged `.tgz` archive under GitHub Releases.
3. **GitHub Pages index update:** The workflow regenerates `index.yaml` on the `gh-pages` branch so `helm repo update` immediately discovers the new version without affecting unchanged charts.

> [!NOTE]
> Unchanged charts under `charts/` are neither re-tagged nor re-published during sibling chart releases.

## What's next

- Pin chart versions safely using the [Usage guide](usage-guide.md).
- Review contribution requirements before opening a pull request in [Contributing guidelines](../CONTRIBUTING.md).
