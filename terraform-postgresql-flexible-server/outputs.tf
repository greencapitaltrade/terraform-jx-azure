output "pg_host_address" {
  value = azurerm_private_dns_zone.psql_dns_zone.name
}
