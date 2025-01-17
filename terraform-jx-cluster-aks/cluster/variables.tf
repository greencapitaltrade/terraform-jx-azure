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
// App nodepool variables
// ----------------------------------------------------------------------------
variable "app_use_spot" {
  type        = bool
  default     = true
  description = "Should we use spot instances for the app nodes"
}
variable "app_spot_max_price" {
  type        = number
  default     = -1
  description = "The maximum price you're willing to pay in USD per virtual machine, -1 to go to the maximum price"
}
variable "app_node_size" {
  type        = string
  default     = ""
  description = "The size of the app node to use for the cluster"
}
variable "app_node_count" {
  description = "The number of app nodes to use for the cluster"
  type        = number
  default     = null
}
variable "min_app_node_count" {
  description = "The minimum number of app nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}
variable "max_app_node_count" {
  description = "The maximum number of app nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}

// ----------------------------------------------------------------------------
// JX nodepool variables
// ----------------------------------------------------------------------------
variable "jx_node_size" {
  type        = string
  default     = ""
  description = "The size of the jx node to use for the cluster"
}
variable "jx_node_count" {
  description = "The number of jx nodes to use for the cluster"
  type        = number
  default     = null
}
variable "min_jx_node_count" {
  description = "The minimum number of jx nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}
variable "max_jx_node_count" {
  description = "The maximum number of jx nodes to use for the cluster if autoscaling is enabled"
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
  type = number
}
variable "sku_tier" {
  type    = string
  default = "Standard"
}
variable "automatic_channel_upgrade" {
  type    = string
  default = "patch"
}
variable "private_cluster_enabled" {
  type = bool
}
variable "vpn_public_ip" {
  type = string
}
variable "service_cidr" {
  type = string
}
variable "dns_service_ip" {
  type = string
}
variable "docker_bridge_cidr" {
  type = string
}
variable "ingress_ip_name" {
  type        = string
  description = "Name for the IP resource used for ingress"
}
