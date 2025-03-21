variable "grafana_auth" {
  type      = string
  sensitive = true
}
variable "grafana_name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "grafana_managed_identity" {
  type = string
}
