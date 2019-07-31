provider "helm" {
  version         = "~> v0.9.1"
  service_account = "${var.helm_service_account}"
  namespace       = "${var.helm_namespace}"
  install_tiller  = "true"
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.13.0"

  kubernetes {  }
}
