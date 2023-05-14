# azure authn

variable "client_id" {
}

variable "client_secret" {
}

variable "subscription_id" {
}

variable "tenant_id" {
}

###

variable "env" {
}

variable "location" {
    default = "Southeast Asia"
}

variable "resource_group_name" {
    default = ""
}

variable "compartment" {
    type = object({
      vnet_name = string 
    })
}

variable "address_spaces" {
  type = list(string)
}

variable "tags" {
 
}

variable "subnets" {
  type = list(
            object({
                subnet_name                 = string
                address_prefix              = string

                nsg_settings = optional(object({
                    name = string
                    tags = map(string)
                    security_rules = list(object({
                        name                   = string
                        priority                    =  number
                        direction                   = string
                        access                      = string
                        protocol                    = string
                        source_port_range           = string
                        destination_port_range      = string
                        source_address_prefix       = string
                        destination_address_prefix  = string
                        }))
                }))

                route_table_settings =  optional(
                    object({
                        name = optional(string)
                        tags = optional(map(string))
                        routes = optional(list(object({
                            name                    = string
                            address_prefix          = string
                            next_hop_type           = string
                            next_hop_in_ip_address  = string
                        })))
                    })
                )
            })
    )
}

variable "firewall_settings" {
    
  default = null

  type = object({
    firewall_name = string
    firewall_subnet_cidr = string

    network_rule_collection = optional(list(object({
        name     = string
        priority = number
        action   = string
        rules = list(object({
            name                  = string
            source_addresses      = list(string)
            destination_ports     = list(string)
            destination_addresses = list(string)
            protocols             = list(string)
            destination_fqdns     = list(string)
            destination_ip_groups = list(string)
            source_ip_groups      = list(string)
        }))
    })))

    application_rule_collection = optional(list(object({
        name     = string
        priority = number
        action   = string
        rules = list(object({
            name             = string
            source_addresses = list(string)
            target_fqdns     = list(string)
            source_ip_groups = list(string)
            protocols = list(object({
            port = string
            type = string
            }))
        }))
    })))

    nat_rule_collection = optional(list(object({
        name     = string
        priority = number
        action   = string
        rules    = list(object({
                name                  = string
                source_addresses      = list(string)
                destination_ports     = list(string)
                destination_addresses = list(string) # Firewall public IP Address
                translated_port       = number
                translated_address    = string
                protocols             = list(string)
                source_ip_groups      = list(string)
        }))
    })))

  })
}



# variable "firewall_network_rule_collection" {
#     type = optional(object({
#         name     = string
#         priority = number
#         action   = string
#         rules = list(object({
#             name                  = string
#             source_addresses      = list(string)
#             destination_ports     = list(string)
#             destination_addresses = list(string)
#             protocols             = list(string)
#             destination_fqdns     = list(string)
#             destination_ip_groups = list(string)
#             source_ip_groups      = list(string)
#         }))
#     }))
# }


# variable "firewall_application_rule_collection" {
#   type = optional(list(object({
#     name     = string
#     priority = number
#     action   = string
#     rules = list(object({
#         name             = string
#         source_addresses = list(string)
#         target_fqdns     = list(string)
#         source_ip_groups = list(string)
#         protocols = list(object({
#           port = string
#           type = string
#         }))
#     }))
#   })))
# }

# variable "firewall_nat_rule_collection" {
#   type = optional(list(object({
#       name     = string
#       priority = number
#       action   = string
#       rules    = list(object({
#             name                  = string
#             source_addresses      = list(string)
#             destination_ports     = list(string)
#             destination_addresses = list(string) # Firewall public IP Address
#             translated_port       = number
#             translated_address    = string
#             protocols             = list(string)
#             source_ip_groups      = list(string)
#       }))
#   })))
# }