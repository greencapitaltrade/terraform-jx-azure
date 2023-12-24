resource "azurerm_managed_disk" "mongodb_disk" {
  name                 = "mongodb-disk"
  location             = var.location
  resource_group_name  = var.mongo_resource_group_name != "" ? var.mongo_resource_group_name : "rg-mongo-${join("", regexall("[A-Za-z0-9\\-_().]", "disk"))}"
  storage_account_type = var.mongo_storage_type == "" ? "PremiumV2_LRS" : var.mongo_storage_type
  create_option        = "Empty"
  disk_size_gb         = var.mongo_disk_size
}
