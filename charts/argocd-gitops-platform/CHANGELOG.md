# Changelog

All notable changes to the **argocd-gitops-platform** Helm chart are documented in this file.

## [2.0.0]

### Added
- Declarative Argo CD GitOps platform orchestration (`AppProject` and `ApplicationSet` Matrix Generators: `clusters` × `git`).
- Support for multi-source Helm workloads (`appsetsHelm` with `$values` reference) and Kustomize overlays, components, and patches (`appsetsKustomize`).
- Strict closed-world Draft-07 `values.schema.json` validation rejecting empty cluster selectors, ambiguous destinations, and unknown keys.
- Explicit governance policy (`global.allowDefaultProject`, defaulting to `false`) and deduplicated `syncOptions` merging.

### Compatibility
- **Kubernetes (`kubeVersion`):** `>=1.35.0-0 <1.38.0-0` (validated against `1.35.11`, `1.36.7`, `1.37.3`)
- **Argo CD CRDs:** `v3.6.3` (`argoproj.io/v1alpha1`)
