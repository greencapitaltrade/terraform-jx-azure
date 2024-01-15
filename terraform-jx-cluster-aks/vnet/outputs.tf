output "subnet_id" {
  value = azurerm_subnet.cluster_subnet.id
}

output "vpn_public_ip" {
  value = azurerm_public_ip.vpn_gateway_public_ip.ip_address
}

output "egress_public_ip" {
  value = azurerm_public_ip.egress_ip.ip_address
}

output "vnet_id" {
  value = azurerm_virtual_network.cluster.id
}

output "vnet_name" {
  value = azurerm_virtual_network.cluster.name
}
