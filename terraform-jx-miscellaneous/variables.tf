variable "location" {
  type    = string
  default = "centralindia"
}

variable "subscription_id" {
  type = string
}

// MongoDB
variable "mongo_disk_size" {
  type = number
}
variable "mongo_resource_group_name" {
  type        = string
  description = "Resource group to create in which to place mongodb disks"
  default     = ""
}
variable "mongo_storage_type" {
  type = string
}
