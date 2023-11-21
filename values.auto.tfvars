jx_git_url = "https://github.com/greencapitaltrade/mcu"

jx_bot_username = "gct-bot"

#cluster_name = "gct-dev"

location = "centralindia"

cluster_version = "1.28.0"
#
##network_name = "gct-dev"
#
#subnet_name = "gct-dev"
#
#node_size = "Standard_B2als_v2"

node_count = "1"

min_node_count = "1"

max_node_count = "4"

use_spot = "false"

build_node_size = "Standard_D2ps_v5"

build_node_count = "1"

min_build_node_count = "1"

max_build_node_count = "4"

apex_domain_integration_enabled = "false"

apex_domain = "paysay.in"

key_vault_enabled = "true"

#key_vault_name = "gct-dev"

key_vault_sku = "standard"

#use_existing_acr_name = "null"

#use_existing_acr_resource_group_name = "GCTFinserv"
#
#storage_resource_group_name = "GCTFinserv"
#
#network_resource_group_name = "GCTFinserv"
#
#cluster_resource_group_name = "GCTFinserv"
#
#cluster_node_resource_group_name = "GCTFinserv"
#
#apex_resource_group_name = "GCTFinserv"
#
#dns_resource_group_name = "GCTFinserv"
#
#key_vault_resource_group_name = "GCTFinserv"
#
#registry_resource_group_name = "GCTFinserv"
#
#automatic_channel_upgrade        = "stable" 

image_cleaner_enabled            = "true"

image_cleaner_interval_hours     = "24" 

network_profile                  = "azure"

private_cluster_enabled          = "true"

private_dns_zone_id              = "System"

workload_identity_enabled        = "false"

#oidc_issuer_enabled              = "true"

public_network_access_enabled    = "false"

