resource "azurerm_lb" "PaloLB" {
  name                = "PaloLB"
  location            = azurerm_resource_group.palo_network.location
  resource_group_name = azurerm_resource_group.palo_network.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = var.existing_vnet != "" ? "Vnet-${var.existing_vnet}EntryPoint"  : "Vnet-${azurerm_virtual_network.Spoke[0].name}EntryPoint"
    subnet_id                     = azurerm_subnet.subnet["core"].id
    private_ip_address            = cidrhost(azurerm_subnet.subnet["core"].address_prefixes[0],20)
    private_ip_address_allocation = "static"


  }
}

resource "azurerm_lb_backend_address_pool" "Palo_firewalls" {
  loadbalancer_id = azurerm_lb.PaloLB.id
  name            = "PaloTrust-Firewalls"

}





resource "azurerm_lb_backend_address_pool_address" "trust_fw1" {
  name                    = "Palo-Trust-${azurerm_linux_virtual_machine.Palo-VM.name}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.Palo_firewalls.id
  virtual_network_id      = var.existing_vnet != "" ? data.azurerm_virtual_network.imported_VNET[0].id : azurerm_virtual_network.Spoke[0].id
  ip_address              = azurerm_network_interface.trust_interface.ip_configuration[0].private_ip_address
}



resource "azurerm_lb_probe" "fw_check" {
  resource_group_name = azurerm_resource_group.palo_network.name
  loadbalancer_id     = azurerm_lb.PaloLB.id
  name                = "trust-fw-check"
  port                = 22
  protocol = "TCP"
  
}



resource "azurerm_lb_rule" "back_haul" {
  resource_group_name = azurerm_resource_group.palo_network.name
  loadbalancer_id                = azurerm_lb.PaloLB.id
  name                           = "back-haul"
  protocol                       = "All"
  frontend_port                  = "0"
  backend_port                   = "0"
  frontend_ip_configuration_name = azurerm_lb.PaloLB.frontend_ip_configuration[0].name
  enable_floating_ip = true
  probe_id = azurerm_lb_probe.fw_check.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.Palo_firewalls.id



}

