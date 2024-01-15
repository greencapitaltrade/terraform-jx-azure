resource "azurerm_resource_group" "storage" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                             = local.account_name
  location                         = var.location
  resource_group_name              = azurerm_resource_group.storage.name
  account_replication_type         = "RAGRS"
  account_tier                     = "Standard"
  account_kind                     = "StorageV2"
  is_hns_enabled                   = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  min_tls_version                  = "TLS1_2"
}

resource "azurerm_storage_container" "logs" {
  name                 = "logs"
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_role_assignment" "storage" {
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.storage.id
  principal_id         = var.storage_principal_id
}
