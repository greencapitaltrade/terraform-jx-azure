data "azurerm_resource_group" "rg-node" {
  name = "rg-node"
  depends_on = [ azurerm_kubernetes_cluster ]
}
resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  address_space       = ["10.2.0.0/20"]
}

data "azurerm_virtual_network" "aks-vnet" {
  name                = "aks-vnet"
  resource_group_name = data.azurerm_resource_group.rg-node.name
  
}

resource "azurerm_virtual_network_peering" "to_vnet_aks" {
  name                         = "peer-to-vnet-aks"
  resource_group_name          = data.azurerm_resource_group.rg-node.name
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id    = data.azurerm_virtual_network.aks-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "to_vnet_hub" {
  name                         = "peer-to-vnet-hub"
  resource_group_name          = data.azurerm_resource_group.rg-node.name
  virtual_network_name         = data.azurerm_virtual_network.aks-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg-node.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.2.4.0/27"]
}

resource "azurerm_subnet" "global" {
  name                                      = "snet-global"
  resource_group_name                       = data.azurerm_resource_group.rg-node.name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = ["10.2.2.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.rg-node.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.2.3.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_public_ip" "bas" {
  name                = "pip-bas-cac-001"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bas" {
  name                = "bas-pvaks-cac-001"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bas.id
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-vm-1"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.global.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "vm-nsg" {
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name

}
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm-1"
  resource_group_name = data.azurerm_resource_group.rg-node.name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  
   
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}




#resource "azurerm_container_registry" "acr" {
#  name                          = "acrpvakscac"
#  resource_group_name           = data.azurerm_resource_group.rg-node.name
#  location                      = var.location
#  sku                           = "Premium"
#  admin_enabled                 = false
#  public_network_access_enabled = false
#}
#
#resource "azurerm_private_dns_zone" "acr" {
#  name                = "privatelink.azurecr.io"
#  resource_group_name = data.azurerm_resource_group.rg-node.name
#}
#
#resource "azurerm_private_dns_zone_virtual_network_link" "acr1" {
#  name                  = "pdznl-acr-cac-001"
#  resource_group_name   = data.azurerm_resource_group.rg-node.name
#  private_dns_zone_name = azurerm_private_dns_zone.acr.name
#  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
#}
#
#resource "azurerm_private_dns_zone_virtual_network_link" "acr2" {
#  name                  = "pdznl-acr-cac-002"
#  resource_group_name   = data.azurerm_resource_group.rg-node.name
#  private_dns_zone_name = azurerm_private_dns_zone.acr.name
#  virtual_network_id    = azurerm_virtual_network.vnet_aks.id
#}
#
#resource "azurerm_private_endpoint" "acr" {
#  name                = "pe-acr-cac-001"
#  location            = var.location
#  resource_group_name = data.azurerm_resource_group.rg-node.name
#  subnet_id           = azurerm_subnet.global.id
#
#  private_service_connection {
#    name                           = "psc-acr-cac-001"
#    private_connection_resource_id = azurerm_container_registry.acr.id
#    subresource_names              = ["registry"]
#    is_manual_connection           = false
#  }
#
#  private_dns_zone_group {
#    name                 = "pdzg-acr-cac-001"
#    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
#  }
#}
#
resource "azurerm_virtual_wan" "vwan" {
  name                = "virtualwan"
  resource_group_name = data.azurerm_resource_group.rg-node.name
  location            = var.location
}

resource "azurerm_virtual_hub" "vhub" {
  name                = "example-virtualhub"
  resource_group_name = data.azurerm_resource_group.rg-node.name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.0.0.0/23"
}

resource "azurerm_public_ip" "vpn" {
  name                = "pip-vgw-vpn"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  sku                 = "Standard"
  allocation_method   = "Static"
}



resource azurerm_virtual_network_gateway vpn {
  name                = "vgw-vpn"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gatewaysubnet.id
  }

  vpn_client_configuration {
    address_space        = ["10.1.0.0/24"]
    vpn_auth_types       = ["AAD"]
    aad_tenant           = "https://login.microsoftonline.com/09953566-9af5-4e84-afe6-974a5fc25d4b/"
    aad_audience         = "baaa4697-3d5d-4b49-aabd-7219ca7a2095"
    aad_issuer           = "https://sts.windows.net/09953566-9af5-4e84-afe6-974a5fc25d4b/"
    vpn_client_protocols = ["OpenVPN"]
  }

}

resource "azurerm_public_ip" "pip-ngw" {
  name                = "pip-ngw"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_nat_gateway" "ngw" {
  name                = "ngw-NatGateway"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.ngw.id
  public_ip_address_id = azurerm_public_ip.pip-ngw.id
}

resource "azurerm_public_ip" "lb_vpn" {
  name                = "pip-vgw-lb"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  sku                 = "Standard"
  allocation_method   = "Static"
}


resource "azurerm_lb" "lb-vm" {
  name                = "lb-vm"
  sku                 = "Standard"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name

  frontend_ip_configuration {
    name                 = "frontend"
    subnet_id            = azurerm_subnet.global.id
  }
  #frontend_ip_configuration {
  #  name                            = "private"
  #  private_ip_address_allocation   = "Static"
  #  private_ip_address              = "10.0.1.10"
  #  
  #}
}
resource "azurerm_storage_account" "savm" {
  name                     = "nondisns"
  resource_group_name      = data.azurerm_resource_group.rg-node.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_private_link_service" "p-link" {
  name                = "p-link"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
 
  nat_ip_configuration {
    name      = "nat-config"
    primary   = true
    subnet_id = azurerm_subnet.global.id
  }

  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.lb-vm.frontend_ip_configuration.0.id,
  ]
}

data "azurerm_dns_zone" "dns" {
  name                = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_resource_group.rg-node.name
}

resource "azurerm_private_endpoint" "p-enp" {
  name                = "p-enp"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg-node.name
  subnet_id           = azurerm_subnet.global.id
  

 private_service_connection {
    name                           = "p-link"
    private_connection_resource_id = azurerm_storage_account.savm.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.p-dns.name
    private_dns_zone_ids = data.azurerm_dns_zone.dns.id
  }
}


resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  name                  = "vm-link"
  resource_group_name   = data.azurerm_resource_group.rg-node.name
  private_dns_zone_name = data.azurerm_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  depends_on            = [data.azurerm_dns_zone.dns]
}
























#creating a virtual network
#resource "azurerm_virtual_network" "vnet-aks" {
#  name                = var.network_name
#  resource_group_name = azurerm_resource_group.example.name
#  location            = azurerm_resource_group.example.location
#  address_space       = ["10.15.0.0/16"]
#}
#
#resource "azurerm_subnet" "aks_subnet"{
#  name                 = var.subnet_name
#  resource_group_name  = azurerm_resource_group.example.name
#  virtual_network_name = azurerm_virtual_network.aks.name
#  address_prefixes     = ["10.15.1.0/16"]
#  private_link_service_network_policies_enabled = false
#  
#}
#
#############################################################################
#resource "azurerm_virtual_network" "v-vnet" {
#  name                = "v-vnet"
#  resource_group_name = azurerm_resource_group.example.name
#  address_space       = ["10.0.0.0/16"]
#  location            = azurerm_resource_group.example.location
#  
#}
#
#resource "azurerm_network_security_group" "vm-nsg" {
#  name                = "vm-nsg"
#  location            = azurerm_resource_group.example.location
#  resource_group_name =azurerm_resource_group.example.name
#}
#
#
#
#resource "azurerm_subnet" "GatewaySubnet" {
#  name                 = "GatewaySubnet"
#  resource_group_name  = azurerm_resource_group.example.name
#  virtual_network_name = azurerm_virtual_network.v-vnet.name
#  address_prefixes     = ["10.5.1.0/24"]
#}
#
##resource "azurerm_subnet" "AzureBastionSubnet" {
##  name                 = "AzureBastionSubnet"
##  resource_group_name  = azurerm_resource_group.example.name
##  virtual_network_name = azurerm_virtual_network.v-vnet.name
##  address_prefixes     = ["10.0.2.0/26"]
##}
#
#resource azurerm_subnet default{
#  name                 = "default"
#  resource_group_name  = azurerm_resource_group.example.name
#  virtual_network_name = azurerm_virtual_network.v-vnet.name
#  address_prefixes     = ["10.0.0.0/24"]
#  private_link_service_network_policies_enabled = false
#  
#}
#
#resource "azurerm_public_ip" "pip-bastion" {
#  name                = "examplepip"
#  location            = azurerm_resource_group.example.location
#  resource_group_name = azurerm_resource_group.example.name
#  allocation_method   = "Static"
#  sku                 = "Standard"
#}
#
#resource "azurerm_bastion_host" "example" {
#  name                = "examplebastion"
#  location            = azurerm_resource_group.example.location
#  resource_group_name = azurerm_resource_group.example.name
#
#  ip_configuration {
#    name                 = "configuration"
#    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
#    public_ip_address_id = azurerm_public_ip.pip-bastion.id
#  }
#}
#
#
#
#resource "azurerm_virtual_machine" "example" {
#  name                          = "testgct"
#  location                      = azurerm_resource_group.example.location
#  resource_group_name           = azurerm_resource_group.example.name
#  network_interface_ids         = [azurerm_subnet.default.id]  # Connect the VM to the AKS subnet
#  vm_size                       = "Standard_DS2_v2"
#  delete_os_disk_on_termination = true
#
#  storage_image_reference {
#    publisher = "Canonical"
#    offer     = "0001-com-ubuntu-server-focal"
#    sku       = "20.04-LTS-Gen2"
#    version   = "20.04.202310250"
#  }
#
#  storage_os_disk {
#    name              = "vm-osdisk"
#    caching           = "ReadWrite"
#    create_option     = "FromImage"
#    managed_disk_type = "StandardSSD_LRS"
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = true
#  }
#
#  os_profile {
#    computer_name  = "testgct"
#    admin_username = "adminuser"
#    admin_password = "Password1234!"  # Change this to a strong password
#  }
#}
#
#
#
#
#resource "azurerm_public_ip" "pip-ngw" {
#  name                = "pip-ngw"
#  location            = azurerm_resource_group.example.location
#  resource_group_name = azurerm_resource_group.example.name
#  allocation_method   = "Static"
#  sku                 = "Standard"
#}
#
#
#resource "azurerm_nat_gateway" "example" {
#  name                = "example-NatGateway"
#  location            = azurerm_resource_group.example.location
#  resource_group_name=azurerm_resource_group.example.name
#  sku_name            = "Standard"
#}
#
#resource "azurerm_nat_gateway_public_ip_association" "example" {
#  nat_gateway_id       = azurerm_nat_gateway.example.id
#  public_ip_address_id = azurerm_public_ip.pip-ngw.id
#}
#resource "azurerm_virtual_wan" "example" {
#  name                = "example-virtualwan"
#  resource_group_name = azurerm_resource_group.example.name
#  location            = azurerm_resource_group.example.location
#}
#
#resource "azurerm_virtual_hub" "example" {
#  name                = "example-virtualhub"
#  resource_group_name =azurerm_resource_group.example.name
#  location            = azurerm_resource_group.example.location
#  virtual_wan_id      = azurerm_virtual_wan.example.id
#  address_prefix      = "10.0.0.0/23"
#}
#resource "azurerm_vpn_server_configuration" "example" {
#  name                     = "example-config"
#  resource_group_name      = azurerm_resource_group.example.name
#  location                 = azurerm_resource_group.example.location
#  vpn_authentication_types = ["AAD"]
#  azure_active_directory_authentication {
#    
#    tenant           = "https://login.microsoftonline.com/09953566-9af5-4e84-afe6-974a5fc25d4b/"
#    audience         =  "baaa4697-3d5d-4b49-aabd-7219ca7a2095"
#    issuer           = "https://sts.windows.net/09953566-9af5-4e84-afe6-974a5fc25d4b/"
#  }
#}
#resource "azurerm_point_to_site_vpn_gateway" "example" {
#  name                        = "example-vpn-gateway"
#  location                    = azurerm_resource_group.example.location
#  resource_group_name         = azurerm_resource_group.example.name
#  virtual_hub_id              = azurerm_virtual_hub.example.id
#  vpn_server_configuration_id = azurerm_vpn_server_configuration.example.id
#  scale_unit                  = 1
#  connection_configuration {
#    name = "example-gateway-config"
#
#    vpn_client_address_pool {
#      address_prefixes = [
#        "10.0.2.0/24"
#      ]
#    }
#  }
#}
#resource "azurerm_public_ip" "vpn" {
#  name                = "pip-vgw-vpn"
#  location            = azurerm_resource_group.example.location
#  resource_group_name=azurerm_resource_group.example.name
#  sku                 = "Standard"
#  allocation_method   = "Static"
#}
#
#
#
#resource azurerm_virtual_network_gateway vpn {
#  name                = "vgw-vpn"
#  location            = azurerm_resource_group.example.location
#  resource_group_name = azurerm_resource_group.example.name
#
#  type     = "Vpn"
#  vpn_type = "RouteBased"
#
#  active_active = false
#  enable_bgp    = false
#  sku           = "VpnGw1"
#
#  ip_configuration {
#    name                          = "vnetGatewayConfig"
#    public_ip_address_id          = azurerm_public_ip.vpn.id
#    private_ip_address_allocation = "Dynamic"
#    subnet_id                     = azurerm_subnet.GatewaySubnet.id
#  }
#
#  vpn_client_configuration {
#    address_space        = ["10.1.0.0/24"]
#    vpn_auth_types       = ["AAD"]
#    aad_tenant           = "https://login.microsoftonline.com/09953566-9af5-4e84-afe6-974a5fc25d4b/"
#    aad_audience         = "baaa4697-3d5d-4b49-aabd-7219ca7a2095"
#    aad_issuer           = "https://sts.windows.net/09953566-9af5-4e84-afe6-974a5fc25d4b/"
#    vpn_client_protocols = ["OpenVPN"]
#  }
#
#}
#
#resource "azurerm_public_ip" "lb_vpn" {
#  name                = "pip-vgw-lb"
#  location            = azurerm_resource_group.example.location
#  resource_group_name = azurerm_resource_group.example.name
#  sku                 = "Standard"
#  allocation_method   = "Static"
#}
#
#
#resource "azurerm_lb" "example" {
#  name                = var.lb_name
#  sku                 = "Standard"
#  location            = azurerm_resource_group.example.location
#  resource_group_name = azurerm_resource_group.example.name
#
#  frontend_ip_configuration {
#    name                 = "frontend"
#    subnet_id = azurerm_subnet.default.id
#  }
#  #frontend_ip_configuration {
#  #  name                            = "private"
#  #  private_ip_address_allocation   = "Static"
#  #  private_ip_address              = "10.0.1.10"
#  #  
#  #}
#}
#resource "azurerm_storage_account" "example" {
#  name                     = var.storage_account_name
#  resource_group_name      = azurerm_resource_group.example.name
#  location                 = azurerm_resource_group.example.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#}
#resource "azurerm_private_link_service" "example" {
#  name                = var.privatelink_service_name
#  location            = azurerm_resource_group.example.location
#  resource_group_name=azurerm_resource_group.example.name
# 
#  nat_ip_configuration {
#    name      = "nat-config"
#    primary   = true
#    subnet_id = azurerm_subnet.default.id
#  }
#
#  load_balancer_frontend_ip_configuration_ids = [
#    azurerm_lb.example.frontend_ip_configuration.0.id,
#  ]
#}
#
#resource "azurerm_private_dns_zone" "example" {
#  name                = "privatelink.blob.core.windows.net"
#  resource_group_name = azurerm_resource_group.example.name
#}
#
#resource "azurerm_private_endpoint" "example" {
#  name                = var.private_endpoint_name
#  location            = azurerm_resource_group.example.location
#  resource_group_name =azurerm_resource_group.example.name
#  subnet_id           = azurerm_subnet.default.id
#  
#
# private_service_connection {
#    name                           = "example-privateserviceconnection"
#    private_connection_resource_id = azurerm_storage_account.example.id
#    is_manual_connection           = false
#    subresource_names              = ["blob"]
#  }
#
#  private_dns_zone_group {
#    name                 = azurerm_private_dns_zone.example.name
#    private_dns_zone_ids = [azurerm_private_dns_zone.example.id]
#  }
#}
#
#
#resource "azurerm_private_dns_zone_virtual_network_link" "example" {
#  name                  = "example-link"
#  resource_group_name   = azurerm_resource_group.example.name
#  private_dns_zone_name = azurerm_private_dns_zone.example.name
#  virtual_network_id    = azurerm_virtual_network.v-vnet.id
#}
#
#resource "azurerm_virtual_network_peering" "aks-vm" {
#  name                      = "peer1to2"
#  resource_group_name       = azurerm_resource_group.example.name 
#  virtual_network_name      = azurerm_virtual_network.aks.name
#  remote_virtual_network_id = azurerm_virtual_network.v-vnet.id
#}
#
#resource "azurerm_virtual_network_peering" "vm-aks" {
#  name                      = "peer2to1"
#  resource_group_name       = azurerm_resource_group.example.name
#  virtual_network_name      = azurerm_virtual_network.v-vnet.name
#  remote_virtual_network_id = azurerm_virtual_network.aks.id
#}
#
#
#
#
#
#
#




















