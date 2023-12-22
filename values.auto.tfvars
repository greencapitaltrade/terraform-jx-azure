jx_git_url                      = "https://github.com/greencapitaltrade/mcu"
jx_bot_username                 = "gct-bot"
cluster_name                    = "gct-dev"
location                        = "centralindia"
apex_domain                     = "gc-t.in"
node_size                       = "Standard_B2als_v2"
min_node_count                  = 1
max_node_count                  = 3
use_spot                        = true
build_node_size                 = "Standard_D8as_v5"
min_build_node_count            = 0
max_build_node_count            = 6
app_use_spot                    = true
app_node_size                   = "Standard_D2as_v5"
min_app_node_count              = 0
max_app_node_count              = 6
jx_node_size                    = "Standard_D2as_v5"
min_jx_node_count               = 1
max_jx_node_count               = 3
apex_resource_group_name        = "GCT"
apex_domain_integration_enabled = true
private_cluster_enabled         = true
