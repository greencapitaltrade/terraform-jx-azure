variable "resource_group" {
  type = string
}
variable "vnet_cidr" {
  type = string
}
variable "subnet_cidr" {
  type = string
}
variable "gateway_cidr" {
  type = string
}
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

variable "egress_ip_name" {
  type        = string
  description = "Name for the IP resource used for egress"
}

variable "ip_resource_group_name" {
  type        = string
  description = "Resource group to be used for the static ips"
}

variable "nat_gateway_name" {
  type        = string
  description = "NAT Gateway name"
}

variable "nat_gateway_resource_group_name" {
  type        = string
  description = "Resource group to be used for the nat gateway"
}
