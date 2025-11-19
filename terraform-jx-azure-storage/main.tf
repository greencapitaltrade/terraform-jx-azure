resource "azurerm_resource_group" "storage" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                             = local.account_name
  location                         = var.location
  resource_group_name              = azurerm_resource_group.storage.name
  account_replication_type         = "LRS"  # Changed from RAGRS to LRS (6x cost reduction)
  account_tier                     = "Standard"
  account_kind                     = "StorageV2"
  access_tier                      = "Cool"  # Start with Cool tier for cost savings
  is_hns_enabled                   = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  min_tls_version                  = "TLS1_2"
}

resource "azurerm_role_assignment" "storage" {
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.storage.id
  principal_id         = var.storage_principal_id
}

# Consolidated Storage for Jenkins-X and Application Archives
# Database backups are handled automatically by Azure PostgreSQL (30-day retention)

# Consolidated containers in main storage account for different retention needs
resource "azurerm_storage_container" "logs" {
  name                  = "logs"  # Jenkins-X build logs
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "longterm_archive" {
  name                  = "longterm-archive"  # 7 years retention
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "mediumterm_archive" {
  name                  = "mediumterm-archive"  # 3 years retention  
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "shortterm_archive" {
  name                  = "shortterm-archive"  # 1 year retention
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}


# Consolidated Lifecycle Management Policy for all containers
resource "azurerm_storage_management_policy" "consolidated_lifecycle" {
  storage_account_id = azurerm_storage_account.storage.id

  # Build logs lifecycle - Keep for 90 days, move to archive, delete after 1 year
  rule {
    name    = "build-logs-lifecycle"
    enabled = true
    
    filters {
      prefix_match = ["logs/"]
      blob_types   = ["blockBlob"]
    }
    
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 7    # Cool after 7 days
        tier_to_archive_after_days_since_modification_greater_than = 30   # Archive after 30 days
        delete_after_days_since_modification_greater_than         = 365   # Delete after 1 year
      }
    }
  }


  # Short-term archive - Archive immediately, delete after 1 year
  rule {
    name    = "shortterm-archive-lifecycle"
    enabled = true
    
    filters {
      prefix_match = ["shortterm-archive/"]
      blob_types   = ["blockBlob"]
    }
    
    actions {
      base_blob {
        tier_to_archive_after_days_since_modification_greater_than = 0    # Archive immediately
        delete_after_days_since_modification_greater_than         = 365   # Delete after 1 year
      }
    }
  }

  # Medium-term archive - Archive immediately, delete after 3 years
  rule {
    name    = "mediumterm-archive-lifecycle"
    enabled = true
    
    filters {
      prefix_match = ["mediumterm-archive/"]
      blob_types   = ["blockBlob"]
    }
    
    actions {
      base_blob {
        tier_to_archive_after_days_since_modification_greater_than = 0    # Archive immediately
        delete_after_days_since_modification_greater_than         = 1095  # Delete after 3 years
      }
    }
  }

  # Long-term archive - Archive immediately, delete after 7 years
  rule {
    name    = "longterm-archive-lifecycle"
    enabled = true
    
    filters {
      prefix_match = ["longterm-archive/"]
      blob_types   = ["blockBlob"]
    }
    
    actions {
      base_blob {
        tier_to_archive_after_days_since_modification_greater_than = 0    # Archive immediately
        delete_after_days_since_modification_greater_than         = 2555  # Delete after 7 years
      }
    }
  }
}
