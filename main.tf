
resource "azurerm_network_interface" "PE_int" {
  name                = "${var.Primiary_Server_Name}-int"
  location            = var.Location
  resource_group_name = var.Resource_Group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.net_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PE_pip.id
  }

}

resource "azurerm_public_ip" "PE_pip" {
  name                = "${var.Primiary_Server_Name}-pip"
  resource_group_name = var.Resource_Group
  location            = var.Location
  #domain_name_label = "${var.Primary_Server_Name}_Domain"
  allocation_method = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "mainvm" {
  name                  = var.Primiary_Server_Name
  resource_group_name   = var.Resource_Group
  location              = var.Location
  size                  = "Standard_D2s_v3"
  admin_username        = "alupu"
  network_interface_ids = [azurerm_network_interface.PE_int.id]


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

}