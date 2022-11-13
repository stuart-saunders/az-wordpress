locals {

  # subnets = merge([ for vnet_key, vnet_value in var.vnets :
  #   {
  #     for subnet_key, subnet_value in vnet_value.subnets :
  #       "${vnet_key}_${subnet_key}" => {
  #         vnet_key             = vnet_key
  #         location             = vnet_value.location
  #         subnet_key           = subnet_key
  #         subnet_address_space = subnet_value.address_space
  #         nsg                  = subnet_value.nsg
  #         # nsg_rules            = subnet_value.nsg.rules
  #         vms                  = subnet_value.vms
  #     }
  #   }
  # ]...)

  vnets = { for value in var.vnets : value.name => value }

  subnets = merge([ for vnet_value in var.vnets :
    {
      for subnet_value in vnet_value.subnets :
        "${vnet_value.name}_${subnet_value.name}" => {
          vnet_name            = vnet_value.name
          location             = vnet_value.location
          name                 = subnet_value.name
          address_space        = subnet_value.address_space
          nsg                  = subnet_value.nsg
          vms                  = subnet_value.vms
      }
    }
  ]...)

  # nsg_rules = merge([ for subnet_key, subnet_value in local.subnets :
  #   {
  #     for rule_key, rule_value in subnet_value.nsg.rules :
  #       rule_key => {
  #         subnet_key = subnet_key
  #         # subnet_name = subnet_value.subnet_key
  #         nsg_name = subnet_value.nsg.name
  #         name = rule_value.name
  #         priority = rule_value.priority
  #         direction = rule_value.direction
  #         access = rule_value.access
  #         protocol = rule_value.protocol
  #         source_port_range = rule_value.source_port_range
  #         destination_port_range = rule_value.destination_port_range
  #         source_address_prefix = rule_value.source_address_prefix
  #         destination_address_prefix = rule_value.destination_address_prefix
  #       }
  #   }
  # ]...)

  nsg_rules = merge([ for subnet_key, subnet_value in local.subnets :
    {
      for rule_index, rule_value in subnet_value.nsg.rules :
        "${subnet_key}_${subnet_value.nsg.name}_${rule_value.name}" => {
          subnet_key = subnet_key
          subnet_name = subnet_value.name
          nsg_name = subnet_value.nsg.name
          name = rule_value.name
          priority = rule_value.priority
          direction = rule_value.direction
          access = rule_value.access
          protocol = rule_value.protocol
          source_port_range = rule_value.source_port_range
          destination_port_range = rule_value.destination_port_range
          source_address_prefix = rule_value.source_address_prefix
          destination_address_prefix = rule_value.destination_address_prefix
      }
    }
  ]...)
}