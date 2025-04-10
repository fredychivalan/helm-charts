{{/*
podSpec
ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/#podspec-v1-core
*/}}
{{- define "base.podSpec" -}}
{{- $context := .context }}
{{- $global := .global -}}
{{- $instance := .instance -}}
{{- if $instance.activeDeadlineSeconds }}
activeDeadlineSeconds: {{ $instance.activeDeadlineSeconds }}
{{- end }}
{{- with $instance.affinity | default $global.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if $instance.automountServiceAccountToken }}
automountServiceAccountToken: {{ $instance.automountServiceAccountToken }}
{{- end }}
{{- if $instance.dnsConfig }}
dnsConfig:
  {{- toYaml $instance.dnsConfig | nindent 2 }}
{{- end }}
{{- if $instance.dnsPolicy }}
dnsPolicy: {{ $instance.dnsPolicy | quote }}
{{- end }}
{{- if $instance.enableServiceLinks }}
enableServiceLinks: {{ $instance.enableServiceLinks }}
{{- end }}
{{- if $instance.ephemeralContainers }}
ephemeralContainers:
  {{- toYaml $instance.ephemeralContainers | nindent 2 }}
{{- end }}
{{- with $instance.hostAliases | default $global.hostAliases }}
hostAliases:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if $instance.hostIPC }}
hostIPC: {{ $instance.hostIPC }}
{{- end }}
{{- if $instance.hostNetwork }}
hostNetwork: {{ $instance.hostNetwork }}
{{- end }}
{{- if $instance.hostPID }}
hostPID: {{ $instance.hostPID }}
{{- end }}
{{- if $instance.hostUsers }}
hostUsers: {{ $instance.hostUsers | quote }}
{{- end }}
{{- if $instance.hostname }}
hostname: {{ $instance.hostname | quote }}
{{- end }}
{{- with $instance.imagePullSecrets | default $global.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if $instance.nodeName }}
nodeName: {{ $instance.nodeName | quote }}
{{- end }}
{{- with $instance.nodeSelector | default $global.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if $instance.os }}
os:
  {{- toYaml $instance.os | nindent 2 }}
{{- end }}
{{- if $instance.overhead }}
overhead:
  {{- toYaml $instance.overhead | nindent 2 }}
{{- end }}
{{- if $instance.preemptionPolicy }}
preemptionPolicy: {{ $instance.preemptionPolicy | quote }}
{{- end }}
{{- if $instance.priority }}
priority: {{ $instance.priority }}
{{- end }}
{{- with $instance.priorityClassName | default $global.priorityClassName }}
priorityClassName: {{ . | quote }}
{{- end }}
{{- if $instance.readinessGates }}
readinessGates:
  {{- toYaml $instance.readinessGates | nindent 2 }}
{{- end }}
{{- if $instance.resourceClaims }}
resourceClaims:
  {{- toYaml $instance.resourceClaims | nindent 2 }}
{{- end }}
{{- if $instance.restartPolicy }}
restartPolicy: {{ $instance.restartPolicy | quote }}
{{- else }}
restartPolicy: Always
{{- end }}
{{- with $instance.runtimeClassName | default $global.runtimeClassName }}
runtimeClassName: {{ . | quote }}
{{- end }}
{{- if $instance.schedulerName }}
schedulerName: {{ $instance.schedulerName | quote }}
{{- end }}
{{- if $instance.schedulingGate }}
schedulingGate:
  {{- toYaml $instance.schedulingGate | nindent 2 }}
{{- end }}
{{- if $global.podSecurityContext }}
securityContext:
  {{- toYaml $global.podSecurityContext | nindent 2 }}
{{- end }}
serviceAccountName: {{ include "base.instance.serviceAccountName" (dict "context" $context "instanceName" $instance.name "instance" $instance.serviceAccount) }}
{{- if $instance.shareProcessNamespace }}
shareProcessNamespace: {{ $instance.shareProcessNamespace }}
{{- end }}
{{- if $instance.subdomain }}
subdomain: {{ $instance.subdomain | quote }}
{{- end }}
{{- if $instance.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ $instance.terminationGracePeriodSeconds }}
{{- end }}
{{- with $instance.tolerations | default $global.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $instance.topologySpreadConstraints | default $global.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if $instance.volumes }}
volumes:
  {{- toYaml $instance.volumes | nindent 2 }}
{{- end }}
{{- end -}}