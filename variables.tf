variable "helm_namespace" {}

variable "helm_repository" {}
variable "helm_repository_password" {
  default = ""
}
variable "helm_repository_username" {
  default = ""
}

variable "chart_version" {}

variable "dependencies" {
  type = "list"
}

variable "values" {
  default = ""
  type    = "string"
}
