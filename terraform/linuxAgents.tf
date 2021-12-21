/*resource "azurerm_network_interface" "nix_int" {
  count               = var.lininstances
  name                = "${var.name}${count.index}-int-nix"
  location            = data.azurerm_resource_group.RG.location
  resource_group_name = data.azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.net_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nix-pip[count.index].id
  }
}

resource "azurerm_public_ip" "nix-pip" {
  count               = var.lininstances
  name                = "${var.name}${count.index}-pip-nix"
  resource_group_name = data.azurerm_resource_group.RG.name
  location            = data.azurerm_resource_group.RG.location
  domain_name_label   = "${var.name}nix${count.index}"
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "nixvm" {
  count               = var.lininstances
  name                = "${var.name}nix${count.index}"
  resource_group_name = data.azurerm_resource_group.RG.name
  location            = data.azurerm_resource_group.RG.location
  size                = "Standard_F2"
  admin_username      = "alupu"
  network_interface_ids = [
    azurerm_network_interface.nix_int[count.index].id,
  ]

  admin_ssh_key {
    username   = "alupu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}*/