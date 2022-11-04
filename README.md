# Terraform Kubernetes Kube-Prometheus Stack

## Introduction

This module deploys and configures the Kube-Prometheus Stack inside a Kubernetes Cluster.

## Security Controls

The following security controls can be met through configuration of this template:

* TBD

## Dependencies

* None

## Optional (depending on options configured):

* None

## Usage

```terraform
module "helm_kube_prometheus_stack" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-kubernetes-kube-prometheus-stack?ref=v2.0.0"

  chart_version = "13.10.0"
  depends_on = [
    module.namespace_monitoring,
  ]

  helm_namespace  = module.namespace_monitoring.name
  helm_release    = "kube-prometheus-stack"
  helm_repository = "https://prometheus-community.github.io/helm-charts"

  enable_destinationrules = true
  enable_prometheusrules  = true

  # Set release to the same value as helm_release. Optionally, add any other desired labels. This variable can be omitted when using the default release name kube-prometheus-stack or when not enabling the additional PrometheusRules.
  prometheusrules_labels = {
    app     = "kube-prometheus-stack"
    release = "kube-prometheus-stack"
  }

  values = <<EOF

EOF
}
```

### Notes

 To upgrade an existing Helm release created from the [previous module](#previous-module) instead of reinstalling into a new Helm release, set `helm_release` to `"prometheus-operator"`. This will persist Helm release history and some temporary data, but may result in resource name and label aberrations. 
 
 It is alternatively possible to reinstall into a new release while persisting existing data in Persistent Volumes from the previous module. This process involves downtime and does not guarantee data compatibility. A guide is available [here](#https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#redeploy-with-new-name-downtime). Note that there are further steps if multiple components (e.g. both Prometheus and Grafana) were configured with Persistent Volume storage. Their Persistent Volumes will need to be given different labels, and the components' `volumeClaimTemplate`s (defined in Helm values) will need to be given corresponding [selectors](https://docs.openshift.com/container-platform/3.3/install_config/persistent_storage/selector_label_binding.html#selector-label-volume-define).

## Variables Values

| Name                     | Type   | Required | Value                                                          |
| ------------------------ | ------ | -------- | -------------------------------------------------------------- |
| chart_version            | string | yes      | Version of the Helm chart                                      |
| helm_namespace           | string | yes      | The namespace Helm will install the chart under                |
| helm_release             | string | no       | The name of the Helm release. Default `kube-prometheus-stack`  |
| helm_repository          | string | no       | The repository where the Helm chart is stored                  |
| helm_repository_username | string | no       | The username of the repository where the Helm chart is stored  |
| helm_repository_password | string | no       | The password of the repository where the Helm chart is stored  |
| enable_destinationrules  | bool   | no       | For Prometheus, Alertmanager, Grafana, and Node Exporters      |
| destinationrules_mode    | string | no       | DestinationRule TLS mode. Default `DISABLE`                    |
| destinationrules_labels  | map    | no       | Labels for DestinationRules                                    |
| cluster_domain           | string | no       | Cluster domain for DestinationRules. Default `cluster.local`   |
| enable_prometheusrules   | bool   | no       | Adds PrometheusRules for general cluster and namespace alerts  |
| prometheusrules_labels   | map    | no       | Labels for general cluster and namespace alert PrometheusRules |
| cluster_rules_name       | string | no       | PrometheusRule name. Default `general-cluster-alerts`          |
| namespace_rules_name     | string | no       | PrometheusRule name. Default `general-namespace-alerts`        |
| prometheus_pvc_name      | string | no       | Used for storage alert. Set if using non-default helm_release  |
| values                   | list   | no       | Values to be passed to the Helm Chart                          |
| cert_manager_rules_name  | string | no       | PrometheusRule name. Default `cert-manager-alerts`             |

## History

| Date       | Release    | Change                                                                                                            |
| ---------- | ---------- | ----------------------------------------------------------------------------------------------------------------- |
| 2021-03-26 | v1.0.0     | 1st release                                                                                                       |
| 2021-07-05 | v1.1.0     | 1st set of general project alerts                                                                                 |
| 2021-09-07 | v1.1.1     | `CompletedJobsNotCleared` scope set to `project`                                                                  | 
| 2022-03-16 | v2.0.0     | Convert DestinationRules and PrometheusRules to `kubernetes_manifest`s. Updates for Terraform v1 and nomenclature |
| 2022-07-28 | v2.0.1     | PrometheusRule severity label updates                                                                             |
| 2022-08-10 | v2.0.2     | Refactor the threshold for the VeleroHourlyBackupPartialFailure & VeleroHourlyBackupFailure alert.                |
| 2022-08-10 | v2.0.3     | Create the NodeDiskMayFillIn60Hours alert.                                                                        |
| 2022-08-10 | v2.0.4     | Delete the ManyAlertsFiring & ManyManyAlertsFiring alerts                                                         |
| 2022-08-19 | v2.0.5     | Create the VeleroBackupTakingLongTime alert                                                                       |
| 2022-08-22 | v2.0.6     | Fix the VeleroBackupTakingLongTime alert severity level                                                           |
| 2022-08-31 | v2.0.7     | Update nodepool pod capacity alerts and remove unused recording rule                                              |
| 2022-09-02 | v2.0.8     | Update threshold for when to expect a backup for the VeleroBackupTakingLongTime alert                             |
| 2022-11-4  | v2.0.9     | Added several alerts and associated test cases regarding cert manager certificates 


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
