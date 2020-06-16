# Terraform Kubernetes Prometheus

## Introduction

This module deploys and configures Prometheus inside a Kubernetes Cluster.

## Security Controls

The following security controls can be met through configuration of this template:

* TBD

## Dependencies

* None

## Optional (depending on options configured):

* None

## Usage

```terraform
module "helm_prometheus_operator" {
  source = "github.com/canada-ca-terraform-modules/terraform-kubernetes-prometheus?ref=20190909.1"

  chart_version = "0.0.2"
  dependencies = [
    "${module.namespace_monitoring.depended_on}",
    "${module.helm_istio.depended_on}",
  ]

  helm_namespace = "${module.namespace_monitoring.name}"
  helm_repository = "stable"

  values = <<EOF

EOF
}
```

## Variables Values

| Name                 | Type   | Required | Value                                               |
| -------------------- | ------ | -------- | --------------------------------------------------- |
| chart_version        | string | yes      | Version of the Helm Chart                           |
| dependencies         | string | yes      | Dependency name refering to namespace module        |
| helm_namespace       | string | yes      | The namespace Helm will install the chart under     |
| helm_repository      | string | yes      | The repository where the Helm chart is stored       |
| resource_id          | string | yes      | The resource id to be used for the Managed Identity |
| client_id            | string | yes      | The client id to be used for the Managed Identity   |
| values               | list   | no       | Values to be passed to the Helm Chart               |

## History

| Date     | Release    | Change                                                     |
| -------- | ---------- | ---------------------------------------------------------- |
| 20190729 | 20190729.1 | Improvements to documentation and formatting               |
| 20190909 | 20190909.1 | 1st release                                                |
| 20200616 | v2.0.0     | Helm 3 modifications                                       |