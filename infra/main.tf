resource "azurerm_resource_group" "rg" {
  name     = "tech-challenge-wp4"
  location = local.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "storageaccounttfstate235"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
