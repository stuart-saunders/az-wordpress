# Networking
resource "azurerm_virtual_network" "this" {
  for_each = local.vnets

  name                = each.value.name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [ each.value.address_space ]
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_virtual_network.this[ each.value.vnet_name ].resource_group_name
  virtual_network_name = azurerm_virtual_network.this[ each.value.vnet_name ].name
  address_prefixes     = [ each.value.address_space ]
}

# NAT Gateway
resource "azurerm_public_ip" "this" {
  name                = "pip-natgw-01"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_public_ip_prefix" "example" {
  name                = "nat-gateway-publicIPPrefix"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  prefix_length       = 30
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "example" {
  name                    = "nat-Gateway"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_network_security_group" "this" {
  for_each = local.subnets

  name                = "nsg-${each.value.name}"
  resource_group_name = azurerm_subnet.this["${each.key}"].resource_group_name
  location            = each.value.location
}

resource "azurerm_network_security_rule" "this" {
  for_each = local.nsg_rules

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_subnet.this["${each.value.subnet_key}"].resource_group_name
  network_security_group_name = azurerm_network_security_group.this["${each.value.subnet_key}"].name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.subnets

  subnet_id                 = azurerm_subnet.this["${each.key}"].id
  network_security_group_id = azurerm_network_security_group.this["${each.key}"].id
}