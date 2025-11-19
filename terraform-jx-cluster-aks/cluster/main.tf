resource "azurerm_kubernetes_cluster" "aks" {
  name                                = var.cluster_name
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  node_resource_group                 = var.node_resource_group_name
  dns_prefix                          = var.dns_prefix
  kubernetes_version                  = var.cluster_version
  sku_tier                            = var.sku_tier
  automatic_channel_upgrade           = var.automatic_channel_upgrade
  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = true
  image_cleaner_enabled               = true
  image_cleaner_interval_hours        = 48
  workload_identity_enabled           = true
  oidc_issuer_enabled                 = true

  default_node_pool {
    name                        = "default"
    vm_size                     = var.node_size
    vnet_subnet_id              = var.vnet_subnet_id
    node_count                  = var.max_node_count == null ? var.node_count : null
    min_count                   = var.min_node_count
    max_count                   = var.max_node_count
    orchestrator_version        = var.cluster_version
    enable_auto_scaling         = var.max_node_count == null ? false : true
    os_disk_size_gb             = 30
    temporary_name_for_rotation = "defaulttemp"
  }

  network_profile {
    network_plugin = var.cluster_network_model
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [
      "34657806-ad6d-41f8-87cc-017e41264d92"
    ]
  }

  auto_scaler_profile {
    # Aggressive scale-down configuration for cost optimization
    scale_down_delay_after_add       = "10m"    # Default: 10m, aggressive: 10m
    scale_down_delay_after_delete    = "20s"    # Default: 10s, aggressive: 20s  
    scale_down_delay_after_failure   = "3m"     # Default: 3m, aggressive: 3m
    scale_down_unneeded              = "10m"    # Default: 10m, aggressive: 10m
    scale_down_unready               = "20m"    # Default: 20m, aggressive: 20m
    scale_down_utilization_threshold = "0.5"    # Default: 0.5, aggressive: 0.5
    max_graceful_termination_sec     = "600"    # Default: 600s, aggressive: 600s
    balance_similar_node_groups      = true     # Enable balancing for efficiency
    expander                        = "random"  # Use random expander for cost optimization
    max_unready_nodes               = 3        # Default: 3
    max_unready_percentage          = 45       # Default: 45%
    new_pod_scale_up_delay          = "0s"     # Default: 0s, immediate scale-up
    skip_nodes_with_local_storage   = false    # Default: false
    skip_nodes_with_system_pods     = true     # Default: true
  }
}

# Data source to check current VPA status
data "external" "vpa_status" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  program = ["bash", "-c", <<-EOT
    vpa_enabled=$(az aks show --name ${var.cluster_name} --resource-group ${var.resource_group_name} --query "workloadAutoScalerProfile.verticalPodAutoscaler.enabled" --output tsv 2>/dev/null || echo "false")
    echo "{\"vpa_enabled\": \"$vpa_enabled\"}"
  EOT
  ]
}

# Enable Vertical Pod Autoscaler (VPA) using Azure CLI
resource "null_resource" "enable_vpa" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  provisioner "local-exec" {
    command = "az aks update --resource-group ${var.resource_group_name} --name ${var.cluster_name} --enable-vpa"
  }

  # Re-run whenever VPA gets disabled or cluster changes
  triggers = {
    cluster_id = azurerm_kubernetes_cluster.aks.id
    kubernetes_version = azurerm_kubernetes_cluster.aks.kubernetes_version
    vpa_enabled = data.external.vpa_status.result.vpa_enabled
    # Force re-run if VPA is disabled
    force_enable = data.external.vpa_status.result.vpa_enabled == "false" ? timestamp() : "enabled"
  }
}

# resource "azurerm_public_ip" "ingress_ip" {
#   name                = var.ingress_ip_name
#   location            = var.location
#   resource_group_name = var.node_resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

resource "azurerm_kubernetes_cluster_node_pool" "mlnode" {
  count                 = var.ml_node_size == "" ? 0 : 1
  name                  = "ml"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.ml_node_size
  vnet_subnet_id        = var.vnet_subnet_id
  node_count            = var.ml_node_count
  min_count             = var.min_ml_node_count
  max_count             = var.max_ml_node_count
  orchestrator_version  = var.cluster_version
  enable_auto_scaling   = var.max_ml_node_count == null ? false : true
  node_taints           = ["sku=gpu:NoSchedule", "pool=gpu:NoSchedule"]
  node_labels = merge({
    "gc-t.in.priority" = var.use_spot ? "spot" : "regular"
    }, var.use_spot ? {
    "cloud.google.com/gke-spot"             = "true"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  } : {})
  os_disk_size_gb = 30
}

resource "azurerm_kubernetes_cluster_node_pool" "buildnode" {
  count                 = var.build_node_size == "" ? 0 : 1
  name                  = "build"
  priority              = var.use_spot ? "Spot" : "Regular"
  eviction_policy       = var.use_spot ? "Delete" : null
  spot_max_price        = var.use_spot ? var.spot_max_price : null
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.build_node_size
  vnet_subnet_id        = var.vnet_subnet_id
  node_count            = var.use_spot ? 1 : var.build_node_count
  min_count             = var.min_build_node_count
  max_count             = var.max_build_node_count
  orchestrator_version  = var.cluster_version
  enable_auto_scaling   = var.max_build_node_count == null ? false : true
  node_taints           = concat(["sku=build:NoSchedule", "pool=builder:NoSchedule"], var.use_spot ? ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"] : [])
  node_labels = merge({
    "gc-t.in.priority" = var.use_spot ? "spot" : "regular"
    }, var.use_spot ? {
    "cloud.google.com/gke-spot"             = "true"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  } : {})
  os_disk_size_gb = 30
}

resource "azurerm_kubernetes_cluster_node_pool" "statelessnode" {
  count                 = var.app_node_size == "" ? 0 : 1
  name                  = "stateless"
  priority              = var.app_use_spot ? "Spot" : "Regular"
  eviction_policy       = var.app_use_spot ? "Delete" : null
  spot_max_price        = var.app_use_spot ? var.app_spot_max_price : null
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.app_node_size
  vnet_subnet_id        = var.vnet_subnet_id
  node_count            = var.app_node_count
  min_count             = var.min_app_node_count
  max_count             = var.max_app_node_count
  orchestrator_version  = var.cluster_version
  enable_auto_scaling   = var.max_app_node_count == null ? false : true
  node_taints           = concat(["sku=app:NoSchedule", "pool=spot:NoSchedule"], var.app_use_spot ? ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"] : [])
  node_labels = merge({
    "gc-t.in.priority" = var.app_use_spot ? "spot" : "regular"
    "agentpool" = "stateless"
    }, var.app_use_spot ? {
    "cloud.google.com/gke-spot"             = "true"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  } : {})
  os_disk_size_gb = 30
}


resource "azurerm_kubernetes_cluster_node_pool" "statefulnode" {
  count                 = var.stateful_node_size == "" ? 0 : 1
  name                  = "stateful"
  priority              = "Regular"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.stateful_node_size
  vnet_subnet_id        = var.vnet_subnet_id
  node_count            = var.stateful_node_count
  min_count             = var.min_stateful_node_count
  max_count             = var.max_stateful_node_count
  orchestrator_version  = var.cluster_version
  enable_auto_scaling   = var.max_stateful_node_count == null ? false : true
  
  # Simplified taint for stateful workloads isolation
  node_taints = [
    "workload=stateful:NoSchedule"
  ]
  
  node_labels = {
    "gc-t.in.priority" = "regular"
    "agentpool" = "stateful"
  }
  
  # Standard OS disk size - persistent storage via PVCs
  os_disk_size_gb = 30
}
