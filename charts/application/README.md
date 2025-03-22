# Application Helm chart

Helm chart for general applications

## Installation

To add the `application` helm repo, run:

```sh
helm repo add apps https://fredychivalan.github.io/helm-charts
```

To install a release named `apps`, run:

```sh
helm install test-application apps/application
```
Check `values.yaml` for additional available customizations.

## Chart values

```sh
helm show values apps/application
```

