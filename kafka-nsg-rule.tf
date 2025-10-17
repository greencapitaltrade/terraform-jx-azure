# NSG rule to allow Kafka port 9092 for external access
resource "azurerm_network_security_rule" "kafka_port_9092" {
  name                        = "kafka-port-9092"
  priority                    = 506
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9092"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "rg-cluster-node-gct-dev"
  network_security_group_name = "aks-agentpool-94141784-nsg"
  description                 = "Allow external Kafka connections on port 9092"
}