{{/*
Standard chart name.
*/}}
{{- define "argocd-gitops-platform.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "argocd-gitops-platform.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Standard CNCF labels applied to chart-managed resources.
*/}}
{{- define "argocd-gitops-platform.labels" -}}
helm.sh/chart: {{ include "argocd-gitops-platform.chart" . }}
app.kubernetes.io/name: {{ include "argocd-gitops-platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component: gitops-orchestrator
app.kubernetes.io/part-of: argocd-gitops-platform
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Guard prohibiting project "default" unless global.allowDefaultProject is explicitly true.
Usage: {{ include "argocd-gitops-platform.assertProjectPolicy" (dict "global" $global "project" $project "context" $appName) }}
*/}}
{{- define "argocd-gitops-platform.assertProjectPolicy" -}}
{{- $allowDefault := default false .global.allowDefaultProject -}}
{{- if and (eq .project "default") (not $allowDefault) -}}
{{- fail (printf "security policy violation in %s: project 'default' is forbidden unless global.allowDefaultProject=true" .context) -}}
{{- end -}}
{{- end -}}

{{/*
Guard prohibiting setting both destination.server and destination.name simultaneously.
Usage: {{ include "argocd-gitops-platform.assertDestination" (dict "dest" $dest "context" $appName) }}
*/}}
{{- define "argocd-gitops-platform.assertDestination" -}}
{{- if and .dest .dest.server .dest.name -}}
{{- fail (printf "contract violation in %s: destination.server and destination.name are mutually exclusive" .context) -}}
{{- end -}}
{{- end -}}

{{/*
Deterministic merge of global and tenant syncPolicy.
Concatenates and deduplicates syncOptions so tenant options (e.g. ServerSideApply=true)
preserve global options (e.g. CreateNamespace=true).
Usage: {{ include "argocd-gitops-platform.mergeSyncPolicy" (dict "global" $globalSync "tenant" $tenantSync) }}
*/}}
{{- define "argocd-gitops-platform.mergeSyncPolicy" -}}
{{- $global := default dict .global -}}
{{- $tenant := default dict .tenant -}}
{{- $out := dict -}}
{{- if or (hasKey $global "automated") (hasKey $tenant "automated") -}}
  {{- $auto := mergeOverwrite (deepCopy (default dict $global.automated)) (deepCopy (default dict $tenant.automated)) -}}
  {{- if $auto -}}
    {{- $_ := set $out "automated" $auto -}}
  {{- end -}}
{{- end -}}
{{- $mergedOpts := list -}}
{{- range $opt := (default list $global.syncOptions) -}}
  {{- if not (has $opt $mergedOpts) -}}
    {{- $mergedOpts = append $mergedOpts $opt -}}
  {{- end -}}
{{- end -}}
{{- range $opt := (default list $tenant.syncOptions) -}}
  {{- if not (has $opt $mergedOpts) -}}
    {{- $mergedOpts = append $mergedOpts $opt -}}
  {{- end -}}
{{- end -}}
{{- if gt (len $mergedOpts) 0 -}}
  {{- $_ := set $out "syncOptions" $mergedOpts -}}
{{- end -}}
{{- if or (hasKey $global "retry") (hasKey $tenant "retry") -}}
  {{- $retry := mergeOverwrite (deepCopy (default dict $global.retry)) (deepCopy (default dict $tenant.retry)) -}}
  {{- if $retry -}}
    {{- $_ := set $out "retry" $retry -}}
  {{- end -}}
{{- end -}}
{{- if gt (len $out) 0 -}}
{{- toYaml $out -}}
{{- end -}}
{{- end -}}
