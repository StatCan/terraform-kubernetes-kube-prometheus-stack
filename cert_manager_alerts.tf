resource "kubernetes_manifest" "prometheusrule_cert_manager_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "labels"    = var.prometheusrules_labels
      "name"      = var.cert_manager_rules_name
      "namespace" = var.helm_namespace
    }
    "spec" = yamldecode(file("${path.module}/prom_rules/cert_manager_alerts/cert_manager_rules.yaml"))
  }
}

