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
  default     = ""
  description = "The password of the repository where the Helm chart is stored"
}
variable "helm_repository_username" {
  default     = ""
  description = "The username of the repository where the Helm chart is stored"
}
variable "chart_version" {
  description = "Version of the Helm chart"
}

variable "enable_destinationrules" {
  type        = bool
  default     = false
  description = "Creates DestinationRules for Prometheus, Alertmanager, Grafana, and Node Exporters"
}
variable "destinationrules_prefix" {
  type        = string
  default     = "kube-prometheus-stack"
  description = "Set to Prom/AM svc prefix if using non-default helm_release"
}
variable "destinationrules_mode" {
  type        = string
  default     = "DISABLE"
  description = "DestionationRule TLS mode"
}
variable "cluster_domain" {
  type        = string
  default     = "cluster.local"
  description = "Cluster domain for DestinationRules"
}

variable "enable_prometheusrules" {
  type        = bool
  default     = false
  description = "Adds Prometheus Rules for general platform alerts"
}
variable "prometheus_pvc_name" {
  type        = string
  default     = "prometheus-kube-prometheus-stack-prometheus-db-prometheus-kube-prometheus-stack-prometheus-0"
  description = "Used for storage alert. Set if using non-default helm_release"
}

variable "dependencies" {
  type        = list
  description = "List of terraform module dependencies, such as the namespace module"
}

variable "values" {
  default     = ""
  type        = string
  description = "Values to be passed to the Helm chart"
}
