// ----------------------------------------------------------------------------
// Machine variables
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// System nodepool variables
// ----------------------------------------------------------------------------
variable "node_size" {
  type        = string
  default     = "Standard_B2ms"
  description = "The size of the worker node to use for the cluster"
}
variable "node_count" {
  description = "The number of worker nodes to use for the cluster"
  type        = number
  default     = 2
}
variable "min_node_count" {
  description = "The minimum number of worker nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}
variable "max_node_count" {
  description = "The maximum number of worker nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}
// ----------------------------------------------------------------------------
// Machine learning nodepool variables
// ----------------------------------------------------------------------------
variable "ml_node_size" {
  type        = string
  default     = ""
  description = "The size of the worker node to use for the cluster"
}
variable "ml_node_count" {
  description = "The number of ML nodes to use for the cluster"
  type        = number
  default     = null
}
variable "min_ml_node_count" {
  description = "The minimum number of ML nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}
variable "max_ml_node_count" {
  description = "The maximum number of ML nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}

// ----------------------------------------------------------------------------
// Build nodepool variables
// ----------------------------------------------------------------------------
variable "use_spot" {
  type        = bool
  default     = false
  description = "Should we use spot instances for the build nodes"
}
variable "spot_max_price" {
  type        = number
  default     = -1
  description = "The maximum price you're willing to pay in USD per virtual machine, -1 to go to the maximum price"
}
variable "build_node_size" {
  type        = string
  default     = ""
  description = "The size of the build node to use for the cluster"
}
variable "build_node_count" {
  description = "The number of build nodes to use for the cluster"
  type        = number
  default     = null
}
variable "min_build_node_count" {
  description = "The minimum number of builder nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}
variable "max_build_node_count" {
  description = "The maximum number of builder nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}

// ----------------------------------------------------------------------------
// Cluster variables
// ----------------------------------------------------------------------------
variable "cluster_name" {
  type    = string
  default = ""
}
variable "dns_prefix" {
  type    = string
  default = ""
}
variable "cluster_version" {
  type    = string
  default = "1.21.7"
}
variable "location" {
  type    = string
  default = "centralindia"
}
variable "network_resource_group_name" {
  type    = string
  default = ""
}
variable "cluster_resource_group_name" {
  type    = string
  default = ""
}
variable "cluster_node_resource_group_name" {
  type    = string
  default = "rg-node"
}
variable "vnet_cidr" {
  type    = string
  default = "10.8.0.0/16"
}
variable "subnet_cidr" {
  type    = string
  default = "10.8.0.0/24"
}
variable "network_name" {
  type    = string
  default = ""
}
variable "cluster_network_model" {
  type    = string
  default = "Azure"
}
variable "subnet_name" {
  type    = string
}
variable "enable_log_analytics" {
  type    = bool
  default = false
}
variable "logging_retention_days" {
  type    = number
  default = 30
}

variable "maintenance_window" {
  type = object({
    allowed = list(object({
      day   = string
      hours = number
    })),
    not_allowed = list(object({
      end   = string
      start = string
    })),
  })
  default     = null
  description = "(Optional) Maintenance configuration of the managed cluster."
}

variable "maintenance_window_node_os" {
  type = object({
    day_of_month = number
    day_of_week  = string
    duration     = number
    frequency    = string
    interval     = string
    start_date   = string
    start_time   = string
    utc_offset   = string
    week_index   = string
    not_allowed = set(object({
      end   = string
      start = string
    }))
  })
   default     = null
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
  default = "test1234!"
}

 #day_of_month` -
 #day_of_week` - (Optional) The day of the week for the maintenance run. Options are `Monday`, `Tuesday`, `Wednesday`, `Thurday`, `Friday`, `Saturday` and `Sunday`. Required in combination with weekly frequency.
 #duration` - (Required) The duration of the window for maintenance to run in hours.
 #frequency` - (Required) Frequency of maintenance. Possible options are `Daily`, `Weekly`, `AbsoluteMonthly` and `RelativeMonthly`.
 #interval` - (Required) The interval for maintenance runs. Depending on the frequency this interval is week or month based.
 #start_date` - (Optional) The date on which the maintenance window begins to take effect.
 #start_time` - (Optional) The time for maintenance to begin, based on the timezone determined by `utc_offset`. Format is `HH:mm`.
 #utc_offset` - (Optional) Used to determine the timezone for cluster maintenance.
 #week_index` - (Optional) The week in the month used for the maintenance run. Options are `First`, `Second`, `Third`, `Fourth`, and `Last`