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
  default     = "1"
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
  default     = "1"
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
  type = string
}
variable "cluster_version" {
  description = "Kubernetes version to use for the AKS cluster."
  type        = string
}
variable "location" {
  type = string
}
variable "vnet_subnet_id" {
  type = string
  default = ""
}
variable "dns_prefix" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "node_resource_group_name" {
  type = string
}
variable "network_resource_group" {
  type = string
}
variable "cluster_network_model" {
  type    = string
  default = "azure"
}
variable "enable_log_analytics" {
  type = bool
}
variable "logging_retention_days" {
  type = number#
}
#variable "automati#c_channel_upgrade" {#
#  type = bool#
#  description = "W#hether to enable automatic channel upgrades for the AKS cluster."#
#  default = "none"#
#}

variable "image_cleaner_enabled" {
  type = bool
  description = "Whether to enable the image cleaner for the AKS cluster."
  default = true
}

variable "image_cleaner_interval_hours" {
  type = number
  description = "The interval in hours at which the image cleaner should run."
  default = 24
}

variable "monitor_metrics" {
  type = list(string)
  description = "A list of metrics to monitor for the AKS cluster."
  default = ["cpu", "memory", "disk"]
}

variable "upgrade_settings" {
  type = object({
    max_surge = number
    max_unavailable = number
    node_upgrade_timeout = string
    pause_before_upgrade = bool
  })
  description = "The upgrade settings for the AKS cluster."
  default = {
    max_surge = 33
    max_unavailable = 1
    node_upgrade_timeout = "10m"
    pause_before_upgrade = false
  }
}


variable "private_cluster_enabled" {
  type = bool
  description = "Whether to enable private cluster mode for the AKS cluster."
  default = true
}

variable "private_dns_zone_id" {
  type = string
  description = "The ID of the private DNS zone for the AKS cluster."
  default = "System"
}

variable "workload_identity_enabled" {
  type = bool
  description = "Whether to enable workload identity for the AKS cluster."
  default = true
}

variable "public_network_access_enabled" {
  type = bool
  description = "Whether to enable public network access for the AKS cluster."
  default = false
}
variable "agents_pool_max_surge" {
  type        = number
  default     = 1
  description = "The maximum number or percentage of nodes which will be added to the Default Node Pool size during an upgrade."
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
    day_of_month = optional(number)
    day_of_week  = optional(string)
    duration     = number
    frequency    = string
    interval     = number
    start_date   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    week_index   = optional(string)
    not_allowed = optional(set(object({
      end   = string
      start = string
    })))
  })
   default     = null

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