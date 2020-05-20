{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pet-battle-nsfw.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "minio.name" -}}
{{- default "minio" -}}
{{- end -}}

{{- define "tensorboard.name" -}}
{{- default "tensorboard" -}}
{{- end -}}

{{- define "tfserving.name" -}}
{{- default "tfserving" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pet-battle-nsfw.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "odhog.fullname" -}}
{{- printf "%s-%s" "pet-battle-nsfw" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "odh.fullname" -}}
{{- printf "%s-%s" .Release.Name "odh" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "minio.fullname" -}}
{{- printf "%s-%s" "minio" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tensorboard.fullname" -}}
{{- printf "%s-%s" "tensorboard" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tfserving.fullname" -}}
{{- printf "%s-%s" "tensorflowserving" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pet-battle-nsfw.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pet-battle-nsfw.labels" -}}
helm.sh/chart: {{ include "pet-battle-nsfw.chart" . }}
{{ include "pet-battle-nsfw.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "minio.labels" -}}
helm.sh/chart: {{ include "pet-battle-nsfw.chart" . }}
{{ include "minio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "tensorboard.labels" -}}
helm.sh/chart: {{ include "pet-battle-nsfw.chart" . }}
{{ include "tensorboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "tfserving.labels" -}}
helm.sh/chart: {{ include "pet-battle-nsfw.chart" . }}
{{ include "tfserving.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "pet-battle-nsfw.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pet-battle-nsfw.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "minio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "minio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "tensorboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tensorboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "tfserving.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tfserving.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

