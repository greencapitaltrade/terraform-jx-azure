variable "resource_group_name" {
  type = string
  default = "rg-node"
}
variable "vnet_cidr" {
  type = string
}
variable "subnet_cidr" {
  type = string
}
variable "network_name" {
  type = string
  default = ""
}

variable "subnet_id" {
  type = string
}
variable "subnet_name" {
  type = string
  
}
variable "location" {
  type = string
}

variable "vm_username" {
  type        = string
  description = "Username for vm-1"
  default = "azureuser"
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "Password for vm-1"
  default = "password123!"
}