jx_git_url                      = "https://github.com/greencapitaltrade/mcu"
jx_bot_username                 = "gct-bot"
cluster_name                    = "gct-dev"
location                        = "centralindia"
apex_domain                     = "gc-t.in"
node_size                       = "Standard_E4as_v5"
node_count                      = 3
min_node_count                  = 3
max_node_count                  = 6
use_spot                        = true
build_node_size                 = "Standard_D8as_v5"
min_build_node_count            = 0
max_build_node_count            = 6
app_use_spot                    = true
app_node_size                   = "Standard_D4s_v3"
app_node_count                  = 2
min_app_node_count              = 1
max_app_node_count              = 6
# stateful pool removed — merged into default (Apr 2026 cost audit)
apex_resource_group_name        = "gct-domains"
apex_domain_integration_enabled = true
private_cluster_enabled         = true
ingress_ip_name                 = "gct-dev-ingress"
egress_ip_name                  = "gct-dev-egress"
nat_gateway_name                = "gct-dev"
cluster_version                 = "1.31.13"
# ml pool removed — ML workspace deleted (Apr 2026 cost audit)
ml_node_size                    = ""
