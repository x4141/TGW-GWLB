resource "azurerm_virtual_machine" "passivefgtvm" {
  depends_on                   = [azurerm_virtual_machine.activefgtvm]
  name                         = "passivefgt"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.passiveport1.id, azurerm_network_interface.passiveport2.id, azurerm_network_interface.passiveport3.id, azurerm_network_interface.passiveport4.id]
  primary_network_interface_id = azurerm_network_interface.passiveport1.id
  vm_size                      = var.size

  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.fgtsku
    version   = var.fgtversion
  }

  plan {
    name      = var.fgtsku
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "passiveosDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "passivedatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "activefgt"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.passiveFortiGate.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
}

data "template_file" "passiveFortiGate" {
  template = "${file("${var.bootstrap-passive}")}"

  vars = {
    port1_ip        = "${var.passiveport1}"
    port1_mask      = "${var.passiveport1mask}"
    port2_ip        = "${var.passiveport2}"
    port2_mask      = "${var.passiveport2mask}"
    port3_ip        = "${var.passiveport3}"
    port3_mask      = "${var.passiveport3mask}"
    port4_ip        = "${var.passiveport4}"
    port4_mask      = "${var.passiveport4mask}"
    active_peerip   = "${var.activeport3}"
    mgmt_gateway_ip = "${var.port4gateway}"
    defaultgwy      = "${var.port1gateway}"
    tenant          = "${var.tenant_id}"
    subscription    = "${var.subscription_id}"
    clientid        = "${var.client_id}"
    clientsecret    = "${var.client_secret}"
    adminsport      = "${var.adminsport}"
    rsg             = azurerm_resource_group.myterraformgroup.name
    clusterip       = azurerm_public_ip.ClusterPublicIp.name
    routename       = azurerm_route_table.internal.name
  }
}