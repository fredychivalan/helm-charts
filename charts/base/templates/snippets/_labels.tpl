{{/*
Standard labels
*/}}
{{- define "base.standardLabels" -}}
{{ include "base.selectorLabels" (dict "context" .context "instanceName" .instanceName ) }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
helm.sh/chart: {{ include "base.chart" .context }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "base.selectorLabels" -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
app.kubernetes.io/name: {{ include "base.instance.fullname" (dict "context" .context "instanceName" .instanceName) }}
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
