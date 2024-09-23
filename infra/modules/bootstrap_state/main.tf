resource "azurerm_resource_group" "terraform_state" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "terraform_state" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.terraform_state.name
  location                        = azurerm_resource_group.terraform_state.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

resource "azurerm_management_lock" "terraform_state_lock" {
  name       = "${var.storage_account_name}-lock"
  scope      = azurerm_storage_account.terraform_state.id
  lock_level = "CanNotDelete"
  notes      = "Locked because it's needed by Terraform"
}
