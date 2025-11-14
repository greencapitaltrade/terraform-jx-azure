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
  description = "Should we use spot instances for the build nodes"
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
// Stateful nodepool variables
// ----------------------------------------------------------------------------
variable "stateful_node_size" {
  type        = string
  default     = ""
  description = "The size of the stateful node to use for the cluster"
}
variable "stateful_node_count" {
  description = "The number of stateful nodes to use for the cluster"
  type        = number
  default     = null
}
variable "min_stateful_node_count" {
  description = "The minimum number of stateful nodes to use for the cluster if autoscaling is enabled"
  type        = number
  default     = null
}
variable "max_stateful_node_count" {
  description = "The maximum number of stateful nodes to use for the cluster if autoscaling is enabled"
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
  default = ""
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
variable "service_cidr" {
  type = string
}
variable "dns_service_ip" {
  type = string
}
variable "docker_bridge_cidr" {
  type = string
}
variable "network_name" {
  type    = string
  default = ""
}
variable "cluster_network_model" {
  type    = string
  default = "kubenet"
}
variable "subnet_name" {
  type    = string
  default = ""
}
variable "enable_log_analytics" {
  type    = bool
  default = false
}
variable "logging_retention_days" {
  type    = number
  default = 30
}
variable "private_cluster_enabled" {
  type    = bool
  default = false
}
variable "apex_domain" {
  type        = string
  description = "The parent / apex domain to be used for the cluster"
}
variable "subdomain" {
  description = "Optional sub domain for the installation"
  type        = string
}
variable "ingress_ip_name" {
  type        = string
  description = "Name for the IP resource used for ingress"
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
