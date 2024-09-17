terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
  backend "azurem" {
    resource_group_name  = "tfstate"
    storage_account_name = "storageaccounttfstate235"
    container_name       = "tfstate"
  }
}

provider "azurerm" {
  features {}
}
