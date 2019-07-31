variable "helm_service_account" {}
variable "helm_namespace" {}
variable "chart_version" {}

variable "dependencies" {
  type = "list"
}

variable "values" {
  default = ""
  type = "string"
}
