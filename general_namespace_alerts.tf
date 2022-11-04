resource "kubernetes_manifest" "prometheusrule_general_namespace_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "labels"    = var.prometheusrules_labels
      "name"      = var.namespace_rules_name
      "namespace" = var.helm_namespace
    }
    "spec" = yamldecode(file("${path.module}/prom_rules/general_namespace_alerts/namespace_rules.yaml"))
  }
}
