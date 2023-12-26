resource "random_pet" "name" {
}

locals {
  tenant_id        = data.azurerm_subscription.current.tenant_id
  egress_ip_name   = var.egress_ip_name != "" ? join("", regexall("[A-Za-z0-9\\-]", var.egress_ip_name)) : join("", regexall("[A-Za-z0-9\\-]", random_pet.name.id))
  nat_gateway_name = var.nat_gateway_name != "" ? join("", regexall("[A-Za-z0-9\\-]", var.nat_gateway_name)) : join("", regexall("[A-Za-z0-9\\-]", random_pet.name.id))
}
