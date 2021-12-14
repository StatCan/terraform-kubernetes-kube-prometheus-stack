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
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-kubernetes-kube-prometheus-stack?ref=v1.0.0"

  chart_version = "13.10.0"
  dependencies = [
    module.namespace_monitoring.depended_on,
    module.helm_istio.depended_on,
  ]

  helm_namespace  = module.namespace_monitoring.name
  helm_release    = "kube-prometheus-stack"
  helm_repository = "https://prometheus-community.github.io/helm-charts"

  enable_destinationrules = true
  enable_prometheusrules  = true

  values = <<EOF

EOF
}
```

### Notes
 To upgrade an existing Helm release created from the [previous module](#previous-module) instead of reinstalling into a new Helm release, set `helm_release` to `"prometheus-operator"`. This will persist Helm release history and some temporary data, but may result in resource name and label aberrations. 

## Variables Values

| Name                     | Type   | Required | Value                                                         |
| ------------------------ | ------ | -------- | ------------------------------------------------------------- |
| chart_version            | string | yes      | Version of the Helm chart                                     |
| dependencies             | string | yes      | Dependency name referring to namespace module                 |
| helm_namespace           | string | yes      | The namespace Helm will install the chart under               |
| helm_release             | string | no       | The name of the Helm release. Default `kube-prometheus-stack` |
| helm_repository          | string | no       | The repository where the Helm chart is stored                 |
| helm_repository_username | string | no       | The username of the repository where the Helm chart is stored |
| helm_repository_password | string | no       | The password of the repository where the Helm chart is stored |
| enable_destinationrules  | bool   | no       | For Prometheus, Alertmanager, Grafana, and Node Exporters     |
| destinationrules_mode    | string | no       | DestinationRule TLS mode. Default `DISABLE`                   |
| destinationrules_prefix  | string | no       | Set to Prom/AM svc prefix if using non-default helm_release   |
| cluster_domain           | string | no       | Cluster domain for DestinationRules. Default `cluster.local`  |
| enable_prometheusrules   | bool   | no       | Adds Prometheus Rules for general platform and project alerts |
| prometheus_pvc_name      | string | no       | Used for storage alert. Set if using non-default helm_release |
| values                   | list   | no       | Values to be passed to the Helm Chart                         |

## History

| Date       | Release    | Change                                           |
| ---------- | ---------- | ------------------------------------------------ |
| 2021-03-26 | v1.0.0     | 1st release                                      |
| 2021-07-05 | v1.1.0     | 1st set of general project alerts                |
| 2021-09-07 | v1.1.1     | `CompletedJobsNotCleared` scope set to `project` | 

## Previous Module

This module replaces [terraform-kubernetes-prometheus](https://github.com/StatCan/terraform-kubernetes-prometheus). The previous module used the custom chart [prometheus-operator](https://github.com/StatCan/charts/tree/master/stable/prometheus-operator), which used the now-deprecated upstream chart [prometheus-operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) as a sub-chart and added DestinationRules. 

This new module uses the new upstream chart [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) directly. DestinationRules, as well as a set of general platform alerts, can be added through the module.

To migrate from the old custom chart to the new upstream chart, the following changes should be made to Helm values:

1. Remove the top-level `prometheus-operator:` and realign indentation, as you are no longer applying values to a subchart.
2. Remove any ` destinationRule:` specification and its contents, as this is now handled by [terraform variables](#variables-values). 

The upstream `prometheus-operator` chart was renamed to `kube-prometheus-stack` to reflect that additional components beyond the Prometheus Operator are installed.
