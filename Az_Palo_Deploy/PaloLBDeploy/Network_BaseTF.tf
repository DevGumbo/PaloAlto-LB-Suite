# resource "azurerm_resource_group" "palo_network" {
#   name     = "spoke-net1"
#   location = "eastus2"


# }



# resource "azurerm_virtual_network" "Spoke" {
#   name                = "Spoke1"
#   address_space       = ["10.0.0.0/24"]
#   location            = azurerm_resource_group.palo_network.location
#   resource_group_name = azurerm_resource_group.palo_network.name
# }

# resource "azurerm_subnet" "oob" {
#   name                 = "oob"
#   resource_group_name  = azurerm_resource_group.palo_network.name
#   virtual_network_name = azurerm_virtual_network.Spoke.name
#   address_prefixes     = ["10.0.0.0/27"]
# }

# resource "azurerm_subnet" "dmz" {
#   name                 = "dmz"
#   resource_group_name  = azurerm_resource_group.palo_network.name
#   virtual_network_name = azurerm_virtual_network.Spoke.name
#   address_prefixes     = ["10.0.0.32/27"]
# }

# resource "azurerm_subnet" "app" {
#   name                 = "app"
#   resource_group_name  = azurerm_resource_group.palo_network.name
#   virtual_network_name = azurerm_virtual_network.Spoke.name
#   address_prefixes     = ["10.0.0.64/27"]
# }

# resource "azurerm_subnet" "web" {
#   name                 = "web"
#   resource_group_name  = azurerm_resource_group.palo_network.name
#   virtual_network_name = azurerm_virtual_network.Spoke.name
#   address_prefixes     = ["10.0.0.96/27"]
# }

# resource "azurerm_subnet" "DB" {
#   name                 = "db"
#   resource_group_name  = azurerm_resource_group.palo_network.name
#   virtual_network_name = azurerm_virtual_network.Spoke.name
#   address_prefixes     = [tostring(cidrsubnet(azurerm_virtual_network.Spoke.address_space[0], 3, 4))]
# }

# resource "azurerm_subnet" "untrust" {
#   name                 = "untrust"
#   resource_group_name  = azurerm_resource_group.palo_network.name
#   virtual_network_name = azurerm_virtual_network.Spoke.name
#   address_prefixes     = [tostring(cidrsubnet(azurerm_virtual_network.Spoke.address_space[0], 3, 5))]
# }

# resource "azurerm_subnet" "core" {
#   name                 = "core"
#   resource_group_name  = azurerm_resource_group.palo_network.name
#   virtual_network_name = azurerm_virtual_network.Spoke.name
#   address_prefixes     = [tostring(cidrsubnet(azurerm_virtual_network.Spoke.address_space[0], 3, 6))]
# }

# output "public_ip" {
#   value = azurerm_public_ip.palo-pub_mgmt

# }


# resource "azurerm_public_ip" "palo-pub_mgmt" {
#   allocation_method = "Static"
#   domain_name_label = "palotest-mgmt"
#   #fqdn                    = "palovmtest.eastus2.cloudapp.azure.com"
#   #id                      = "/subscriptions/88321d5b-1099-4aee-b997-d0801c5a7d71/resourceGroups/mmktplace-palo/providers/Microsoft.Network/publicIPAddresses/palovmtest"
#   idle_timeout_in_minutes = 4
#   #ip_address              = "52.177.194.83"
#   ip_version          = "IPv4"
#   location            = "eastus2"
#   name                = "palomgmt"
#   resource_group_name = azurerm_resource_group.palo_network.name
#   sku                 = "Standard"
#   tags                = {}
#   zones               = []

#   timeouts {}
# }

# resource "azurerm_public_ip" "palo-pub_untrust" {
#   allocation_method = "Static"
#   domain_name_label = "palotest-untrust"
#   #fqdn                    = "palovmtest.eastus2.cloudapp.azure.com"
#   #id                      = "/subscriptions/88321d5b-1099-4aee-b997-d0801c5a7d71/resourceGroups/mmktplace-palo/providers/Microsoft.Network/publicIPAddresses/palovmtest"
#   idle_timeout_in_minutes = 4
#   #ip_address              = "52.177.194.83"
#   ip_version          = "IPv4"
#   location            = "eastus2"
#   name                = "palo-untrust"
#   resource_group_name = azurerm_resource_group.palo_network.name
#   sku                 = "Standard"
#   tags                = {}
#   zones               = []

#   timeouts {}
# }



# resource "azurerm_network_interface" "mgmt" {

#   name                = "palovm100-palovmtest-eth0"
#   resource_group_name = azurerm_resource_group.palo_network.name

#   dns_servers                   = []
#   enable_accelerated_networking = false
#   enable_ip_forwarding          = false

#   ip_configuration {
#     #



#     name                          = "ipconfig-mgmt"
#     primary                       = true
#     private_ip_address            = "10.0.0.4"
#     private_ip_address_allocation = "Static"
#     private_ip_address_version    = "IPv4"
#     public_ip_address_id          = azurerm_public_ip.palo-pub_mgmt.id
#     subnet_id                     = azurerm_subnet.oob.id
#   }

#   location = "eastus2"
#   #mac_address                   = "00-22-48-4B-E3-06"



# }

# resource "azurerm_network_interface" "untrust" {
#   name                = "palovm100-palovmtest-eth1"
#   resource_group_name = azurerm_resource_group.palo_network.name

#   dns_servers                   = []
#   enable_accelerated_networking = false
#   enable_ip_forwarding          = true

#   ip_configuration {




#     name                          = "ipconfig-untrust"
#     primary                       = true
#     private_ip_address            = "10.0.0.170"
#     private_ip_address_allocation = "Static"
#     private_ip_address_version    = "IPv4"
#     public_ip_address_id          = azurerm_public_ip.palo-pub_untrust.id
#     subnet_id                     = azurerm_subnet.untrust.id
#   }

#   location = "eastus2"
#   #mac_address                   = "00-22-48-4B-E3-06"



# }

# resource "azurerm_network_interface" "trust" {
#   name                = "palovm100-palovmtest-eth2"
#   resource_group_name = azurerm_resource_group.palo_network.name

#   dns_servers                   = []
#   enable_accelerated_networking = false
#   enable_ip_forwarding          = true

#   ip_configuration {




#     name                          = "ipconfig-trust"
#     primary                       = true
#     private_ip_address            = "10.0.0.200"
#     private_ip_address_allocation = "Static"
#     private_ip_address_version    = "IPv4"
#     #public_ip_address_id                          = 
#     subnet_id = azurerm_subnet.core.id
#   }
#   location = "eastus2"
#   #mac_address                   = "00-22-48-4B-E3-06"



# }


# ##############--NSG--##################
# resource "azurerm_network_security_group" "mgmt" {
#   name                = "mgmt-nsg"
#   location            = azurerm_resource_group.palo_network.location
#   resource_group_name = azurerm_resource_group.palo_network.name

#   security_rule {
#     name                       = "MGMT_External-Personal"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "47.202.65.44/32"
#     destination_address_prefix = "*"
#   }

#   tags = {
#     environment = "Production"
#   }
# }

# resource "azurerm_network_security_group" "untrust" {
#   name                = "untrust_nsg"
#   location            = azurerm_resource_group.palo_network.location
#   resource_group_name = azurerm_resource_group.palo_network.name

#   security_rule {
#     name                       = "Untrust-deny_inbound"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "47.202.65.44/32"
#     destination_address_prefix = "*"
#   }


#   tags = {
#     environment = "Production"
#   }
# }


# ###############ROUTES############

# resource "azurerm_route_table" "oob" {
#   name                = "oob"
#   location            = azurerm_resource_group.palo_network.location
#   resource_group_name = azurerm_resource_group.palo_network.name
# }

# # resource "azurerm_route" "oob-default" {
# #   name                = "oob-lb-return"
# #   resource_group_name = azurerm_resource_group.palo_network.name
# #   route_table_name    = azurerm_route_table.oob.name
# #   address_prefix      = "0.0.0.0/0"
# #   next_hop_type       = "VirtualAppliance"
# #   next_hop_in_ip_address = "10.0.0.40"
# # }
# resource "azurerm_subnet_route_table_association" "oob" {
#   subnet_id      = azurerm_subnet.oob.id
#   route_table_id = azurerm_route_table.oob.id
# }
# resource "azurerm_subnet_network_security_group_association" "oob" {
#   subnet_id                 = azurerm_subnet.oob.id
#   network_security_group_id = azurerm_network_security_group.mgmt.id
# }




# #######
# resource "azurerm_route_table" "untrust" {
#   name                = "untrust"
#   location            = azurerm_resource_group.palo_network.location
#   resource_group_name = azurerm_resource_group.palo_network.name
# }




# resource "azurerm_subnet_route_table_association" "untrust" {
#   subnet_id      = azurerm_subnet.untrust.id
#   route_table_id = azurerm_route_table.untrust.id
# }



# resource "azurerm_subnet_network_security_group_association" "untrust" {
#   subnet_id                 = azurerm_subnet.untrust.id
#   network_security_group_id = azurerm_network_security_group.untrust.id
# }


# #########
# resource "azurerm_route_table" "core" {
#   name                = "copre"
#   location            = azurerm_resource_group.palo_network.location
#   resource_group_name = azurerm_resource_group.palo_network.name
# }

# resource "azurerm_route" "core-default" {
#   name                   = "core-lb-return"
#   resource_group_name    = azurerm_resource_group.palo_network.name
#   route_table_name       = azurerm_route_table.core.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = "10.0.0.40"
# }


# resource "azurerm_subnet_route_table_association" "core" {
#   subnet_id      = azurerm_subnet.core.id
#   route_table_id = azurerm_route_table.core.id
# }

