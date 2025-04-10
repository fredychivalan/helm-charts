{{/*
Common annotations and instance annotations
*/}}
{{- define "base.anotations" -}}
{{- $commonAnotations := merge (pluck "annotations" (default (dict) .instance ) | first) .global.commonAnotations }}
{{- if $commonAnotations }} 
  {{- range $key, $value := $commonAnotations }}
  {{ $key }}: {{ $value | quote }}
  {{- end -}}
{{- end -}}
{{- end -}}
