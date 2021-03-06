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
  default     = false
  description = "Adds PrometheusRules for general cluster and namespace alerts"
}
variable "prometheusrules_labels" {
  type = map(string)
  default = {
    app     = "kube-prometheus-stack"
    release = "kube-prometheus-stack"
  }
  description = "The labels of PrometheusRules for general cluster and namespace alerts"
}
variable "cluster_rules_name" {
  type        = string
  default     = "general-cluster-alerts"
  description = "PrometheusRule name for general cluster alerts"
}
variable "namespace_rules_name" {
  type        = string
  default     = "general-namespace-alerts"
  description = "PrometheusRule name for general namespace alerts"
}
variable "prometheus_pvc_name" {
  type        = string
  default     = "prometheus-kube-prometheus-stack-prometheus-db-prometheus-kube-prometheus-stack-prometheus-0"
  description = "Used for storage alert. Set if using non-default helm_release"
}

variable "values" {
  default     = ""
  type        = string
  description = "Values to be passed to the Helm chart"
}
