# output "Subnet_Spec" {
#   value = { for sub_name, sub_config in azurerm_subnet.subnet :
#     "config.${sub_name}" => sub_config
#   }
# }


# output "Palo_MGMT_IP" {
#   value = { for ip_config in azurerm_network_interface.palo_mgmt.ip_configuration :
#     "config" => {
#       "name"                          = ip_config.name
#       "primary"                       = ip_config.primary
#       "private_ip_address"            = ip_config.private_ip_address
#       "private_ip_address_allocation" = ip_config.private_ip_address_allocation
#       "public_ip_address_id"          = ip_config.public_ip_address_id
#       "subnet_id"                     = ip_config.subnet_id


#     }...
#   }
# }
# output "Palo_Untrust_IP" {
#   value = { for ip_config in azurerm_network_interface.untrust_interface.ip_configuration :
#     "config" => {
#       "name"                          = ip_config.name
#       "primary"                       = ip_config.primary
#       "private_ip_address"            = ip_config.private_ip_address
#       "private_ip_address_allocation" = ip_config.private_ip_address_allocation
#       "public_ip_address_id"          = ip_config.public_ip_address_id
#       "subnet_id"                     = ip_config.subnet_id


#     }...
#   }
# }

# output "Trust_IP" {
#   value = { for ip_config in azurerm_network_interface.trust_interface.ip_configuration :
#     "config" => {
#       "name"                          = ip_config.name
#       "primary"                       = ip_config.primary
#       "private_ip_address"            = ip_config.private_ip_address
#       "private_ip_address_allocation" = ip_config.private_ip_address_allocation
#       "public_ip_address_id"          = ip_config.public_ip_address_id
#       "subnet_id"                     = ip_config.subnet_id


#     }...
#   }
# }


# output "Public_IP" {
#   value = azurerm_public_ip.pub_ip
# }

# output "NSG_MGMT" {
#   value = { for sec_rules in azurerm_network_security_group.mgmt.security_rule :
#   sec_rules.name => sec_rules }

# }
# output "Untrust_MGMT" {
#   value = { for sec_rules in azurerm_network_security_group.untrust.security_rule :
#   sec_rules.name => sec_rules }

# }

# output "local_subnets" {
#   value = local.subnets
# }

# output "Route_Tables" {
#   value = azurerm_route_table.route-table
# }


output "Pan_Vnet_AddressSpace" {
  value = azurerm_virtual_network.Spoke.address_space
}