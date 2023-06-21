locals {
  common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/version"    = "v3.9.1"
    "app.kubernetes.io/part-of"    = "kube-prometheus-stack"
  }
  rules_base_path  = "https://gitlab.k8s.cloud.statcan.ca/cloudnative/terraform/modules/terraform-kubernetes-kube-prometheus-stack/-/tree/master/prometheus_rules"
  runbook_base_url = "https://cloudnative.pages.cloud.statcan.ca/en/documentation/monitoring-surveillance/prometheus"
}
