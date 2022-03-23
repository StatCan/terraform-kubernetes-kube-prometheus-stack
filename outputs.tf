output "helm_namespace" {
  value = var.helm_namespace
}

output "status" {
  value = helm_release.kube_prometheus_stack.id
}

output "helm_release" {
  value       = var.helm_release
  description = "The name of the Helm release. For use by external ServiceMonitors"
}
