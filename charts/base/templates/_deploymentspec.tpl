{{/*
deploymentSpec
ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/#deploymentspec-v1-apps
*/}}
{{- define "base.deploymentSpec" -}}
{{- $context := .context }}
{{- $global := .global }}
{{- $instance := .instance }}
{{- $instanceName := .instanceName }}
{{- if not $instance.autoscaling.enabled }}
replicas: {{ $instance.replicaCount }}
{{- end }}
revisionHistoryLimit: {{ $global.revisionHistoryLimit }}
selector:
  matchLabels:
    {{- include "base.selectorLabels" (dict "context" $context "instanceName" $instanceName) | nindent 4 }}
{{- with (mergeOverwrite (deepCopy $global.deploymentStrategy) $instance.deploymentStrategy) }}
strategy:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}