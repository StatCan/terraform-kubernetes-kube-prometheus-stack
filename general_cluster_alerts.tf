

resource "kubernetes_manifest" "prometheusrule_general_cluster_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "labels"    = var.prometheusrules_labels
      "name"      = var.cluster_rules_name
      "namespace" = var.helm_namespace
    }
    "spec" = yamldecode(templatefile("${path.module}/prom_rules/general_cluster_alerts.yaml", {
      prometheus_pvc_name = var.prometheus_pvc_name
    }))
  }
}
