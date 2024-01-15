output "connect" {
  value = "az aks get-credentials --subscription ${data.azurerm_subscription.current.subscription_id} --name ${var.cluster_name} --resource-group ${local.cluster_resource_group_name} --admin"
}
output "kubelet_identity_id" {
  value = module.cluster.kubelet_identity_id
}
output "kubelet_client_id" {
  value = module.cluster.kubelet_client_id
}
output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}
output "client_certificate" {
  value = module.cluster.client_certificate
}
output "client_key" {
  value = module.cluster.client_key
}
output "ca_certificate" {
  value = module.cluster.ca_certificate
}
output "kube_config_admin_raw" {
  value = module.cluster.kube_config_admin_raw
}
output "kube_config_admin" {
  value = module.cluster.kube_config_admin
}
output "vpn_public_ip" {
  value = module.vnet.vpn_public_ip
}
output "ingress_public_ip" {
  value = azurerm_public_ip.ingress_ip.ip_address
}
output "egress_public_ip" {
  value = module.vnet.egress_public_ip
}
output "vnet_resource_group_name" {
  value = azurerm_resource_group.network.name
}
output "vnet_id" {
  value = module.vnet.vnet_id
}
output "vnet_name" {
  value = module.vnet.vnet_name
}
