locals {

  
  subnets = { for subnet_name in var.Vnet_Subnets :
    subnet_name => {
      "cidr_subnet" = var.existing_vnet != "" ? tostring(cidrsubnet(data.azurerm_virtual_network.imported_VNET[0].address_space[var.exist_vnet_scope_index], 3, index(var.Vnet_Subnets, subnet_name))) :  tostring(cidrsubnet(var.Vnet_Scopes[0], 3, index(var.Vnet_Subnets, subnet_name)))
      
    }
  }

 


}



