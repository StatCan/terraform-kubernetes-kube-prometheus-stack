locals {
  common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/version"    = "v3.0.0"
    "app.kubernetes.io/part-of"    = "kube-prometheus-stack"
  }
  rules_base_path = "https://gitlab.k8s.cloud.statcan.ca/cloudnative/terraform/modules/terraform-kubernetes-kube-prometheus-stack/-/tree/master/prometheus_rules"
}
