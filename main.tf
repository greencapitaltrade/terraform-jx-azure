terraform {
  required_version = ">= 0.13.2"
  required_providers {
    random = {
      version = ">=3.0.0"
    }
    kubernetes = {
      version = ">=1.13.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
    tls = {
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstategct"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "kubernetes" {
  host = "https://jxgct-devhost-phs4o6xz.hcp.centralindia.azmk8s.io:443" # module.cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(
    module.cluster.ca_certificate,
  )
  client_certificate = base64decode(
    module.cluster.client_certificate,
  )
  client_key = base64decode(
    module.cluster.client_key,
  )
}

provider "helm" {
  kubernetes {

    host = "https://jxgct-devhost-phs4o6xz.hcp.centralindia.azmk8s.io:443" # module.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(
      module.cluster.ca_certificate,
    )
    client_certificate = base64decode(
      module.cluster.client_certificate,
    )
    client_key = base64decode(
      module.cluster.client_key,
    )
  }
}

resource "kubernetes_storage_class" "azure_ssd_retain" {
  metadata {
    name = "ssd-retain"
  }

  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname = "Premium_LRS"
    kind    = "Managed"
  }

  reclaim_policy         = "Retain"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "azure_ssd_delete" {
  metadata {
    name = "ssd-delete"
  }

  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname = "Premium_LRS"
    kind    = "Managed"
  }

  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "azure_standard_retain" {
  metadata {
    name = "standard-retain"
  }

  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname = "Standard_LRS"
    kind    = "Managed"
  }

  reclaim_policy         = "Retain"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "azure_standard_delete" {
  metadata {
    name = "standard-delete"
  }

  storage_provisioner = "disk.csi.azure.com"
  parameters = {
    skuname = "Standard_LRS"
    kind    = "Managed"
  }

  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "azure_file_ssd_retain" {
  metadata {
    name        = "file-ssd-retain"
    annotations = {}
    labels      = {}
  }

  storage_provisioner = "file.csi.azure.com"
  parameters = {
    skuname = "Premium_LRS"
    kind    = "Managed"
  }

  reclaim_policy         = "Retain"
  allow_volume_expansion = true
  volume_binding_mode    = "Immediate"
  mount_options = [
    "actimeo=30",
    "cache=strict",
    "dir_mode=0777",
    "file_mode=0777",
    "gid=0",
    "mfsymlinks",
    "uid=0",
  ]
}

resource "kubernetes_storage_class" "azure_file_ssd_delete" {
  metadata {
    name = "file-ssd-delete"
  }

  storage_provisioner = "file.csi.azure.com"
  parameters = {
    skuname = "Premium_LRS"
    kind    = "Managed"
  }

  allow_volume_expansion = true
  volume_binding_mode    = "Immediate"
  mount_options = [
    "actimeo=30",
    "cache=strict",
    "dir_mode=0777",
    "file_mode=0777",
    "gid=0",
    "mfsymlinks",
    "uid=0",
  ]
}

resource "kubernetes_storage_class" "azure_file_standard_retain" {
  metadata {
    name        = "file-standard-retain"
    annotations = {}
    labels      = {}
  }

  storage_provisioner = "file.csi.azure.com"
  parameters = {
    skuname = "Standard_LRS"
    kind    = "Managed"
  }

  reclaim_policy         = "Retain"
  allow_volume_expansion = true
  volume_binding_mode    = "Immediate"
  mount_options = [
    "actimeo=30",
    "cache=strict",
    "dir_mode=0777",
    "file_mode=0777",
    "gid=0",
    "mfsymlinks",
    "uid=0",
  ]
}

resource "kubernetes_storage_class" "azure_file_standard_delete" {
  metadata {
    name        = "file-standard-delete"
    annotations = {}
    labels      = {}
  }

  storage_provisioner = "file.csi.azure.com"
  parameters = {
    skuname = "Standard_LRS"
    kind    = "Managed"
  }

  allow_volume_expansion = true
  volume_binding_mode    = "Immediate"
  mount_options = [
    "actimeo=30",
    "cache=strict",
    "dir_mode=0777",
    "file_mode=0777",
    "gid=0",
    "mfsymlinks",
    "uid=0",
  ]
}

module "cluster" {
  source                           = "./terraform-jx-cluster-aks"
  cluster_name                     = local.cluster_name
  cluster_network_model            = var.cluster_network_model
  cluster_node_resource_group_name = var.cluster_node_resource_group_name
  cluster_resource_group_name      = var.cluster_resource_group_name
  cluster_version                  = var.cluster_version
  enable_log_analytics             = var.enable_log_analytics
  location                         = var.location
  logging_retention_days           = var.logging_retention_days
  network_resource_group_name      = var.network_resource_group_name
  network_name                     = var.network_name
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
  app_use_spot                     = var.app_use_spot
  app_spot_max_price               = var.app_spot_max_price
  app_node_size                    = var.app_node_size
  app_node_count                   = var.app_node_count
  min_app_node_count               = var.min_app_node_count
  max_app_node_count               = var.max_app_node_count
  jx_node_size                     = var.jx_node_size
  jx_node_count                    = var.jx_node_count
  min_jx_node_count                = var.min_jx_node_count
  max_jx_node_count                = var.max_jx_node_count
  subnet_name                      = var.subnet_name
  subnet_cidr                      = var.subnet_cidr
  vnet_cidr                        = var.vnet_cidr
  private_cluster_enabled          = var.private_cluster_enabled
  subdomain                        = var.subdomain
  apex_domain                      = var.apex_domain
  gateway_cidr                     = var.gateway_cidr
  service_cidr                     = var.service_cidr
  dns_service_ip                   = var.dns_service_ip
  docker_bridge_cidr               = var.docker_bridge_cidr
  ingress_ip_name                  = var.ingress_ip_name
  egress_ip_name                   = var.egress_ip_name
  ip_resource_group_name           = var.ip_resource_group_name
  nat_gateway_name                 = var.nat_gateway_name
  nat_gateway_resource_group_name  = var.nat_gateway_resource_group_name
}

module "registry" {
  source                               = "./terraform-jx-registry-acr"
  cluster_name                         = local.cluster_name
  resource_group_name                  = var.registry_resource_group_name
  principal_id                         = module.cluster.kubelet_identity_id
  location                             = var.location
  use_existing_acr_name                = var.use_existing_acr_name
  use_existing_acr_resource_group_name = var.use_existing_acr_resource_group_name
}

module "jx-boot" {
  source               = "./terraform-jx-boot"
  depends_on           = [module.cluster]
  jx_git_url           = var.jx_git_url
  jx_bot_username      = var.jx_bot_username
  jx_bot_token         = var.jx_bot_token
  job_secret_env_vars  = local.job_secret_env_vars
  install_vault        = !var.key_vault_enabled
  install_kuberhealthy = var.install_kuberhealthy
}

module "dns" {
  source                          = "./terraform-jx-azuredns"
  apex_domain_integration_enabled = var.apex_domain_integration_enabled
  apex_domain                     = var.apex_domain
  apex_resource_group_name        = var.apex_resource_group_name
  cluster_name                    = local.cluster_name
  subdomain                       = var.subdomain
  location                        = var.location
  principal_id                    = module.cluster.kubelet_identity_id
  resource_group_name             = var.dns_resource_group_name
}

module "secrets" {
  source              = "./terraform-jx-azurekeyvault"
  enabled             = var.key_vault_enabled
  principal_id        = module.cluster.kubelet_identity_id
  cluster_name        = local.cluster_name
  resource_group_name = var.key_vault_resource_group_name
  key_vault_name      = var.key_vault_name
  key_vault_sku       = var.key_vault_sku
  location            = var.location
  secret_map          = local.merged_secrets
}

module "storage" {
  source               = "./terraform-jx-azure-storage"
  resource_group_name  = var.storage_resource_group_name
  cluster_name         = local.cluster_name
  location             = var.location
  storage_principal_id = module.cluster.kubelet_identity_id
}

module "postgesql" {
  source                   = "./terraform-postgresql-flexible-server"
  cluster_name             = local.cluster_name
  location                 = var.location
  vnet_resource_group_name = module.cluster.vnet_resource_group_name
  vnet_id                  = module.cluster.vnet_id
  vnet_name                = module.cluster.vnet_name
  key_vault_id             = module.secrets.key_vault_id
}

output "connect" {
  description = "Connect to cluster"
  value       = module.cluster.connect
}

output "kube_config_admin" {
  value     = module.cluster.kube_config_admin_raw
  sensitive = true
}

output "vpn_public_ip" {
  value = module.cluster.vpn_public_ip
}

output "ingress_public_ip" {
  value = module.cluster.ingress_public_ip
}

output "egress_public_ip" {
  value = module.cluster.egress_public_ip
}

output "pg_host_address" {
  value = module.postgesql.pg_host_address
}
