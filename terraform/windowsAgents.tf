/*resource "azurerm_network_interface" "win_int" {
  count               = var.wininstances
  name                = "${var.name}${count.index}-int-win"
  location            = data.azurerm_resource_group.RG.location
  resource_group_name = data.azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.net_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win-pip[count.index].id
  }
}

resource "azurerm_public_ip" "win-pip" {
  count               = var.wininstances
  name                = "${var.name}${count.index}-pip-win"
  resource_group_name = data.azurerm_resource_group.RG.name
  location            = data.azurerm_resource_group.RG.location
  domain_name_label   = "${var.name}win${count.index}"
  allocation_method   = "Dynamic"
}

resource "azurerm_windows_virtual_machine" "winvm" {
  count               = var.wininstances
  name                = "${var.name}win${count.index}"
  resource_group_name = data.azurerm_resource_group.RG.name
  location            = data.azurerm_resource_group.RG.location
  size                = "Standard_F2"
  admin_username      = var.winuser
  admin_password      = var.winpass
  network_interface_ids = [
    azurerm_network_interface.win_int[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  winrm_listener {
    protocol = "Http"
  }
}

resource "azurerm_network_security_group" "windowsvmnsg" {
  count               = var.wininstances
  name                = "${var.name}win${count.index}-nsg"
  location            = data.azurerm_resource_group.RG.location
  resource_group_name = data.azurerm_resource_group.RG.name
}

resource "azurerm_network_security_rule" "WinRM_Ports_Inbound" {
  count                       = var.wininstances
  name                        = "WinRM_Ports_Inbound"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_ranges     = ["5985", "5986"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.windowsvmnsg[count.index].name
}

resource "azurerm_network_security_rule" "RDP_Port_Inbound" {
  count                       = var.wininstances
  name                        = "RDP_Port_Inbound"
  priority                    = 320
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.windowsvmnsg[count.index].name
}

resource "azurerm_network_security_rule" "HTTP_Inbound" {
  count                       = var.wininstances
  name                        = "HTTP_Inbound"
  priority                    = 315
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.windowsvmnsg[count.index].name
}

resource "azurerm_network_interface_security_group_association" "win_nsg_assoc" {
  count                     = var.wininstances
  network_interface_id      = azurerm_network_interface.win_int[count.index].id
  network_security_group_id = azurerm_network_security_group.windowsvmnsg[count.index].id
}

resource "azurerm_virtual_machine_extension" "firewall" {
  name                 = "firewall"
  count                = var.wininstances
  virtual_machine_id   = azurerm_windows_virtual_machine.winvm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.8"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False"
    }
SETTINGS
}
*/