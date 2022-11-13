variable "workload" {
  type        = string
  description = "The name of the app or workload that the resource supports, for inclusion in the resouce name"
}

variable "location" {
  type        = string
  description = "The Azure Region where the resource should exist"
}

# variable "vnets" {
#   type = map(object({
#     location      = string
#     address_space = string
#     subnets       = map(object({
#       address_space = string
#       nsg = optional(object({
#         name = optional(string, "")
#         rules = optional(map(object({
#           name = string
#           priority = number
#           direction = string
#           access = string
#           protocol = string
#           source_port_range = string
#           destination_port_range = string
#           source_address_prefix = string
#           destination_address_prefix = string
#         })), {})
#       }), {})
#       vms = optional(map(object({
#         availability_zone = string
#       })))
#     }))
#   }))
# }

variable "vnets" {
  type = list(object({
    name = string
    location      = string
    address_space = string
    subnets = list(object({
      name = string
      address_space = string
      nsg = optional(object({
        name = optional(string, "")
        rules = optional(list(object({
          name = string
          priority = number
          direction = string
          access = string
          protocol = string
          source_port_range = string
          destination_port_range = string
          source_address_prefix = string
          destination_address_prefix = string
        })), [])
      }), {})
      vms = optional(list(object({
        name = string
        availability_zone = string
      })), [])
    }))
  }))
}