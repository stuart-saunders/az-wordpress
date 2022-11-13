resource "azurerm_resource_group" "this" {
  name     = "rg-${var.workload}-${var.location}-01"
  location = var.location
}