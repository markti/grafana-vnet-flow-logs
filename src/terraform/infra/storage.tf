resource "random_string" "logs_storage_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "logs" {
  name                     = "st${random_string.logs_storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
