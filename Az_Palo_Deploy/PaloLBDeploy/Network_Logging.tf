
# resource "azurerm_storage_account" "palo_nsg_logs" {
#   name                     = "palonsglogs"
#   resource_group_name      = azurerm_resource_group.palo_network.name
#   location                 = azurerm_resource_group.palo_network.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags = {
#     environment = "Production"
#   }
# }

# resource "azurerm_network_watcher" "Palo_network_watcher" {
#   name                = "palowatcher"
#   resource_group_name      = azurerm_resource_group.palo_network.name
#   location                 = azurerm_resource_group.palo_network.location
# }

# resource "azurerm_log_analytics_workspace" "my_palo_workspace" {
#   name                = "acctestlaw"
#   resource_group_name      = azurerm_resource_group.palo_network.name
#   location                 = azurerm_resource_group.palo_network.location
#   sku                 = "PerGB2018"
# }

# resource "azurerm_network_watcher_flow_log" "untrust" {
#   network_watcher_name = azurerm_network_watcher.Palo_network_watcher.name
#   resource_group_name      = azurerm_resource_group.palo_network.name

#   network_security_group_id = azurerm_network_security_group.untrust.id
#   storage_account_id        = azurerm_storage_account.palo_nsg_logs.id
#   enabled                   = true

#   retention_policy {
#     enabled = true
#     days    = 7
#   }

#   traffic_analytics {
#     enabled               = true
#     workspace_id          = azurerm_log_analytics_workspace.my_palo_workspace.workspace_id
#     workspace_region      = azurerm_log_analytics_workspace.my_palo_workspace.location
#     workspace_resource_id = azurerm_log_analytics_workspace.my_palo_workspace.id
#     interval_in_minutes   = 10
#   }
# }