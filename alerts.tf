resource "kubernetes_manifest" "prometheusrule_certificate_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "certificate-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "certificate-alerts" })
      "annotations" = {
        "rules-definition" = "${local.rules_base_path}/certificate_alerts/certificate_rules.yaml"
      }
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/certificate_alerts/certificate_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_container_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "container-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "container-alerts" })
      "annotations" = {
        "rules-definition" = "${local.rules_base_path}/container_alerts/container_rules.yaml"
      }
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/container_alerts/container_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_job_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "job-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "job-alerts" })
      "annotations" = {
        "rules-definition" = "${local.rules_base_path}/job_alerts/job_rules.yaml"
      }
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/job_alerts/job_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_node_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "node-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "node-alerts" })
      "annotations" = {
        "rules-definition" = "${local.rules_base_path}/node_alerts/node_rules.yaml"
      }
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/node_alerts/node_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_nodepool_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "nodepool-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "nodepool-alerts" })
      "annotations" = {
        "rules-definition" = "${local.rules_base_path}/nodepool_alerts/nodepool_rules.yaml"
      }
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/nodepool_alerts/nodepool_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_pod_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "pod-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "pod-alerts" })
      "annotations" = {
        "rules-definition" = "${local.rules_base_path}/pod_alerts/pod_rules.yaml"
      }
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/pod_alerts/pod_rules.yaml", {
      runbook_base_url = local.runbook_base_url
    }))
  }
}

resource "kubernetes_manifest" "prometheusrule_prometheus_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "prometheus-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "prometheus-alerts" })
      "annotations" = {
        "rules-definition" = "${local.rules_base_path}/prometheus_alerts/prometheus_rules.yaml"
      }
    }
    "spec" = yamldecode(templatefile("${path.module}/prometheus_rules/prometheus_alerts/prometheus_rules.yaml", {
      prometheus_pvc_name = var.prometheus_pvc_name
      runbook_base_url    = local.runbook_base_url
    }))
  }
}
