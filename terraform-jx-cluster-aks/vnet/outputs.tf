output "subnet_id" {
  value = azurerm_subnet.cluster_subnet.id
}

output "vpn_public_ip" {
  value = var.private_cluster_enabled ? azurerm_public_ip.vpn_gateway_public_ip[0].ip_address : null
}
