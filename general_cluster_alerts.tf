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
    "spec" = {
      "groups" = [
        {
          "name" = "certificates.rules"
          "rules" = [
            {
              "alert" = "SSLCertExpiringSoon"
              "annotations" = {
                "message" = "SSL certificate for {{ $labels.instance }} expires in less than 20 days."
              }
              "expr" = "sum by (target, instance) (probe_ssl_earliest_cert_expiry{job=\"blackbox-exporter-prometheus-blackbox-exporter\"} - time()) < 86400 * 20"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
          ]
        },
        {
          "name" = "meta-alerts.rules"
          "rules" = [
            {
              "expr"   = "sum without (alertname, alertstate) (label_replace(ALERTS{alertstate=\"firing\",alertname!~\"ManyAlertsFiring|ManyManyAlertsFiring|KubeJobCompletion|KubeJobFailed\"}, \"alertfiring\", \"$1\", \"alertname\", \"(.*)\"))"
              "record" = "alerts_firing"
            },
            {
              "alert" = "ManyManyAlertsFiring"
              "annotations" = {
                "message" = "{{ $value }} instances of alert {{ $labels.alertfiring }} are firing in namespace {{ $labels.namespace }}!"
              }
              "expr" = "sum by(alertfiring, namespace) (alerts_firing) > 50"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
            {
              "alert" = "ManyAlertsFiring"
              "annotations" = {
                "message" = "{{ $value }} instances of alert {{ $labels.alertfiring }} are firing in namespace {{ $labels.namespace }}."
              }
              "expr" = "sum by(alertfiring, namespace) (alerts_firing) > 20"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P3-Minor"
              }
            },
          ]
        },
        {
          "name" = "nodepool-status.rules"
          "rules" = [
            {
              "expr"   = "sum(kube_node_status_allocatable_pods * on (node) group_left(label_agentpool) kube_node_labels) by (label_agentpool)"
              "record" = "nodepool_allocatable_pods"
            },
            {
              "expr"   = "sum(kube_pod_info * on (node) group_left(label_agentpool) kube_node_labels) by (label_agentpool)"
              "record" = "nodepool_allocated_pods"
            },
            {
              "alert" = "NodepoolPodsFull"
              "annotations" = {
                "message" = "{{ if eq $labels.label_agentpool \"\"}}Unpooled node{{ else }}Nodepool {{ $labels.label_agentpool }}{{end}} pod capacity is {{ printf \"%.2f\" $value }}% full!"
              }
              "expr" = "nodepool_allocated_pods/nodepool_allocatable_pods * 100 > 95"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P3-Major"
              }
            },
            {
              "alert" = "NodepoolLowPodCapacity"
              "annotations" = {
                "message" = "{{ if eq $labels.label_agentpool \"\"}}Unpooled node{{ else }}Nodepool {{ $labels.label_agentpool }}{{end}} pod capacity is {{ printf \"%.2f\" $value }}% full."
              }
              "expr" = "nodepool_allocated_pods/nodepool_allocatable_pods * 100 > 85"
              "for"  = "10m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P4-Warning"
              }
            },
          ]
        },
        {
          "name" = "node-status.rules"
          "rules" = [
            {
              "expr"   = "sum by(nodename) (avg by(instance, job) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * on(instance, job) group_left(nodename) node_uname_info * 100)"
              "record" = "node_cpu_available"
            },
            {
              "alert" = "NodeDiskPressure"
              "annotations" = {
                "message" = "UNHEALTHY NODE: {{ $labels.node }} has critically low disk capacity."
              }
              "expr" = "sum by (node) (kube_node_status_condition{condition=\"DiskPressure\",job=\"kube-state-metrics\",status=\"true\"}) == 1"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
            {
              "alert" = "NodeMemoryPressure"
              "annotations" = {
                "message" = "UNHEALTHY NODE: {{ $labels.node }} has critically low memory."
              }
              "expr" = "sum by (node) (kube_node_status_condition{condition=\"MemoryPressure\",job=\"kube-state-metrics\",status=\"true\"}) == 1"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
            {
              "alert" = "NodePIDPressure"
              "annotations" = {
                "message" = "UNHEALTHY NODE: Too many processes are running on {{ $labels.node }}."
              }
              "expr" = "sum by (node) (kube_node_status_condition{condition=\"PIDPressure\",job=\"kube-state-metrics\",status=\"true\"}) == 1"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
            {
              "alert" = "NodeNetworkUnavailable"
              "annotations" = {
                "message" = "UNHEALTHY NODE: The network for {{ $labels.node }} is not correctly configured."
              }
              "expr" = "sum by (node) (kube_node_status_condition{condition=\"NetworkUnavailable\",job=\"kube-state-metrics\",status=\"true\"}) == 1"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
            {
              "alert" = "NodeNotReady"
              "annotations" = {
                "message" = "{{ $labels.node }} is not in a Ready state but did not trip a Network or Pressure condition."
              }
              "expr" = "sum by (node) (kube_node_status_condition{condition=\"Ready\",job=\"kube-state-metrics\",status=\"true\"}) == 0"
              "for"  = "2m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
            {
              "alert" = "NodeUnschedulable"
              "annotations" = {
                "message" = "{{ $labels.node }} is unschedulable for over 1 hour. If it is healthy, is it cordoned?"
              }
              "expr" = "sum by (node) (kube_node_spec_unschedulable{job=\"kube-state-metrics\"}) == 1"
              "for"  = "1h"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P4-Warning"
              }
            },
            {
              "alert" = "NodePodsFull"
              "annotations" = {
                "message" = "{{ $labels.node }} pod capacity is {{ printf \"%.2f\" $value }}% full!"
              }
              "expr" = "sum(kube_pod_info) by (node) / sum(kube_node_status_allocatable_pods) by (node) * 100 > 99"
              "for"  = "5m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P4-Warning"
              }
            },
            {
              "alert" = "NodeLowMemory"
              "annotations" = {
                "message" = "{{ $labels.nodename }} has {{ printf \"%.2f\" $value }}% available memory."
              }
              "expr" = "sum by (nodename) (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * on(instance,job) group_left(nodename) node_uname_info * 100) < 15"
              "for"  = "10m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P4-Warning"
              }
            },
            {
              "alert" = "NodeDiskMayFillIn60Hours"
              "annotations" = {
                "message" = "{{ $labels.kubernetes_node}} disk {{ $labels.device}} is predicted to reach DiskPressure within 60 hours"
              }
              "expr" = "sum by (kubernetes_node, device, mountpoint) ((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 60 and ON (instance, device, mountpoint) (predict_linear(node_filesystem_avail_bytes{fstype!~\"tmpfs\",mountpoint!~\"/var/lib/kubelet\"}[7d], 60 * 3600) / node_filesystem_size_bytes * 100) < 10 and ON (instance, device, mountpoint) node_filesystem_readonly == 0)"
              "for"  = "10m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P3-Minor"
              }
            },
            {
              "alert" = "NodeLowDisk"
              "annotations" = {
                "message" = "{{ $labels.device }} on {{ $labels.nodename }} has {{ printf \"%.2f\" $value }}% available disk space."
              }
              "expr" = "sum by (nodename, device, mountpoint, fstype) (node_filesystem_avail_bytes / node_filesystem_size_bytes * on(instance,job) group_left(nodename) node_uname_info * 100) < 15"
              "for"  = "5m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P4-Warning"
              }
            },
            {
              "alert" = "NodeLowCPU"
              "annotations" = {
                "message" = "{{ $labels.nodename }} has {{ printf \"%.2f\" $value }}% available CPU."
              }
              "expr" = "avg_over_time(node_cpu_available[3m:]) < 15"
              "for"  = "5m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P4-Warning"
              }
            },
            {
              "alert" = "NodeLowPodCapacity"
              "annotations" = {
                "message" = "{{ $labels.node }} pod capacity is {{ printf \"%.2f\" $value }}% full."
              }
              "expr" = "sum(kube_pod_info) by (node) / sum(kube_node_status_allocatable_pods) by (node) * 100 > 90"
              "for"  = "5m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P4-Warning"
              }
            },
          ]
        },
        {
          "name" = "prometheus-extended.rules"
          "rules" = [
            {
              "alert" = "PrometheusStorageLow"
              "annotations" = {
                "message" = "Prometheus storage has {{ printf \"%.2f\" $value }}% capacity remaining."
              }
              "expr" = "sum by (persistentvolumeclaim, namespace, node)  (kubelet_volume_stats_available_bytes{persistentvolumeclaim=\"${var.prometheus_pvc_name}\"} / kubelet_volume_stats_capacity_bytes{persistentvolumeclaim=\"${var.prometheus_pvc_name}\"}) * 100 < 15"
              "for"  = "15m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
          ]
        },
        {
          "name" = "velero.rules"
          "rules" = [
            {
              "expr"   = "sum by(schedule) (velero_backup_failure_total{schedule!=\"\"} - velero_backup_failure_total offset 10m)"
              "record" = "velero_schedule_failure_increment"
            },
            {
              "expr"   = "sum by(schedule) (velero_backup_partial_failure_total{schedule!=\"\"} - velero_backup_partial_failure_total offset 10m)"
              "record" = "velero_schedule_partial_failure_increment"
            },
            {
              "alert" = "VeleroBackupFailure"
              "annotations" = {
                "message" = "Failed backup in Velero schedule {{ $labels.schedule }}."
              }
              "expr" = "velero_schedule_failure_increment > 0"
              "for"  = "15s"
              "labels" = {
                "resolves" = "never"
                "scope"    = "cluster"
                "severity" = "P3-Minor"
              }
            },
            {
              "alert" = "VeleroBackupPartialFailure"
              "annotations" = {
                "message" = "Partially failed backup in Velero schedule {{ $labels.schedule }}."
              }
              "expr" = "velero_schedule_partial_failure_increment > 0"
              "for"  = "15s"
              "labels" = {
                "resolves" = "never"
                "scope"    = "cluster"
                "severity" = "P3-Minor"
              }
            },
            {
              "alert" = "ContinuousVeleroBackupFailure"
              "annotations" = {
                "message" = "Continuous failed backup in Velero schedule {{ $labels.schedule }}!"
              }
              "expr" = "velero_schedule_failure_increment > 1"
              "for"  = "10m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P1-Critical"
              }
            },
            {
              "alert" = "ContinuousVeleroBackupPartialFailure"
              "annotations" = {
                "message" = "Continuous partially failed backup in Velero schedule {{ $labels.schedule }}!"
              }
              "expr" = "velero_schedule_partial_failure_increment > 1"
              "for"  = "10m"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P1-Critical"
              }
            },
            {
              "alert" = "VeleroHourlyBackupFailure"
              "annotations" = {
                "message" = "Hourly failure in backup schedule {{ $labels.schedule }}!"
              }
              "expr" = "sum by(schedule) (velero_backup_failure_total{schedule=\"velero-hourly-resources\"} - velero_backup_failure_total{schedule=\"velero-hourly-resources\"} offset 160m > 1)"
              "for"  = "15s"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
            {
              "alert" = "VeleroHourlyBackupPartialFailure"
              "annotations" = {
                "message" = "Hourly partial failure in backup schedule {{ $labels.schedule }}."
              }
              "expr" = "sum by(schedule) (velero_backup_partial_failure_total{schedule=\"velero-hourly-resources\"} - velero_backup_partial_failure_total{schedule=\"velero-hourly-resources\"} offset 160m > 1)"
              "for"  = "15s"
              "labels" = {
                "scope"    = "cluster"
                "severity" = "P2-Major"
              }
            },
          ]
        },
      ]
    }
  }
}
