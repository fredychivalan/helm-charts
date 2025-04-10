{{- define "base.metadata" -}}
annotations:
  {{- include "base.anotations" (dict "context" .context "instance" .instance "global" .global ) }}
labels:
  {{- include "base.standardLabels" .context | nindent 2 }}
  {{- include "base.commonLabels" (dict "context" .context "instance" .instance "global" .global ) | indent 2 }}
name: {{ include "base.instance.fullname" (dict "context" .context "instanceName" .instanceName) }}
namespace: {{ include  "base.namespace" .context }}
{{- end -}}


{{- define "base.metadata.serviceAccount" -}}
annotations:
  {{- include "base.anotations" (dict "context" .context "instance" .instance "global" .global ) }}
labels:
  {{- include "base.standardLabels" .context | nindent 2 }}
  {{- include "base.commonLabels" (dict "context" .context "instance" .instance "global" .global ) | indent 2 }}
name: {{ include "base.instance.serviceAccountName" (dict "context" .context "instanceName" .instanceName "instance" .instance) }}
namespace: {{ include  "base.namespace" .context }}
{{- end -}}