output "helm_service_account" {
  value = "${var.helm_service_account}"
}

output "helm_namespace" {
  value = "${var.helm_namespace}"
}

output "status" {
  value = "${helm_release.prometheus_operator.id}"
}

# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
# and
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-473091030
output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}
