# Chart catalog

This catalog summarizes all actively maintained Helm charts published from this repository, alongside archived packages retained in the GitHub Pages history (see the [repository overview](../README.md)).

## Before you begin

Refresh the local Helm repository index before inspecting available versions:

```bash
helm repo update
```

## Active charts

| Chart | Latest version | App version | Summary | Documentation |
| --- | --- | --- | --- | --- |
| **argocd-gitops-platform** | 2.0.0 | 3.6.3 | Declarative Argo CD `AppProject` and `ApplicationSet` Matrix Generator orchestration for Helm multi-source and Kustomize with closed-world Draft-07 schema validation | [README](../charts/argocd-gitops-platform/README.md) · [CHANGELOG](../charts/argocd-gitops-platform/CHANGELOG.md) |
| **aspnet** | 1.1.6 | 1.3.0 | Opinionated workload chart for containerized ASP.NET services with `Deployment`, `Service`, `Ingress`, `HPA`, `ServiceAccount`, and `extraObjects` support | [README](../charts/aspnet/README.md) |
| **laravel** | 1.2.8 | 1.6 | Production chart for Laravel PHP-FPM and NGINX workloads with runtime configuration `ConfigMap`s, `PDB`, `HPA`, and `Ingress` | [README](../charts/laravel/README.md) |

## Highlighted capabilities of argocd-gitops-platform

**argocd-gitops-platform** enforces strict Zero-Trust GitOps guardrails at both schema and template render time:

- **Strict closed-world `values.schema.json`:** Rejects unknown keys (`additionalProperties: false`), empty `clusters` selectors (`anyOf`), non-kebab-case application keys, and simultaneous `destination.server` / `destination.name` declarations.
- **Multi-source Helm and Kustomize support:** Pairs `$values` Git reference resolution for Helm workloads with native Kustomize `overlays`, `components`, and `patches` orchestration.
- **Additive `syncPolicy` merging:** Combines global and tenant `syncOptions` as a deduplicated union so `ServerSideApply=true` never drops baseline `CreateNamespace=true` or `PruneLast=true` flags.
- **Governance by default:** `global.allowDefaultProject` defaults to false, blocking unrestricted Argo CD `default` project usage unless explicitly enabled.

## Archived index history

Older packaged releases (`application` up to 1.1.1 and `base` up to 1.1.0) remain downloadable from the published repository index so existing deployments do not break, while active source development focuses on the charts listed above.

> [!NOTE]
> Pin explicit `--version` flags in CI/CD pipelines and GitOps declarations so unscheduled major releases never introduce breaking schema changes.

## What's next

- Follow step-by-step installation and upgrade workflows in the [Usage guide](usage-guide.md).
- Understand per-chart GitHub Releases and `index.yaml` generation in the [Release process](release-process.md).
