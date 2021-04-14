# resource "azurerm_resource_group" "palo_servicebus_group" {
#   name     = "palo-service-group"
#   location = "east us"
# }

# # resource "azurerm_servicebus_namespace" "example" {
# #   name                = "tfex-servicebus-namespace"
# #   location            = azurerm_resource_group.example.location
# #   resource_group_name = azurerm_resource_group.example.name
# #   sku                 = "Standard"

# #   tags = {
# #     source = "terraform"
# #   }
# # }


# resource "azurerm_app_service_plan" "my_palo_app_plan" {
#   name                = "api-appservice-fucntion"
#   location            = azurerm_resource_group.palo_servicebus_group.location
#   resource_group_name = azurerm_resource_group.palo_servicebus_group.name
#   kind                = "FunctionApp"

#   sku {
#     tier = "Basic"
#     size = "B1"
#   }
# }