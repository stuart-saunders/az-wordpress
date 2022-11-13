resource "azurerm_lb" "this" {
  name                = "lb-${var.workload}-${var.location}-01"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name      = "lb-frontend"
    subnet_id = [ 
      for subnet in azurerm_subnet.this : subnet.id 
      if (
        length(regexall("-public-", subnet.name)) > 0 
      ) 
    ][0]

    private_ip_address_allocation = "Dynamic"
  }
}

# resource "azurerm_lb_backend_address_pool" "this" {
#   loadbalancer_id = azurerm_lb.this.id
#   name            = "BackEndAddressPool"
# }

# resource "azurerm_lb_backend_address_pool_address" "this" {
#   for_each = local.lb_backend_pool_vms

#   name                    = each.value
#   backend_address_pool_id = azurerm_lb_backend_address_pool.this.id
#   virtual_network_id      = azurerm_virtual_network.this[local.vms[each.value].vnet_key].id
#   ip_address              = module.vm[each.value].private_ip_address
# }

# resource "azurerm_lb_probe" "this" {
#   loadbalancer_id     = azurerm_lb.this.id
#   name                = "health-probe"
#   port                = 80
#   protocol            = "Http"
#   request_path        = "/"
#   interval_in_seconds = 15
#   number_of_probes    = 2
# }

# resource "azurerm_lb_rule" "this" {
#   name                           = "lb-rule"
#   loadbalancer_id                = azurerm_lb.this.id
#   frontend_ip_configuration_name = "lb-frontend"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
#   probe_id                       = azurerm_lb_probe.this.id
# }