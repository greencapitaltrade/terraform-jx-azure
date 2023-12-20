output "subnet_id" {
  value = azurerm_subnet.cluster_subnet.id
}

output "vpn_public_ip" {
  value = azurerm_public_ip.vpn_gateway_public_ip[0].value
}