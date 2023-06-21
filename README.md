# Terraform Kubernetes Kube-Prometheus Stack

## Introduction

This module deploys and configures the Kube-Prometheus Stack inside a Kubernetes Cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Helm chart | `any` | n/a | yes |
| <a name="input_helm_namespace"></a> [helm\_namespace](#input\_helm\_namespace) | The namespace Helm will install the chart under | `any` | n/a | yes |
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | Cluster domain for DestinationRules | `string` | `"cluster.local"` | no |
| <a name="input_destinationrules_labels"></a> [destinationrules\_labels](#input\_destinationrules\_labels) | Labels applied to DestinationRules | `map(string)` | `{}` | no |
| <a name="input_destinationrules_mode"></a> [destinationrules\_mode](#input\_destinationrules\_mode) | DestionationRule TLS mode | `string` | `"DISABLE"` | no |
| <a name="input_enable_destinationrules"></a> [enable\_destinationrules](#input\_enable\_destinationrules) | Creates DestinationRules for Prometheus, Alertmanager, Grafana, and Node Exporters | `bool` | `false` | no |
| <a name="input_enable_prometheusrules"></a> [enable\_prometheusrules](#input\_enable\_prometheusrules) | Adds PrometheusRules for alerts | `bool` | `true` | no |
| <a name="input_helm_release"></a> [helm\_release](#input\_helm\_release) | The name of the Helm release | `string` | `"kube-prometheus-stack"` | no |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | The repository where the Helm chart is stored | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_helm_repository_password"></a> [helm\_repository\_password](#input\_helm\_repository\_password) | The password of the repository where the Helm chart is stored | `string` | `""` | no |
| <a name="input_helm_repository_username"></a> [helm\_repository\_username](#input\_helm\_repository\_username) | The username of the repository where the Helm chart is stored | `string` | `""` | no |
| <a name="input_prometheus_pvc_name"></a> [prometheus\_pvc\_name](#input\_prometheus\_pvc\_name) | Used for storage alert. Set if using non-default helm\_release | `string` | `"prometheus-kube-prometheus-stack-prometheus-db-prometheus-kube-prometheus-stack-prometheus-0"` | no |
| <a name="input_values"></a> [values](#input\_values) | Values to be passed to the Helm chart | `string` | `""` | no |
| <a name="alertmanager_replicas"></a> [alertmanager_replicas](#alertmanager\_replicas) | Number of replicas for Alertmanager | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_namespace"></a> [helm\_namespace](#output\_helm\_namespace) | n/a |
| <a name="output_helm_release"></a> [helm\_release](#output\_helm\_release) | The name of the Helm release. For use by external ServiceMonitors |
| <a name="output_status"></a> [status](#output\_status) | n/a |
<!-- END_TF_DOCS -->

## Usage

```terraform
module "helm_kube_prometheus_stack" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-kubernetes-kube-prometheus-stack?ref=v3.3.0"

  chart_version = "43.3.0"
  depends_on = [
    module.namespace_monitoring,
  ]

  helm_namespace  = module.namespace_monitoring.name
  helm_release    = "kube-prometheus-stack"
  helm_repository = "https://prometheus-community.github.io/helm-charts"

  enable_destinationrules = true

  values = <<EOF

EOF
}
```

### Notes

 To upgrade an existing Helm release created from the [previous module](#previous-module) instead of reinstalling into a new Helm release, set `helm_release` to `"prometheus-operator"`. This will persist Helm release history and some temporary data, but may result in resource name and label aberrations.

 It is alternatively possible to reinstall into a new release while persisting existing data in Persistent Volumes from the previous module. This process involves downtime and does not guarantee data compatibility. A guide is available [here](#https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#redeploy-with-new-name-downtime). Note that there are further steps if multiple components (e.g. both Prometheus and Grafana) were configured with Persistent Volume storage. Their Persistent Volumes will need to be given different labels, and the components' `volumeClaimTemplate`s (defined in Helm values) will need to be given corresponding [selectors](https://docs.openshift.com/container-platform/3.3/install_config/persistent_storage/selector_label_binding.html#selector-label-volume-define).

## History

| Date       | Release | Change |
| ---------- | ------- | ------ |
| 2021-03-26 | v1.0.0  | 1st release |
| 2021-07-05 | v1.1.0  | 1st set of general project alerts |
| 2021-09-07 | v1.1.1  | `CompletedJobsNotCleared` scope set to `project` |
| 2022-03-16 | v2.0.0  | Convert DestinationRules and PrometheusRules to `kubernetes_manifest`s. Updates for Terraform v1 and nomenclature |
| 2022-07-28 | v2.0.1  | PrometheusRule severity label updates |
| 2022-08-10 | v2.0.2  | Refactor the threshold for the VeleroHourlyBackupPartialFailure & VeleroHourlyBackupFailure alert |
| 2022-08-10 | v2.0.3  | Create the NodeDiskMayFillIn60Hours alert |
| 2022-08-10 | v2.0.4  | Delete the ManyAlertsFiring & ManyManyAlertsFiring alerts |
| 2022-08-19 | v2.0.5  | Create the VeleroBackupTakingLongTime alert |
| 2022-08-22 | v2.0.6  | Fix the VeleroBackupTakingLongTime alert severity level |
| 2022-08-31 | v2.0.7  | Update nodepool pod capacity alerts and remove unused recording rule |
| 2022-09-02 | v2.0.8  | Update threshold for when to expect a backup for the VeleroBackupTakingLongTime alert |
| 2022-11-04 | v2.1.0  | Add several alerts and associated test cases regarding cert manager certificates |
| 2022-11-08 | v2.1.1  | Adjust ContainerWaiting alert duration to align with PodNotReady |
| 2022-11-16 | v2.1.2  | Fix node and nodepool pod capacity, NodePodsFull, and NodeReachingPodCapacity alerts |
| 2022-11-24 | v2.2.0  | Add alert: PrometheusDiskMayFillIn60Hours |
| 2022-12-06 | v2.3.0  | Add alert: NodeReadinessFlapping |
| 2022-12-15 | v2.3.1  | Fix the NodeUnschedulable alert severity level |
| 2023-01-04 | v3.0.0  | Refactor general cluster and namespace alerts. enable_prometheusrules false->true. Removes variables: prometheusrules_labels, cluster_rules_name, namespace_rules_name, cert_manager_rules_name |
| 2023-01-09 | v3.1.0  | Add runbook links to Prometheus rules |
| 2023-01-11 | v3.1.1  | Fix ManyContainerRestarts alert to account for multiple metrics sources |
| 2023-02-01 | v3.2.0  | Node clock alerts and README update |
| 2023-02-03 | v3.2.1  | Specify sensitive variables |
| 2023-02-08 | v3.3.0  | Add abilitity to add DestinationRule for Alertmanager replicas |
| 2023-02-16 | v3.4.0  | Add rules for CoreDNS alerts |
| 2023-03-10 | v3.4.1  | Fix syntax error in CoreDNS alert rules |
| 2023-03-14 | v3.5.0  | Add rule for ContainerImagePullProblem, refactor container alert unit tests |
| 2023-03-15 | v3.6.0  | Add DestinationRule for Thanos Sidecar |
| 2023-03-28 | v3.7.0  | Add generic PVC alerts |
| 2023-04-05 | v3.8.0  | Add "cluster" in prometheus rule aggregations to make compatible with Thanos. Add Prometheus heartbeat recording rule |
| 2023-04-19 | v3.8.1  | Fix CoreDNSDown alert |
| 2023-04-21 | v3.8.2  | Ensure prometheus heartbeat recording rule is evaluated by Prometheus |
| 2023-05-04 | v3.8.3  | Fix ContainerImagePullProblem flapping |
| 2023-06-08 | v3.9.0  | Ignore terminated pods in pod capacity alerts |
| 2023-06-19 | v3.9.1  | Fix PersistentVolume status alerts |

## Upgrading

### From v1.x to v2.x
1. Note that in [Usage](#usage) the `dependencies` array has been replaced by the `depends_on` array.

2. If **`enable_destinationrules`** was `true` in **v1.x**, locate the DestinationRules that were created in `helm_namespace`. There should be 4 correspoding to Prometheus, Alertmanager, Grafana, and the Prometheus Node Exporter. Delete them prior to the upgrade. If `enable_destinationrules` remains true, they will be recreated with minimal downtime.

3. If **`enable_prometheusrules`** was `true` in **v1.x**, locate the PrometheusRule definitions that were created in `helm_namespace`. There should be 2: `general-platform-alerts` and `general-project-alerts`. Delete them prior to the upgrade. If `enable_prometheusrules` remains true, they will be recreated. This may resolve any presently firing alerts. If it does, they will fire again once their conditions are met.

    - The default names for these PrometheusRule resources are now `general-cluster-alerts` and `general-namespace-alerts`. The scopes have changed from `platform` to `cluster` and from `project` to `namespace`. Adjust Alertmanager routing criteria accordingly.
    - The severities for these rules have been adjusted from `minor/major/urgent` to `debug/minor/major`. Adjust Alertmanager routing criteria accordingly.



## Previous Module

This module replaces [terraform-kubernetes-prometheus](https://github.com/StatCan/terraform-kubernetes-prometheus). The previous module used the custom chart [prometheus-operator](https://github.com/StatCan/charts/tree/master/stable/prometheus-operator), which used the now-deprecated upstream chart [prometheus-operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) as a sub-chart and added DestinationRules.

This new module uses the new upstream chart [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) directly. DestinationRules, as well as a set of general alerts, can be added through the module.

To migrate from the old custom chart to the new upstream chart, the following changes should be made to Helm values:

1. Remove the top-level `prometheus-operator:` and realign indentation, as you are no longer applying values to a subchart.
2. Remove any ` destinationRule:` specification and its contents, as this is now handled by [terraform variables](#variables-values).

The upstream `prometheus-operator` chart was renamed to `kube-prometheus-stack` to reflect that additional components beyond the Prometheus Operator are installed.
