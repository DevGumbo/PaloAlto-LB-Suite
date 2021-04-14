##Resource Group

resource "azurerm_resource_group" "palo_network" {
  name     = var.palo_rg_name
  location = var.rg_location


}


## Vnet
resource "azurerm_virtual_network" "Spoke" {
  count = var.existing_vnet == "" ? 1 : 0
  name                = var.Palo_Spoke_Name
  address_space       = var.Vnet_Scopes
  location            = azurerm_resource_group.palo_network.location
  resource_group_name = azurerm_resource_group.palo_network.name
}

## Subnet
resource "azurerm_subnet" "subnet" {
  for_each             = local.subnets
  name                 = each.key
  resource_group_name  = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name
  virtual_network_name = var.existing_vnet != "" ? var.existing_vnet : azurerm_virtual_network.Spoke[0].name
  address_prefixes     = [each.value.cidr_subnet]
}

## Public IP
resource "azurerm_public_ip" "pub_ip" {
  for_each = { for int_name in var.Pub_IP :
  int_name => int_name }

  allocation_method       = "Static"
  domain_name_label       = "${each.key}-${lower(var.Org_Name)}"
  idle_timeout_in_minutes = 4
  ip_version              = "IPv4"
  location                = azurerm_resource_group.palo_network.location
  name                    = "pan-${each.key}"
  resource_group_name     = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name
  sku                     = "Standard"
  tags                    = {}
  zones                   = []

  timeouts {}
}

## Interface
resource "azurerm_network_interface" "palo_mgmt" {



  name                ="${azurerm_resource_group.palo_network.location}-pan-mgmt-eth0"
  resource_group_name = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name

  dns_servers                   = []
  enable_accelerated_networking = false
  enable_ip_forwarding          = false

  ip_configuration {
    name                          = var.existing_vnet != "" ? "${azurerm_resource_group.palo_network.location}-${var.existing_vnet}-pan-mgmt"  : "${azurerm_resource_group.palo_network.location}-${azurerm_virtual_network.Spoke[0].name}-pan-mgmt"
    primary                       = true
    private_ip_address            = cidrhost(azurerm_subnet.subnet["oob"].address_prefixes[0], 4)
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.pub_ip["mgmt"].id
    subnet_id                     = azurerm_subnet.subnet["oob"].id
  }



  location = azurerm_resource_group.palo_network.location

}
resource "azurerm_network_interface" "untrust_interface" {

  name                = "${azurerm_resource_group.palo_network.location}-pan-untrust-eth1"
  resource_group_name = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name

  dns_servers                   = []
  enable_accelerated_networking = false
  enable_ip_forwarding          = true

  ip_configuration {
    name                          = var.existing_vnet != "" ? "${azurerm_resource_group.palo_network.location}-${var.existing_vnet}-pan-untrust"  : "${azurerm_resource_group.palo_network.location}-${azurerm_virtual_network.Spoke[0].name}-pan-untrust"
    primary                       = true
    private_ip_address            = cidrhost(azurerm_subnet.subnet["untrust"].address_prefixes[0], 10)
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.pub_ip["untrust"].id
    subnet_id                     = azurerm_subnet.subnet["untrust"].id
  }

  location = azurerm_resource_group.palo_network.location

}

resource "azurerm_network_interface" "trust_interface" {

  name                = "${azurerm_resource_group.palo_network.location}-pan-trust-eth-2"
  resource_group_name = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name

  dns_servers                   = []
  enable_accelerated_networking = false
  enable_ip_forwarding          = true

  ip_configuration {
    name                          = var.existing_vnet != "" ? "${azurerm_resource_group.palo_network.location}-${var.existing_vnet}-pan-trust"  : "${azurerm_resource_group.palo_network.location}-${azurerm_virtual_network.Spoke[0].name}-pan-trust"
    primary                       = true
    private_ip_address            = cidrhost(azurerm_subnet.subnet["core"].address_prefixes[0], 8)
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = "" #azurerm_public_ip.pub_ip["untrust"].id
    subnet_id                     = azurerm_subnet.subnet["core"].id
  }

  location = azurerm_resource_group.palo_network.location

}


##############--NSG--##################
resource "azurerm_network_security_group" "mgmt" {
  name                = "mgmt-nsg"
  location            = azurerm_resource_group.palo_network.location
  resource_group_name = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name

  security_rule {
    name                   = "MGMT_External-Personal"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "*"
    #source_address_prefix      = # "47.202.65.44/32"
    source_address_prefixes    = var.Allowed_Mgmt_IP
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "untrust" {
  name                = "untrust_nsg"
  location            = azurerm_resource_group.palo_network.location
  resource_group_name = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name

  security_rule {
    name                   = "Untrust-deny_inbound"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "*"
    #source_address_prefix      = 
    source_address_prefixes    = var.Untrust_Allow_IP
    destination_address_prefix = "*"
  }


  tags = {
    environment = "Production"
  }
}

# ###############ROUTES############

resource "azurerm_route_table" "route-table" {
    for_each = local.subnets
  name                = each.key
  location            = azurerm_resource_group.palo_network.location
  resource_group_name = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name
}

resource "azurerm_route" "lb-return" {
    for_each = local.subnets
  name                = "${each.key}-return"
  resource_group_name = var.existing_resource_group != "" ? var.existing_resource_group : azurerm_resource_group.palo_network.name
  route_table_name    = azurerm_route_table.route-table[each.key].name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = each.key == "oob" ? "Internet" : each.key == "untrust" ? "Internet" : "VirtualAppliance"
  next_hop_in_ip_address =  each.key == "oob" ? null : each.key == "untrust" ? null : azurerm_lb.PaloLB.private_ip_address
}
resource "azurerm_subnet_route_table_association" "route_table_association" {
    for_each = local.subnets
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.route-table[each.key].id
}
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
    for_each = {for pub_ip in var.Pub_IP:
                pub_ip => "the key is the indexed name in the ip list"}
  subnet_id                 = each.key == "mgmt" ? azurerm_subnet.subnet["oob"].id : azurerm_subnet.subnet["untrust"].id
  network_security_group_id = each.key == "mgmt"? azurerm_network_security_group.mgmt.id: azurerm_network_security_group.untrust.id
}




