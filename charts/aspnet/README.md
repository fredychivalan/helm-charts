# ASP.NET Helm chart

Helm chart for Laravel applications

## Installation

To add the `aspnet` helm repo, run:

```sh
helm repo add apps https:///fredychivalan.github.io/helm-charts
```

To install a release named `apps`, run:

```sh
helm install aspnet apps/aspnet
```
Check `values.yaml` for additional available customizations.

## Chart values

```sh
helm show values apps/aspnet
```

