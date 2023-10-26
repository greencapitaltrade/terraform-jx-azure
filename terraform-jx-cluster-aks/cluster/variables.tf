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
  default     = true
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
  default = "kubenet"
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

variable "maintenance_window" {
  type = list(object({
    start_date_time = string
    expiration_date_time = string
    recurrence = string
  }))
  description = "A list of maintenance windows for the AKS cluster."
  default = []
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
  default = false
}

#variable "private_dns_zone_id" {
#  type = string
#  description = "The ID of the private DNS zone for the AKS cluster."
#  default = "System"
#}

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
