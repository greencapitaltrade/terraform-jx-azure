variable "resource_group" {
  type = string
}
variable "vnet_cidr" {
  type = string
}
variable "subnet_cidr" {
  type = string
}
# variable "gateway_cidr" {
#   type    = string
# }
variable "network_name" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "location" {
  type = string
}
variable "apex_domain" {
  type        = string
  description = "The parent / apex domain to be used for the cluster"
}
variable "subdomain" {
  description = "Optional sub domain for the installation"
  type        = string
}
variable "private_cluster_enabled" {
  type = bool
}
