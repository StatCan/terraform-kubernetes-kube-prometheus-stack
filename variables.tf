variable "helm_namespace" {
  description = "The namespace Helm will install the chart under"
}
variable "helm_release" {
  default     = "kube-prometheus-stack"
  description = "The name of the Helm release"
}

variable "helm_repository" {
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "The repository where the Helm chart is stored"
}
variable "helm_repository_password" {
  type        = string
  nullable    = false
  default     = ""
  description = "The password of the repository where the Helm chart is stored"
  sensitive   = true
}
variable "helm_repository_username" {
  type        = string
  nullable    = false
  default     = ""
  description = "The username of the repository where the Helm chart is stored"
  sensitive   = true
}
variable "chart_version" {
  description = "Version of the Helm chart"
}

variable "enable_destinationrules" {
  type        = bool
  default     = false
  description = "Creates DestinationRules for Prometheus, Alertmanager, Grafana, and Node Exporters"
}

variable "enable_thanos_destinationrules" {
  type        = bool
  default     = false
  description = "Creates DestinationRule for Thanos Sidecar"
}

variable "destinationrules_mode" {
  type        = string
  default     = "DISABLE"
  description = "DestionationRule TLS mode"
}
variable "destinationrules_labels" {
  type        = map(string)
  default     = {}
  description = "Labels applied to DestinationRules"
}
variable "cluster_domain" {
  type        = string
  default     = "cluster.local"
  description = "Cluster domain for DestinationRules"
}

variable "enable_prometheusrules" {
  type        = bool
  default     = true
  description = "Adds PrometheusRules for alerts"
}

variable "values" {
  default     = ""
  type        = string
  description = "Values to be passed to the Helm chart"
}

variable "prometheus_pvc_name" {
  type        = string
  default     = "prometheus-kube-prometheus-stack-prometheus-db-prometheus-kube-prometheus-stack-prometheus-0"
  description = "Used for storage alert. Set if using non-default helm_release"
}

variable "alertmanager_replicas" {
  type        = number
  default     = 1
  description = "Number of replicas for Alertmanager"
}
