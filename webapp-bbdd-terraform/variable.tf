resource "azurerm_resource_group" "rg-terra" {
  name     = "1-ee218394-playground-sandbox"
  location = "westus "
  tags = {
    environment = "desarrollo"
  }
}