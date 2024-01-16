resource "azurerm_resource_group" "rg_psql" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_subnet" "psql" {
  name                 = "psql-${var.cluster_name}"
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.psql_address_prefixes]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "psql_dns_zone" {
  name                = "${var.cluster_name}.private.postgres.database.azure.com"
  resource_group_name = var.vnet_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "psql_dns_zone_vnet_associate" {
  name                  = "${var.cluster_name}-psql_dns_zone_vnet_associate"
  resource_group_name   = var.vnet_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.psql_dns_zone.name
  virtual_network_id    = var.vnet_id

  depends_on = [
    azurerm_private_dns_zone.psql_dns_zone
  ]
}

# Generate PostgreSQL admin random password
resource "random_password" "psql_admin_password" {
  length           = 20
  special          = true
  lower            = true
  upper            = true
  override_special = "!#$"
}

# Store PostgreSQL admin password in Azuure Key Vault
resource "azurerm_key_vault_secret" "psql_kv_admin_password" {
  name         = "${var.cluster_name}-psql-db-password"
  value        = random_password.psql_admin_password.result
  key_vault_id = var.key_vault_id
  depends_on = [
    random_password.psql_admin_password,
  ]
}

# Create the Azure PostgreSQL - Flexible Server using terraform
resource "azurerm_postgresql_flexible_server" "psql" {
  name                   = "psql-${var.cluster_name}"
  resource_group_name    = azurerm_resource_group.rg_psql.name
  location               = azurerm_resource_group.rg_psql.location
  version                = var.psql_version
  delegated_subnet_id    = azurerm_subnet.psql.id
  private_dns_zone_id    = azurerm_private_dns_zone.psql_dns_zone.id
  administrator_login    = var.psql_admin_login
  administrator_password = azurerm_key_vault_secret.psql_kv_admin_password.value
  storage_mb             = var.psql_storage_mb
  auto_grow_enabled      = false
  zone                   = "3"

  # Set the backup retention policy to 7 for non-prod, and 30 for prod
  backup_retention_days = 7
  sku_name              = var.psql_sku_name
}

# Create the Azure PostgreSQL - Flexible Server Read Replica using terraform
resource "azurerm_postgresql_flexible_server" "psql_read_replica" {
  name                   = "psql-read-${var.cluster_name}"
  resource_group_name    = azurerm_resource_group.rg_psql.name
  location               = azurerm_resource_group.rg_psql.location
  version                = var.psql_version
  delegated_subnet_id    = azurerm_subnet.psql.id
  private_dns_zone_id    = azurerm_private_dns_zone.psql_dns_zone.id
  administrator_login    = var.psql_admin_login
  administrator_password = azurerm_key_vault_secret.psql_kv_admin_password.value
  storage_mb             = var.psql_storage_mb
  auto_grow_enabled      = false
  zone                   = "3"

  # Set the backup retention policy to 7 for non-prod, and 30 for prod
  backup_retention_days = 7
  sku_name              = var.psql_sku_name

  create_mode      = "Replica"
  source_server_id = azurerm_postgresql_flexible_server.psql.id
}

resource "azurerm_postgresql_flexible_server_database" "bifrost" {
  name      = "bifrost"
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "ultron" {
  name      = "ultron"
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "lago" {
  name      = "lago"
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "shield" {
  name      = "shield"
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "loki" {
  name      = "loki"
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "gct" {
  name      = "gct"
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "cro" {
  name      = "cro"
  server_id = azurerm_postgresql_flexible_server.psql.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
