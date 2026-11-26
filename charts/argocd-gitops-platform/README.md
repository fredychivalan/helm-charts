# argocd-gitops-platform

Helm chart for declarative Argo CD GitOps platform orchestration (AppProject, ApplicationSet Matrix Generators for Helm multi-source and Kustomize, and workload governance). Configure dedicated `AppProject` resources alongside Helm multi-source and Kustomize `ApplicationSet` matrices from a single schema-validated values file.

## Before you begin

Verify that your target Kubernetes cluster and Argo CD installation match the locked compatibility matrix before installing this chart.

| Component | Supported value |
| --- | --- |
| Chart | **argocd-gitops-platform** 2.0.0 |
| Argo CD CRDs | 3.6.3 (argoproj.io/v1alpha1) |
| Kubernetes | >=1.35.0-0 <1.38.0-0 |
| Helm CLI | v3.14+ / v4.x |

## Installation

Add the public Helm repository to your local Helm client:

```bash
helm repo add apps https://fredychivalan.github.io/helm-charts
```

Refresh the local repository index:

```bash
helm repo update
```

Install or upgrade the chart with an explicit values file:

```bash
helm upgrade --install argocd-gitops apps/argocd-gitops-platform --namespace argocd --values values.yaml
```

Render manifests locally to inspect generated resources before applying:

```bash
helm template argocd-gitops apps/argocd-gitops-platform --namespace argocd --values values.yaml
```

## Configuration examples

### Multi-source Helm ApplicationSets

Pair a non-empty `clusters` selector with Git file discovery so each workload reads global defaults and tenant overrides through `$values/`:

```yaml
appsetsHelm:
  example-helm-workloads:
    applicationNameTemplate: '{{ .metadata.labels.environment }}-{{ .path.basename
      }}'
    destination:
      namespace: '{{ .metadata.labels.environment }}'
      server: '{{ .server }}'
    enabled: true
    generators:
      matrix:
        clusters:
          matchLabels:
            cluster-tier: workload
        git:
          files:
          - apps/helm/*/helm-config.yaml
          repoURL: https://git.example.com/platform/applications.git
          targetRevision: main
    targetSourceOverride:
      helm:
        valueFiles:
        - '{{ .path.path }}/{{ .metadata.labels.environment }}.yaml'
```

### Kustomize overlays, components, and patches

Combine directory or file discovery with Kustomize `components`, `patches`, and additive `syncOptions`:

```yaml
appsetsKustomize:
  example-kustomize-workloads:
    applicationNameTemplate: '{{ .metadata.labels.environment }}-{{ .path.basename
      }}'
    destination:
      namespace: '{{ .metadata.labels.environment }}'
      server: '{{ .server }}'
    enabled: true
    generators:
      matrix:
        clusters:
          matchLabels:
            cluster-tier: workload
        git:
          directories:
          - apps/kustomize/*/overlays/*
          repoURL: https://git.example.com/platform/applications.git
          targetRevision: main
    syncPolicy:
      syncOptions:
      - ServerSideApply=true
    targetSourceOverride:
      kustomize:
        components:
        - ../../components/hardening
        patches:
        - patch: |
            - op: replace
              path: /spec/revisionHistoryLimit
              value: 3
          target:
            group: apps
            kind: Deployment
            version: v1
```

> [!IMPORTANT]
> By default, `global.allowDefaultProject` is false, empty `clusters` selectors are rejected by `values.schema.json`, and tenant `syncOptions` merge as a deduplicated union with global options so `CreateNamespace=true` is preserved when adding `ServerSideApply=true`.

## Values reference

All keys are validated by a closed-world Draft-07 `values.schema.json` (`additionalProperties: false`). Keys referencing shared nested structures link to [Shared structures](#shared-structures).

### Global settings

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `argoNamespace` | *string* | *Optional* | argocd | Namespace where the Argo CD controller runs. |
| `defaultProject` | *string* | *Required* | platform-apps | Default Argo CD AppProject inherited when an ApplicationSet omits project. |
| `allowDefaultProject` | *boolean* | *Optional* | false | Explicitly allows using the unrestricted Argo CD 'default' project. |
| `finalizers` | *string[]* | *Optional* | — | Kubernetes finalizers applied to metadata.finalizers on generated Applications. |
| `revisionHistoryLimit` | *integer* | *Optional* | 3 | Number of revision history entries retained per generated Application. |
| `applicationLabels` | *object* | *Optional* | — | Global labels merged onto every generated Application. |
| `applicationAnnotations` | *object* | *Optional* | — | Global annotations merged onto every generated Application. |
| `defaults` | *object* | *Required* | — | Shared source, syncPolicy, and ignoreDifferences defaults. See [Global defaults](#global-defaults). |

### Global defaults

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `helm.repoURL` | *string* | *Optional* | — | Default Helm or OCI chart repository URL. |
| `helm.targetRevision` | *string* | *Optional* | — | Default Helm chart version or OCI tag. |
| `helm.chart` | *string* | *Optional* | — | Default Helm chart name. |
| `helm.valueFiles` | *string[]* | *Optional* | — | Ordered global value files prefixed with $values/ before tenant overrides. |
| `kustomize.repoURL` | *string* | *Optional* | — | Default Git repository URL for Kustomize manifests. |
| `kustomize.targetRevision` | *string* | *Optional* | — | Default Git branch, tag, or commit for Kustomize. |
| `kustomize.path` | *string* | *Optional* | — | Default repository path or Go template expression for Kustomize. |
| `kustomize.namePrefix` | *string* | *Optional* | — | Global namePrefix applied to Kustomize resources. |
| `kustomize.nameSuffix` | *string* | *Optional* | — | Global nameSuffix applied to Kustomize resources. |
| `kustomize.namespace` | *string* | *Optional* | — | Global namespace override enforced by Kustomize. |
| `kustomize.commonLabels` | *object* | *Optional* | — | Global commonLabels merged into Kustomize build options. |
| `kustomize.commonAnnotations` | *object* | *Optional* | — | Global commonAnnotations merged into Kustomize build options. |
| `kustomize.images` | *string[]* | *Optional* | — | Global Kustomize image overrides prepended before tenant images. |
| `kustomize.components` | *string[]* | *Optional* | — | Global Kustomize components prepended before tenant components. |
| `kustomize.patches` | *object[]* | *Optional* | — | Global Kustomize patches prepended before tenant patches. See [Kustomize patch](#kustomize-patch). |
| `syncPolicy` | *object* | *Optional* | — | Baseline syncPolicy merged deterministically with each ApplicationSet override. See [Sync policy](#sync-policy). |
| `ignoreDifferences` | *object[]* | *Optional* | — | Global ignoreDifferences rules inherited by all Applications. See [Ignore differences](#ignore-differences). |

### AppProjects

Entries under `appProjects.<name>` require lowercase kebab-case keys.

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `enabled` | *boolean* | *Required* | true | Enables or disables provisioning this AppProject. |
| `description` | *string* | *Optional* | — | Human-readable AppProject description (max 255 characters). |
| `sourceRepos` | *string[]* | *Required* | — | Explicit list of source repositories permitted for this project. |
| `destinations` | *object[]* | *Required* | — | Permitted destination cluster and namespace targets. |
| `destinations[].server` | *string* | *Optional* | — | Permitted cluster API URL (mutually exclusive with name). |
| `destinations[].name` | *string* | *Optional* | — | Permitted logical cluster name (mutually exclusive with server). |
| `destinations[].namespace` | *string* | *Required* | — | Permitted namespace or glob pattern in the target cluster. |
| `clusterResourceWhitelist` | *object[]* | *Optional* | — | Permitted cluster-scoped Kubernetes resource types. |
| `clusterResourceBlacklist` | *object[]* | *Optional* | — | Denied cluster-scoped Kubernetes resource types. |
| `namespaceResourceWhitelist` | *object[]* | *Optional* | — | Permitted namespace-scoped Kubernetes resource types. |
| `namespaceResourceBlacklist` | *object[]* | *Optional* | — | Denied namespace-scoped Kubernetes resource types. |
| `<resourceList>[].group` | *string* | *Required* | — | Kubernetes API group (empty string for core resources). |
| `<resourceList>[].kind` | *string* | *Required* | — | Kubernetes resource kind. |
| `sourceNamespaces` | *string[]* | *Optional* | — | Namespaces allowed to host Applications referencing this project. |
| `orphanedResources.warn` | *boolean* | *Optional* | — | Emits warnings when orphaned resources exist in target namespaces. |
| `labels` | *object* | *Optional* | — | Additional labels applied to AppProject metadata. |
| `annotations` | *object* | *Optional* | — | Additional annotations applied to AppProject metadata. |

### Helm ApplicationSets

Entries under `appsetsHelm.<name>` require lowercase kebab-case keys.

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `enabled` | *boolean* | *Required* | true | Enables or disables rendering this ApplicationSet. |
| `project` | *string* | *Optional* | — | Target Argo CD AppProject (inherits global.defaultProject when omitted). |
| `applicationNameTemplate` | *string* | *Optional* | `{{ .metadata.labels.environment }}-{{ .path.basename }}` | Go template string used for generated Application metadata.name. |
| `destination` | *object* | *Optional* | — | Target cluster and namespace override for generated Applications. See [Destination override](#destination-override). |
| `syncPolicy` | *object* | *Optional* | — | SyncPolicy override merged deterministically with global.defaults.syncPolicy. See [Sync policy](#sync-policy). |
| `ignoreDifferences` | *object[]* | *Optional* | — | Additional ignoreDifferences rules appended after global rules. See [Ignore differences](#ignore-differences). |
| `applicationLabels` | *object* | *Optional* | — | Labels merged onto Applications produced by this ApplicationSet. |
| `applicationAnnotations` | *object* | *Optional* | — | Annotations merged onto Applications produced by this ApplicationSet. |

#### Helm targetSourceOverride

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `repoURL` | *string* | *Optional* | — | Override Helm or OCI chart repository URL. |
| `targetRevision` | *string* | *Optional* | — | Override Helm chart version or OCI tag. |
| `chart` | *string* | *Optional* | — | Override Helm chart name. |
| `helm.valueFiles` | *string[]* | *Optional* | — | Ordered tenant value files prefixed with $values/. |

#### Helm matrix generator

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `clusters` | *object* | *Required* | — | Non-empty cluster selector for matrix targeting. See [Cluster selector](#cluster-selector). |
| `git.repoURL` | *string* | *Required* | — | Git repository URL hosting Helm value files and discovery paths. |
| `git.targetRevision` | *string* | *Required* | — | Git branch, tag, or commit revision to track. |
| `git.files` | *string[]* | *Required* | — | File glob patterns discovered by the Git generator. |
| `git.requeueAfterSeconds` | *integer* | *Optional* | — | Git generator polling interval in seconds. |
| `git.pathParamPrefix` | *string* | *Optional* | — | Optional prefix applied to generated path parameters. |
| `git.values` | *object* | *Optional* | — | Static key-value parameters exposed to the ApplicationSet template. |

### Kustomize ApplicationSets

Entries under `appsetsKustomize.<name>` require lowercase kebab-case keys.

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `enabled` | *boolean* | *Required* | true | Enables or disables rendering this ApplicationSet. |
| `project` | *string* | *Optional* | — | Target Argo CD AppProject (inherits global.defaultProject when omitted). |
| `applicationNameTemplate` | *string* | *Optional* | `{{ .metadata.labels.environment }}-{{ .path.basename }}` | Go template string used for generated Application metadata.name. |
| `destination` | *object* | *Optional* | — | Target cluster and namespace override for generated Applications. See [Destination override](#destination-override). |
| `syncPolicy` | *object* | *Optional* | — | SyncPolicy override merged deterministically with global.defaults.syncPolicy. See [Sync policy](#sync-policy). |
| `ignoreDifferences` | *object[]* | *Optional* | — | Additional ignoreDifferences rules appended after global rules. See [Ignore differences](#ignore-differences). |
| `applicationLabels` | *object* | *Optional* | — | Labels merged onto Applications produced by this ApplicationSet. |
| `applicationAnnotations` | *object* | *Optional* | — | Annotations merged onto Applications produced by this ApplicationSet. |

#### Kustomize targetSourceOverride

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `repoURL` | *string* | *Optional* | — | Override Git repository URL for Kustomize source. |
| `targetRevision` | *string* | *Optional* | — | Override Git revision for Kustomize source. |
| `path` | *string* | *Optional* | — | Override path or Go template inside the Git source. |
| `kustomize.namePrefix` | *string* | *Optional* | — | Override Kustomize namePrefix. |
| `kustomize.nameSuffix` | *string* | *Optional* | — | Override Kustomize nameSuffix. |
| `kustomize.namespace` | *string* | *Optional* | — | Override Kustomize namespace. |
| `kustomize.commonLabels` | *object* | *Optional* | — | Tenant commonLabels merged over global commonLabels. |
| `kustomize.commonAnnotations` | *object* | *Optional* | — | Tenant commonAnnotations merged over global commonAnnotations. |
| `kustomize.images` | *string[]* | *Optional* | — | Tenant Kustomize images appended after global images. |
| `kustomize.components` | *string[]* | *Optional* | — | Tenant Kustomize components appended after global components. |
| `kustomize.patches` | *object[]* | *Optional* | — | Tenant Kustomize patches appended after global patches. See [Kustomize patch](#kustomize-patch). |

#### Kustomize matrix generator

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `clusters` | *object* | *Required* | — | Non-empty cluster selector for matrix targeting. See [Cluster selector](#cluster-selector). |
| `git.repoURL` | *string* | *Required* | — | Git repository URL hosting Kustomize manifests and overlays. |
| `git.targetRevision` | *string* | *Required* | — | Git branch, tag, or commit revision to track. |
| `git.directories` | *string[]* | *Optional* | — | Directory glob patterns discovered by the Git generator. |
| `git.files` | *string[]* | *Optional* | — | File glob patterns discovered by the Git generator. |
| `git.requeueAfterSeconds` | *integer* | *Optional* | — | Git generator polling interval in seconds. |
| `git.pathParamPrefix` | *string* | *Optional* | — | Optional prefix applied to generated path parameters. |
| `git.values` | *object* | *Optional* | — | Static key-value parameters exposed to the ApplicationSet template. |

### Shared structures

#### Cluster selector

Every `clusters` selector must define at least one `matchLabels` entry or `matchExpressions` item.

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `matchLabels` | *object* | *Optional* | — | Exact cluster label key-value pairs required to match target clusters. |
| `matchExpressions` | *object[]* | *Optional* | — | Set-based cluster label selector expressions. |
| `matchExpressions[].key` | *string* | *Required* | — | Cluster label key to evaluate. |
| `matchExpressions[].operator` | *string* | *Required* | — | Label matching operator (In, NotIn, Exists, or DoesNotExist). |
| `matchExpressions[].values` | *string[]* | *Optional* | — | Allowed values for In or NotIn operators. |

#### Destination override

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `server` | *string* | *Optional* | — | Target cluster API server URL or Go template (mutually exclusive with name). |
| `name` | *string* | *Optional* | — | Target cluster logical name or Go template (mutually exclusive with server). |
| `namespace` | *string* | *Optional* | — | Target namespace or Go template in the destination cluster. |

#### Sync policy

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `automated.prune` | *boolean* | *Optional* | — | Deletes resources removed from Git during sync. |
| `automated.selfHeal` | *boolean* | *Optional* | — | Reverts out-of-band manual cluster changes automatically. |
| `automated.allowEmpty` | *boolean* | *Optional* | — | Allows syncing Applications that render zero resources. |
| `syncOptions` | *string[]* | *Optional* | — | Sync options merged as a deduplicated union across global and tenant scopes. |
| `retry.limit` | *integer* | *Optional* | — | Maximum sync retry attempts (-1 for unlimited). |
| `retry.backoff.duration` | *string* | *Optional* | — | Initial backoff duration (for example 5s). |
| `retry.backoff.factor` | *integer* | *Optional* | — | Backoff multiplier factor on consecutive retries. |
| `retry.backoff.maxDuration` | *string* | *Optional* | — | Maximum backoff cap between retries (for example 3m). |

#### Kustomize patch

Each item under `patches` must specify either inline `patch` or file `path`.

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `patch` | *string* | *Optional* | — | Inline strategic-merge or JSON 6902 patch document. |
| `path` | *string* | *Optional* | — | Relative path to a patch file inside the Git source. |
| `options` | *object* | *Optional* | — | Boolean options passed to Kustomize patch processing. |
| `target.group` | *string* | *Optional* | — | Target API group (empty string for core resources). |
| `target.version` | *string* | *Optional* | — | Target API version. |
| `target.kind` | *string* | *Optional* | — | Target Kubernetes resource kind. |
| `target.name` | *string* | *Optional* | — | Target resource name. |
| `target.namespace` | *string* | *Optional* | — | Target resource namespace. |
| `target.labelSelector` | *string* | *Optional* | — | Label selector matching target resources. |
| `target.annotationSelector` | *string* | *Optional* | — | Annotation selector matching target resources. |

#### Ignore differences

| Parameter | Type | Requirement | Default | Description |
| --- | --- | --- | --- | --- |
| `group` | *string* | *Optional* | — | API group of the resource to ignore. |
| `kind` | *string* | *Required* | — | Kind of the resource to ignore. |
| `name` | *string* | *Optional* | — | Specific resource name to scope the diff exception. |
| `namespace` | *string* | *Optional* | — | Namespace scoping the diff exception. |
| `jsonPointers` | *string[]* | *Optional* | — | RFC 6901 JSON pointers excluded from diff comparison. |
| `jqPathExpressions` | *string[]* | *Optional* | — | jq expressions excluded from diff comparison. |
| `managedFieldsManagers` | *string[]* | *Optional* | — | Field manager names excluded from diff comparison. |

## What's next

- Inspect baseline defaults in [values.yaml](values.yaml).
- Review strict JSON Schema constraints in [values.schema.json](values.schema.json).
- Track release notes and CRD compatibility updates in [CHANGELOG.md](CHANGELOG.md).
- Browse published releases at [Public chart repository](https://fredychivalan.github.io/helm-charts).
