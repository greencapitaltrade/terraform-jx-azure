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

  default_node_pool {
    name                 = "default"
    vm_size              = var.node_size
    vnet_subnet_id       = var.vnet_subnet_id
    node_count           = var.node_count
    min_count            = var.min_node_count
    max_count            = var.max_node_count
    orchestrator_version = var.cluster_version
    enable_auto_scaling  = var.max_node_count == null ? false : true
    os_disk_size_gb      = 30
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
  name                  = "mlnode"
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
  os_disk_size_gb = 256
}

resource "azurerm_kubernetes_cluster_node_pool" "buildnode" {
  count                 = var.build_node_size == "" ? 0 : 1
  name                  = "buildnode"
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
  os_disk_size_gb = 80
}

resource "azurerm_kubernetes_cluster_node_pool" "appnode" {
  count                 = var.app_node_size == "" ? 0 : 1
  name                  = "appnode"
  priority              = var.app_use_spot ? "Spot" : "Regular"
  eviction_policy       = var.app_use_spot ? "Delete" : null
  spot_max_price        = var.app_use_spot ? var.app_spot_max_price : null
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.app_node_size
  vnet_subnet_id        = var.vnet_subnet_id
  node_count            = var.app_use_spot ? 15 : var.app_node_count
  min_count             = var.min_app_node_count
  max_count             = var.max_app_node_count
  orchestrator_version  = var.cluster_version
  enable_auto_scaling   = var.max_app_node_count == null ? false : true
  node_taints           = concat(["sku=app:NoSchedule", "pool=spot:NoSchedule"], var.use_spot ? ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"] : [])
  node_labels = merge({
    "gc-t.in.priority" = var.app_use_spot ? "spot" : "regular"
    }, var.app_use_spot ? {
    "cloud.google.com/gke-spot"             = "true"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  } : {})
  os_disk_size_gb = 30
}

resource "azurerm_kubernetes_cluster_node_pool" "jxnode" {
  count                 = var.jx_node_size == "" ? 0 : 1
  name                  = "jxnode"
  priority              = "Regular"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.jx_node_size
  vnet_subnet_id        = var.vnet_subnet_id
  node_count            = var.jx_node_count
  min_count             = var.min_jx_node_count
  max_count             = var.max_jx_node_count
  orchestrator_version  = var.cluster_version
  enable_auto_scaling   = var.max_jx_node_count == null ? false : true
  os_disk_size_gb       = 30
}
