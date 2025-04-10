{{/*
deploymentSpec
ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/#deploymentspec-v1-apps
*/}}
{{- define "base.deploymentSpec" -}}
{{- if not .instance.autoscaling.enabled }}
replicas: {{ .instance.replicaCount }}
{{- end }}
revisionHistoryLimit: {{ .global.revisionHistoryLimit }}
selector:
  matchLabels:
    {{- include "base.selectorLabels" .context | nindent 4 }}
{{- with (mergeOverwrite (deepCopy .global.deploymentStrategy) .instance.deploymentStrategy) }}
strategy:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}