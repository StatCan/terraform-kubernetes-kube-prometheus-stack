# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
# and
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-473091030
# Make sure to add this null_resource.dependency_getter to the `depends_on`
# attribute to all resource(s) that will be constructed first within this
# module:
resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.dependencies)}"
  }
}

resource "null_resource" "wait-dependencies" {
  provisioner "local-exec" {
    command = "helm ls --tiller-namespace ${var.helm_namespace}"
  }

  depends_on = [
    "null_resource.dependency_getter",
  ]
}

resource "helm_release" "prometheus_operator" {
  depends_on = ["null_resource.wait-dependencies", "null_resource.dependency_getter"]
  name = "prometheus-operator"
  repository = "${var.helm_repository}"
  chart = "prometheus-operator"
  version = "${var.chart_version}"
  namespace = "${var.helm_namespace}"
  timeout = 1200

  values = [
    "${var.values}",
  ]
}

# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
resource "null_resource" "dependency_setter" {
  # Part of a hack for module-to-module dependencies.
  # https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
  # List resource(s) that will be constructed last within the module.
  depends_on = [
    "helm_release.prometheus_operator",
  ]
}
