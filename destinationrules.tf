resource "kubernetes_manifest" "destinationrule_kube_prometheus_stack_alertmanager" {
  count = var.enable_destinationrules ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "DestinationRule"
    "metadata" = {
      "labels"    = merge(var.destinationrules_labels, local.common_labels)
      "name"      = "${var.helm_release}-alertmanager"
      "namespace" = var.helm_namespace
    }
    "spec" = {
      "host" = "${var.helm_release}-alertmanager.${var.helm_namespace}.svc.${var.cluster_domain}"
      "trafficPolicy" = {
        "tls" = {
          "mode" = var.destinationrules_mode
        }
      }
    }
  }
}

resource "kubernetes_manifest" "destinationrule_kube_prometheus_stack_alertmanager_replicas" {
  count = var.enable_destinationrules && var.alertmanager_replicas > 1 ? var.alertmanager_replicas : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "DestinationRule"
    "metadata" = {
      "labels"    = merge(var.destinationrules_labels, local.common_labels)
      "name"      = "${var.helm_release}-alertmanager-${count.index}"
      "namespace" = var.helm_namespace
    }
    "spec" = {
      "host" = "${var.helm_release}-alertmanager-${count.index}.${var.helm_namespace}.svc.${var.cluster_domain}"
      "trafficPolicy" = {
        "tls" = {
          "mode" = var.destinationrules_mode
        }
      }
    }
  }
}

resource "kubernetes_manifest" "destinationrule_kube_prometheus_stack_grafana" {
  count = var.enable_destinationrules ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "DestinationRule"
    "metadata" = {
      "labels"    = merge(var.destinationrules_labels, local.common_labels)
      "name"      = "${var.helm_release}-grafana"
      "namespace" = var.helm_namespace
    }
    "spec" = {
      "host" = "${var.helm_release}-grafana.${var.helm_namespace}.svc.${var.cluster_domain}"
      "trafficPolicy" = {
        "tls" = {
          "mode" = var.destinationrules_mode
        }
      }
    }
  }
}

resource "kubernetes_manifest" "destinationrule_kube_prometheus_stack_prometheus" {
  count = var.enable_destinationrules ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "DestinationRule"
    "metadata" = {
      "labels"    = merge(var.destinationrules_labels, local.common_labels)
      "name"      = "${var.helm_release}-prometheus"
      "namespace" = var.helm_namespace
    }
    "spec" = {
      "host" = "${var.helm_release}-prometheus.${var.helm_namespace}.svc.${var.cluster_domain}"
      "trafficPolicy" = {
        "tls" = {
          "mode" = var.destinationrules_mode
        }
      }
    }
  }
}

resource "kubernetes_manifest" "destinationrule_kube_prometheus_stack_prometheus_node_exporter" {
  count = var.enable_destinationrules ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "DestinationRule"
    "metadata" = {
      "labels"    = merge(var.destinationrules_labels, local.common_labels)
      "name"      = "${var.helm_release}-prometheus-node-exporter"
      "namespace" = var.helm_namespace
    }
    "spec" = {
      "host" = "${var.helm_release}-prometheus-node-exporter.${var.helm_namespace}.svc.${var.cluster_domain}"
      "trafficPolicy" = {
        "tls" = {
          "mode" = var.destinationrules_mode
        }
      }
    }
  }
}

resource "kubernetes_manifest" "destinationrule_thanos_sidecar" {
  count = var.enable_thanos_destinationrules ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "DestinationRule"
    "metadata" = {
      "labels"    = merge(var.destinationrules_labels, local.common_labels)
      "name"      = "thanos-sidecar"
      "namespace" = "${var.helm_namespace}"
    }
    "spec" = {
      "host" = "${var.helm_release}-thanos-discovery.${var.helm_namespace}.svc.${var.cluster_domain}"
      "trafficPolicy" = {
        "tls" = {
          "mode" = var.destinationrules_mode
        }
      }
    }
  }
}
