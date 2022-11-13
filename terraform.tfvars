workload    = "wordpress"
location    = "uksouth"


# vnets = {
#   vnet-wordpress-uksouth-01 = {
#     location      = "uksouth"
#     address_space = "10.0.0.0/16"
#     subnets = {
#       snet-public-uksouth-01 = {
#         address_space = "10.0.1.0/24"
#       }
#       snet-app-uksouth-01 = {
#         address_space = "10.0.2.0/24"
#         nsg = {
#           name = "AppNsg-Private"
#           rules = {
#             deny-http-outbound = {
#               name = "DenyHttpOutbound"
#               priority = 100
#               direction = "Outbound"
#               access = "Deny"
#               protocol = "Tcp"
#               source_port_range = "*"
#               destination_port_range = "*"
#               source_address_prefix = "*"
#               destination_address_prefix = "*"
#             }
#           }
#         }
#         vms = {
#           vmwpapp01 = {
#             availability_zone = 1
#           }
#           vmwpapp02 = {
#             availability_zone = 2
#           }
#         }
#       }
#       snet-db-uksouth-01 = {
#         address_space = "10.0.3.0/24"
#         vms = {
#           vmwpdb01 = {
#             availability_zone = 1
#           }
#           vmwpdb02 = {
#             availability_zone = 2
#           }
#         }
#       }
#     }
#   }
# }

vnets = [
  {
    name = "vnet-wordpress-uksouth-01"
    location      = "uksouth"
    address_space = "10.0.0.0/16"
    subnets = [
      {
        name = "snet-public-uksouth-01"
        address_space = "10.0.1.0/24"
      },
      {
        name = "snet-app-uksouth-01"
        address_space = "10.0.2.0/24"
        nsg = {
          name = "AppNsg-Private"
          rules = [
            {
              name = "deny-http-outbound"
              priority = 100
              direction = "Outbound"
              access = "Deny"
              protocol = "Tcp"
              source_port_range = "*"
              destination_port_range = "*"
              source_address_prefix = "*"
              destination_address_prefix = "*"
            }
          ]
        }
        vms = [
          {
            name = "vmwpapp01"
            availability_zone = 1
          },
          {
            name = "vmwpapp02"
            availability_zone = 2
          }
        ]
      },
      {
        name = "snet-db-uksouth-01"
        address_space = "10.0.3.0/24"
        vms = [
          {
            name = "vmwpdb01"
            availability_zone = 1
          },
          {
            name = "vmwpdb02"
            availability_zone = 2
          }
        ]
      }
    ]
  }
]