
resource "azurerm_linux_virtual_machine" "Palo-VM" {
  admin_username                  = var.pan_user
  admin_password                  = var.pan_pass
  computer_name                   = "${azurerm_resource_group.palo_network.location}-${azurerm_virtual_network.Spoke[0].name}-PAN-VM"
  disable_password_authentication = false
  encryption_at_host_enabled      = false
  location            = azurerm_resource_group.palo_network.location
  resource_group_name = azurerm_resource_group.palo_network.name
  name                            = "${azurerm_resource_group.palo_network.location}-${azurerm_virtual_network.Spoke[0].name}-PANFW"
  network_interface_ids           = [azurerm_network_interface.palo_mgmt.id, azurerm_network_interface.untrust_interface.id, azurerm_network_interface.trust_interface.id]
  priority                        = "Regular"
  provision_vm_agent              = true
  size                            = "Standard_D3_v2"
  tags                            = {}

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = 60
    storage_account_type      = "Standard_LRS"
    write_accelerator_enabled = false
  }

  plan {
    name      = "byol"
    product   = "vmseries-flex"
    publisher = "paloaltonetworks"
  }

  source_image_reference {
    offer     = "vmseries-flex"
    publisher = "paloaltonetworks"
    sku       = "byol"
    version   = var.pan_version
  }

  timeouts {}
}

