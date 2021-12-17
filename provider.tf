# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = " >= 1.1.1"
}

provider "azurerm" {

  features {}
  subscription_id = var.subscriptionID
  tenant_id       = var.tenantID
}