resource "azurerm_virtual_network" "cluster" {
  name                = var.network_name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "cluster_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.cluster.name
  address_prefixes     = [var.subnet_cidr]
}

# resource "azurerm_subnet" "gateway_subnet" {
#   count                = var.private_cluster_enabled ? 1 : 0
#   name                 = "GatewaySubnet" # This name is mandatory for VPN gateway
#   resource_group_name  = var.resource_group
#   virtual_network_name = azurerm_virtual_network.cluster.name
#   address_prefixes     = [var.gateway_cidr]
# }

# resource "azurerm_public_ip" "vpn_gateway_public_ip" {
#   count               = var.private_cluster_enabled ? 1 : 0
#   name                = join(var.network_name, ["vpn-gateway-public-ip"])
#   location            = var.location
#   resource_group_name = var.resource_group
#   allocation_method   = "Dynamic"
# }

# resource "azurerm_virtual_network_gateway" "vpn_gateway" {
#   count               = var.private_cluster_enabled ? 1 : 0
#   name                = join(var.network_name, ["vpn-gateway"])
#   location            = var.location
#   resource_group_name = var.resource_group

#   type     = "Vpn"
#   vpn_type = "RouteBased"

#   active_active = false
#   enable_bgp    = false
#   sku           = "VpnGw1"

#   ip_configuration {
#     name                          = join(var.network_name, ["vpn-gateway-ip-config"])
#     public_ip_address_id          = azurerm_public_ip.vpn_gateway_public_ip[0].id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.gateway_subnet[0].id
#   }

#   custom_route {
#     address_prefixes = []
#   }

#   vpn_client_configuration {
#     aad_audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
#     aad_issuer   = "https://sts.windows.net/${local.tenant_id}/"
#     aad_tenant   = "https://login.microsoftonline.com/${local.tenant_id}/"
#     address_space = [
#       "11.0.0.0/24",
#     ]
#     vpn_client_protocols = [
#       "OpenVPN",
#     ]
#   }
# }
