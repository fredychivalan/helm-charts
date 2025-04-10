{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "base.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the namespace of the release.
Allows overriding it in values.yaml for deployments.
*/}}
{{- define "base.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create the name of the instance service account to use
*/}}
{{- define "base.instance.serviceAccountName" -}}
{{- if .instance.create -}}
    {{ default (include "base.instance.fullname" (dict "context" .context "instanceName" .instanceName)) .instance.name }}
{{- else -}}
    {{ default "default" .instance.name }}
{{- end -}}
{{- end -}}
