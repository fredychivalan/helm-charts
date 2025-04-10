{{- define "base.poddisruptionbudgetspec" -}}
{{- $context := .context }}
{{- $instance := .instance }}
{{- with $instance.maxUnavailable }}
maxUnavailable: {{ . }}
{{- else }}
minAvailable: {{ $instance.minAvailable | default 0 }}
{{- end }}
selector:
  matchLabels:
    {{- include "base.selectorLabels" $context | nindent 4 }}
{{- end -}}