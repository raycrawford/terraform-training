resource "azurerm_resource_group" "02ResourceGroup" {
  name     = "challenge02-rg"
  location = "eastus2"
}
resource "azurerm_storage_account" "mainStorage" {
  name                     = "cardinaltfchallenge02"
  resource_group_name      = "${azurerm_resource_group.02ResourceGroup.name}"
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
