# Changelog

## [1.1.0] - 2025-04-21
### Added
- Better explanation in the documentation

### Changed
- Resource names (`deployment`, `hpa`, `pdb`, `ingress`, etc.) use the value of the **"InstanceName"** parameter if the `nameOverride` and `fullnameOverride` parameters are empty.
- The selectorLabels function in `app.kubernetes.io/name:` ​​receives the value of the **"instanceName"** parameter.

---

## [0.1.1] - 2025-04-10
### Added
- Add `podDisruptionBudgetSpec` function.
- Adds `horizontalPodAutoscalerSpec` configuration.
- The `Container` function uses all the options available in the official [documentation](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/#container-v1-core).
- Add a `podSpec` function, overriding the `containers` and `initContainers` configurations.
- Add `deploymentSpec` function.
- Add `metadata` functions (annotations, labels, name, and namespace) and receive values ​​via parameters.
- Functions use **"context"**, **"global"**, **"instanceName"** and **"instance"** parameters to receive dynamic values.