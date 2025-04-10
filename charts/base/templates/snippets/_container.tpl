{{/*
Container
https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.32/#container-v1-core
*/}}
{{- define "base.container" -}}
- name: {{ .instanceName }}
  image: {{ default .global.image.repository .instance.image.repository }}:{{ default .global.image.tag .instance.image.tag }}
  imagePullPolicy: {{ default .global.image.imagePullPolicy .instance.image.imagePullPolicy }}
  {{- if .instance.args }}
  args:
    {{- toYaml .instance.args | nindent 4 }}
  {{- end }}
  {{- if .instance.command }}
  command:
    {{- toYaml .instance.command | nindent 4 }}
  {{- end }}
  env:
  {{- with (concat .global.env .instance.env) }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .instance.envFrom }}
  envFrom:
    {{- toYaml .instance.envFrom | nindent 4 }}
  {{- end }}
  {{- if .instance.lifecycleHooks }}
  lifecycle:
    {{- toYaml .instance.lifecycleHooks | nindent 4 }}
  {{- end }}
  {{- if .instance.livenessProbe }}
  livenessProbe:
    {{- toYaml .instance.livenessProbe | nindent 4 }}
  {{- end }}
  {{- if .instance.containerPorts }}
  ports:
    - name: http
      containerPort: {{ .instance.containerPorts.http }}
      protocol: {{ .instance.containerPorts.protocol | default "TCP" }}
  {{- if and .instance.containerPorts .instance.extraContainerPorts }}
    {{- toYaml .instance.extraContainerPorts | nindent 4 }}
  {{- end }}
  {{- end }}
  {{- if .instance.readinessProbe }}
  readinessProbe:
    {{- toYaml .instance.readinessProbe | nindent 4 }}
  {{- end }}
  {{- if .instance.resources }}
  resources:
    {{- toYaml .instance.resources | nindent 4 }}
  {{- end }}
  {{- if .instance.containerSecurityContext }}
  securityContext: 
    {{- toYaml .instance.containerSecurityContext | nindent 4 }}
  {{- end }}
  {{- if .instance.startupProbe }}
  startupProbe:
    {{- toYaml .instance.startupProbe | nindent 4 }}
  {{- end }}
  {{- if .instance.stdin }}
  stdin: {{ .instance.stdin }}
  {{- end }}
  {{- if .instance.stdinOnce }}
  stdinOnce: {{ .instance.stdinOnce }}
  {{- end }}
  {{- if .instance.terminationMessagePath }}
  terminationMessagePath: {{ .instance.terminationMessagePath | quote }}
  {{- end }}
  {{- if .instance.terminationMessagePolicy }}
  terminationMessagePolicy: {{ .instance.terminationMessagePolicy | quote }}
  {{- end }}
  {{- if .instance.tty }}
  tty: {{ .instance.tty }}
  {{- end }}
  {{- if .instance.volumeMounts }}
  volumeMounts:
    {{- range $volumeMount := .instance.volumeMounts }}
    - name: {{ $volumeMount.name | quote }}
      mountPath: {{ $volumeMount.mountPath | quote }}
      {{- if $volumeMount.readOnly }}
      readOnly: {{ $volumeMount.readOnly }}
      {{- end }}
      {{- if $volumeMount.subPath }}
      subPath: {{ $volumeMount.subPath | quote }}
      {{- end }}
      {{- if $volumeMount.subPathExpr }}
      subPathExpr: {{ $volumeMount.subPathExpr | quote }}
      {{- end }}
      {{- if $volumeMount.mountPropagation }}
      mountPropagation: {{ $volumeMount.mountPropagation | quote }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- if .instance.workingDir }}
  workingDir: {{ .instance.workingDir | quote }}
  {{- end }}
{{- end -}}
