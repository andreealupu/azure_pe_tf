data "azurerm_resource_group" "RG" {
  name = var.Resource_Group
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network
  resource_group_name = data.azurerm_resource_group.RG.name
}

data "azurerm_subnet" "net_subnet" {
  name                 = var.net_subnet
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.RG.name
}