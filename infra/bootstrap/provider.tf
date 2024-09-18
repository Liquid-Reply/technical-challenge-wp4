terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.42"
    }
  }
}

provider "azurerm" {
  use_cli         = true
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  skip_provider_registration = true

  features {

  }
}

data "azurerm_client_config" "current" {}