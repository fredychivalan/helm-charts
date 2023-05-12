# Laravel Helm chart

Helm chart for Laravel applications

## Installation

To add the `laravel` helm repo, run:

```sh
helm repo add apps https:///fredychivalan.github.io/helm-charts
```

To install a release named `apps`, run:

```sh
helm install laravel apps/laravel
```
Check `values.yaml` for additional available customizations.

## Chart values

```sh
helm show values apps/laravel
```

