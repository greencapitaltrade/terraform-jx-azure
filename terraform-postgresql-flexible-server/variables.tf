variable "resource_group_name" {
  description = "Name of the psql resource group, used to autogenerate some variables if they are not supplied"
  type        = string
  default     = ""
}
variable "cluster_name" {
  description = "Variable to provide your desired name for the cluster. The script will create a random name if this is empty"
  type        = string
  default     = ""
}
variable "location" {
  type        = string
  default     = "centralindia"
  description = "The Azure region in to which to provision the cluster"
}
variable "vnet_resource_group_name" {
  type        = string
  description = "Name of the vnet resource group"
}
variable "vnet_id" {
  description = "Virtual network id for subnet"
  type        = string
}
variable "vnet_name" {
  description = "Virtual network name for subnet"
  type        = string
}
variable "key_vault_id" {
  description = "Key vault id for storage of DB password"
  type        = string
}
variable "psql_version" {
  description = "Psql version"
  type        = number
  default     = 14
}
variable "psql_address_prefixes" {
  description = "Psql subnet ip range"
  type        = string
  default     = "10.2.0.0/24"
}
variable "psql_storage_mb" {
  description = "(Optional) The max storage allowed for the PostgreSQL Flexible Server. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216 and 33553408."
  type        = string
  default     = "262144"
}
variable "psql_sku_name" {
  description = "(Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3). "
  type        = string
  default     = "GP_Standard_D2s_v3"
  validation {
    condition     = contains(["B_Standard_B1ms", "GP_Standard_D2s_v3", "MO_Standard_E4s_v3"], var.psql_sku_name)
    error_message = "The value of the sku name property of the PostgreSQL is invalid."
  }
}
variable "psql_admin_login" {
  description = "(Optional) Admin username of the PostgreSQL server"
  type        = string
  default     = "postgres"
}
