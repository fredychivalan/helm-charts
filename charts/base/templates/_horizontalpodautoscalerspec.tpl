{{/*
HorizontalPodAutoscalerSpec
ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/#horizontalpodautoscalerspec-v2-autoscaling
*/}}
{{- define "base.horizontalpodautoscalerspec" -}}
{{- $context := .context }}
{{- $instance := .instance }}
{{- $instanceName := .instanceName }}
{{- if $instance.behavior }}
behavior:
  {{- toYaml $instance.behavior | nindent 2 }}
{{- end }}
maxReplicas: {{ $instance.maxReplicas }}
metrics:
{{- if $instance.metrics }}
  {{- toYaml $instance.metrics | nindent 2 }}
{{- else }}
  {{- if $instance.targetMemoryUtilizationPercentage }}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ $instance.targetMemoryUtilizationPercentage }}
  {{- end }}
  {{- if $instance.targetCPUUtilizationPercentage }}
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ $instance.targetCPUUtilizationPercentage }}
  {{- end }}
{{- end }}
minReplicas: {{ $instance.minReplicas }}
scaleTargetRef:
  apiVersion: apps/v1
  kind: Deployment
  name: {{ include "base.instance.fullname" (dict "context" $context "instanceName" $instanceName ) }}
{{- end -}}