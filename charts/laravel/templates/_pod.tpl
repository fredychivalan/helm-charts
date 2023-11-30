{{- define "laravel.pod" -}}
serviceAccountName: {{ include "laravel.serviceAccountName" . }}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.priorityClassName }}
priorityClassName: {{ .Values.priorityClassName }}
{{- end }}
{{- with .Values.podSecurityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.initContainers }}
initContainers:
{{- if kindIs "string" . }}
  {{- tpl . $ | nindent 2 }}
{{- else }}
  {{-  toYaml . | nindent 2 }}
{{- end -}}
{{- end }}
containers:
{{- if .Values.nginx.enabled }}
  - name: nginx
  {{- with .Values.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    image: "{{ .Values.nginx.image.repository }}:{{ .Values.nginx.image.tag }}"
    imagePullPolicy: {{ .Values.nginx.image.pullPolicy }}
    ports:
      - name: http
        containerPort: {{ .Values.nginx.service.port }}
        protocol: TCP
  {{- with .Values.nginx.livenessProbe }}
    livenessProbe:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.nginx.readinessProbe }}
    readinessProbe:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    volumeMounts:
      - name: nginx-config
        mountPath: /etc/nginx/conf.d/default.conf
        subPath: nginx.conf
      - name: shared-files
        mountPath: /usr/share/nginx/html
{{- end }}
  - name: {{ .Chart.Name }}
  {{- with .Values.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    image: "{{ .Values.laravel.image.repository }}:{{ .Values.laravel.image.tag }}"
    imagePullPolicy: {{ .Values.laravel.image.pullPolicy }}
  {{- if or .Values.laravel.env .Values.laravel.envWithTpl }}
    env:
    {{- with .Values.laravel.env }}
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- range $item := .Values.laravel.envWithTpl }}
      - name: {{ $item.name }}
        value: {{ tpl $item.value $ | quote }}
    {{- end }}
  {{- end }}
    envFrom:
      - configMapRef:
        {{ if .Values.laravel.existingConfigMap }}
          name:  {{ .Values.laravel.existingConfigMap }}
        {{ else }}
          name:  {{ template "laravel.fullname" . }}-env
        {{ end }}
    {{- with .Values.laravel.extraEnvFrom  }}
      {{- toYaml . | nindent 6 }}
    {{- end  }}
  {{- if .Values.laravel.args }}
    args:
    {{- toYaml .Values.laravel.args | nindent 6 }}
  {{- end}}
  {{- if .Values.laravel.command }}
    command:
    {{- toYaml .Values.laravel.command | nindent 6 }}
  {{- end }}
  {{- with .Values.laravel.lifecycle }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.laravel.livenessProbe }}
    livenessProbe:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.laravel.readinessProbe }}
    readinessProbe:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    volumeMounts:
      - name: shared-files
        mountPath: /usr/share/nginx/html
      - name: php-fpm-conf
        mountPath: /usr/local/etc/php-fpm.d/php-fpm.conf
        subPath: php-fpm.conf
{{- if .Values.schedule.enabled }}
  - name: schedule
  {{- with .Values.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    image: "{{ .Values.laravel.image.repository }}:{{ .Values.laravel.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.laravel.image.pullPolicy }}
  {{- if or .Values.laravel.extraEnv .Values.laravel.envWithTpl }}
    env:
    {{- with .Values.laravel.extraEnv }}
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- range $item := .Values.laravel.envWithTpl }}
      - name: {{ $item.name }}
        value: {{ tpl $item.value $ | quote }}
    {{- end }}
  {{- end }}
    envFrom:
      - configMapRef:
          name: {{ template "laravel.fullname" . }}-env
    {{- with .Values.laravel.extraEnvFrom  }}
      {{- toYaml . | nindent 6 }}
    {{- end  }}
  {{- if .Values.schedule.args }}
    args:
    {{- toYaml .Values.schedule.args | nindent 6 }}
  {{- end}}
  {{- if .Values.schedule.command }}
    command:
    {{- toYaml .Values.schedule.command | nindent 6 }}
  {{- end }}
  {{- with .Values.laravel.lifecycle }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.laravel.livenessProbe }}
    livenessProbe:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.laravel.readinessProbe }}
    readinessProbe:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- with .Values.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    volumeMounts:
      - name: shared-files
        mountPath: /usr/share/nginx/html
      - name: php-fpm-conf
        mountPath: /usr/local/etc/php-fpm.d/php-fpm.conf
        subPath: php-fpm.conf
{{- end }}
{{- if .Values.extraContainers }}
  {{- toYaml .Values.extraContainers | nindent 2 }}
{{- end }}
volumes:
  {{ if .Values.nginx.enabled }}
  - name: nginx-config
    configMap:
      name: {{ if .Values.nginx.config.enabled }} {{ .Release.Name }}-nginx-config {{ else }} {{ .Values.nginx.config.name }} {{ end }}
  {{- end }}
  - name: shared-files
    emptyDir: {}
  - name: php-fpm-conf
    configMap:
      name: {{ template "laravel.fullname" . }}-fpm-conf
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
