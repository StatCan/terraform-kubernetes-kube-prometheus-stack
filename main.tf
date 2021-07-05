# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
# and
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-473091030
# Make sure to add this null_resource.dependency_getter to the `depends_on`
# attribute to all resource(s) that will be constructed first within this
# module:
resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = join(",", var.dependencies)
  }

  lifecycle {
    ignore_changes = [
      triggers["my_dependencies"],
    ]
  }
}

resource "helm_release" "kube_prometheus_stack" {
  depends_on = [null_resource.dependency_getter]
  name       = var.helm_release

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

resource "local_file" "kube_prometheus_stack_destinationrules" {
  count = var.enable_destinationrules ? 1 : 0
  sensitive_content = templatefile("${path.module}/config/destinationrules.yaml", {
    helm_release            = var.helm_release
    helm_namespace          = var.helm_namespace
    destinationrules_mode   = var.destinationrules_mode
    destinationrules_prefix = var.destinationrules_prefix
    cluster_domain          = var.cluster_domain
  })

  filename = "${path.module}/kube-prometheus-stack-destinationrules.yaml"
}

resource "null_resource" "apply_destinationrules" {
  count = var.enable_destinationrules ? 1 : 0
  depends_on = [
    null_resource.dependency_getter,
    local_file.kube_prometheus_stack_destinationrules[0]
  ]
  triggers = {
    manifests = local_file.kube_prometheus_stack_destinationrules[0].sensitive_content,
    namespace = var.helm_namespace
  }

  provisioner "local-exec" {
    command = "kubectl -n ${var.helm_namespace} apply -f ${local_file.kube_prometheus_stack_destinationrules[0].filename}"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "kubectl -n ${self.triggers.namespace} delete -f - <<EOF\n${self.triggers.manifests}\nEOF"
    on_failure = continue
  }
}

resource "local_file" "kube_prometheus_stack_general_platform_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  sensitive_content = templatefile("${path.module}/config/general-platform-alerts.yaml", {
    helm_release        = var.helm_release
    helm_namespace      = var.helm_namespace
    prometheus_pvc_name = var.prometheus_pvc_name
  })

  filename = "${path.module}/kube-prometheus-stack-general-platform-alerts.yaml"
}

resource "null_resource" "apply_general_platform_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  depends_on = [
    null_resource.dependency_getter,
    local_file.kube_prometheus_stack_general_platform_alerts[0]
  ]
  triggers = {
    manifest = local_file.kube_prometheus_stack_general_platform_alerts[0].sensitive_content
  }

  provisioner "local-exec" {
    command = "kubectl -n ${var.helm_namespace} apply -f ${local_file.kube_prometheus_stack_general_platform_alerts[0].filename}"
  }
}

resource "null_resource" "delete_general_platform_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  depends_on = [
    null_resource.dependency_getter,
    local_file.kube_prometheus_stack_general_platform_alerts[0]
  ]
  triggers = {
    namespace = var.helm_namespace
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "kubectl -n ${self.triggers.namespace} delete prometheusrule general-platform-alerts"
    on_failure = continue
  }
}

resource "local_file" "kube_prometheus_stack_general_project_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  sensitive_content = templatefile("${path.module}/config/general-project-alerts.yaml", {
    helm_release   = var.helm_release
    helm_namespace = var.helm_namespace
  })

  filename = "${path.module}/kube-prometheus-stack-general-project-alerts.yaml"
}

resource "null_resource" "apply_general_project_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  depends_on = [
    null_resource.dependency_getter,
    local_file.kube_prometheus_stack_general_project_alerts[0]
  ]
  triggers = {
    manifest = local_file.kube_prometheus_stack_general_project_alerts[0].sensitive_content
  }

  provisioner "local-exec" {
    command = "kubectl -n ${var.helm_namespace} apply -f ${local_file.kube_prometheus_stack_general_project_alerts[0].filename}"
  }
}

resource "null_resource" "delete_general_project_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  depends_on = [
    null_resource.dependency_getter,
    local_file.kube_prometheus_stack_general_project_alerts[0]
  ]
  triggers = {
    namespace = var.helm_namespace
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "kubectl -n ${self.triggers.namespace} delete prometheusrule general-project-alerts"
    on_failure = continue
  }
}

# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
resource "null_resource" "dependency_setter" {
  # Part of a hack for module-to-module dependencies.
  # https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
  # List resource(s) that will be constructed last within the module.
  depends_on = [
    helm_release.kube_prometheus_stack,
  ]
}
