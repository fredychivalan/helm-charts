{{/*
podDisruptionBudgetSpec
ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/#poddisruptionbudgetspec-v1-policy
*/}}
{{- define "base.podDisruptionBudgetSpec" -}}
{{- $context := .context }}
{{- $instance := .instance }}
{{- $instanceName := .instanceName }}
{{- with $instance.maxUnavailable }}
maxUnavailable: {{ . }}
{{- else }}
minAvailable: {{ $instance.minAvailable | default 0 }}
{{- end }}
selector:
  matchLabels:
    {{- include "base.selectorLabels" (dict "context" $context "instanceName" $instanceName) | nindent 4 }}
{{- end -}}