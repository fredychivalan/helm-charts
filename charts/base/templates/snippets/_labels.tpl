{{/*
Standard labels
*/}}
{{- define "base.standardLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
helm.sh/chart: {{ include "base.chart" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "base.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "base.name" . }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "base.commonLabels" -}}
{{- $commonLabels := merge (pluck "labels" (default (dict) .instance ) | first) .global.commonLabels }}
{{- if $commonLabels }}
{{- range $key, $value := $commonLabels }}
{{ $key }}: {{ $value | quote }}
{{- end -}}
{{- end -}}
{{- end -}}
