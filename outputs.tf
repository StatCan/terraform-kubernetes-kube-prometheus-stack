output "helm_namespace" {
  value = var.helm_namespace
}

output "status" {
  value = helm_release.kube_prometheus_stack.id
}

output "helm_release" {
  value = var.helm_release
  description = "The name of the Helm release. For use by external ServiceMonitors"
}

# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
# and
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-473091030
output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}
