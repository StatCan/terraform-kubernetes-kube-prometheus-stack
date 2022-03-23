resource "helm_release" "kube_prometheus_stack" {
  name = var.helm_release

  repository          = var.helm_repository
  repository_username = var.helm_repository_username
  repository_password = var.helm_repository_password

  chart     = "kube-prometheus-stack"
  version   = var.chart_version
  namespace = var.helm_namespace
  timeout   = 1200

  values = [
    var.values,
  ]
}
