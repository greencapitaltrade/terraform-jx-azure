// ----------------------------------------------------------------------------
// Enforce Terraform version
//
// ----------------------------------------------------------------------------
terraform {
  required_version = ">= 1.4.6"
  required_providers {
    azurerm = {
      version = ">= 3.0.0"
    }
  }
}

// ----------------------------------------------------------------------------
// Retrieve active subscription resources are being created in
// ----------------------------------------------------------------------------
data "azurerm_subscription" "current" {
}

// ----------------------------------------------------------------------------
// Setup Azure Resource Groups
// ----------------------------------------------------------------------------

resource "azurerm_resource_group" "cluster" {
  name     = local.cluster_resource_group_name
  location = var.location
}



// ----------------------------------------------------------------------------
// Setup Azure Cluster
// ----------------------------------------------------------------------------

module "cluster" {
  depends_on                       = [module.vnet]
  source                           = "./cluster"
  cluster_name                     = var.cluster_name
  dns_prefix                       = local.dns_prefix
  cluster_version                  = var.cluster_version
  location                         = var.location
  resource_group_name              = local.cluster_resource_group_name
  network_resource_group           = local.network_resource_group_name
  cluster_network_model            = var.cluster_network_model
  node_resource_group_name         = var.cluster_node_resource_group_name
  enable_log_analytics             = var.enable_log_analytics
  logging_retention_days           = var.logging_retention_days
  node_count                       = var.node_count
  min_node_count                   = var.min_node_count
  max_node_count                   = var.max_node_count
  node_size                        = var.node_size
  ml_node_count                    = var.ml_node_count
  min_ml_node_count                = var.min_ml_node_count
  max_ml_node_count                = var.max_ml_node_count
  ml_node_size                     = var.ml_node_size
  use_spot                         = var.use_spot
  spot_max_price                   = var.spot_max_price
  build_node_size                  = var.build_node_size
  build_node_count                 = var.build_node_count
  min_build_node_count             = var.min_build_node_count
  max_build_node_count             = var.max_build_node_count
         
  
  maintenance_window = {
    allowed = [
      {
        day   = "Tuesday",
        hours = 23
      },
    ]
    not_allowed = [
      {
        start = "2035-01-01T21:00:00Z",
        end   = "2035-01-01T21:00:00Z"
      },
    ]
  }
  maintenance_window_node_os = {
    frequency  = "Daily"
    interval   = 1
    start_time = "07:00"
    utc_offset = "+01:00"
    duration   = 16
  }
  

}

// ----------------------------------------------------------------------------
// Setup Azure Vnet in to which to deploy Cluster
// ----------------------------------------------------------------------------

module "vnet" {
  source                             = "./vnet"
  resource_group_name                = var.cluster_node_resource_group_name
  vnet_cidr                          = var.vnet_cidr
  subnet_cidr                        = var.subnet_cidr
  subnet_id                          = var.subnet_name
  network_name                       = var.network_name
  subnet_name                        = var.subnet_name
  location                           = var.location
  vm_username                        = var.vm_username
  vm_password                        = var.vm_password 
  depends_on = [azurerm_resource_group.cluster]
}


