# azure authn for testing only

# variable "client_id" {
# }

# variable "client_secret" {
# }

# variable "subscription_id" {
# }

# variable "tenant_id" {
# }

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
    firewall_name               = string
    public_ip_name              = string
    log_analytics_worspace_name   = string
    log_analytics_workspace_resource_group = string
    policy_name                 = string # no existing, create a new firewall policy
    private_ip_ranges           = optional(set(string))
    sku_tier                    = optional(string) # default to Standard
    tags = optional(map(string))

    network_rule_collection = optional(list(object({
        name     = string
        priority = number
        action   = string
        rules = list(object({
            name                  = string
            source_addresses      = list(string)
            destination_ports     = list(string)
            destination_addresses = list(string)
            protocols             = list(string)  # ["TCP", "UDP"]
            destination_fqdns     = list(string)
            destination_ip_groups = list(string)
            source_ip_groups      = list(string)
        }))
    })))

    application_rule_collection = optional(list(object({
        name     = string
        priority = number
        action   = string
        rules = optional(list(object({
            name             = string
            source_addresses = list(string)
            destination_fqdns     = optional(list(string)) 
            destination_urls = optional(list(string)) 
            destination_fqdn_tags = optional(list(string))
            web_categories   = optional(list(string))
            source_ip_groups = optional(list(string))
            protocols = list(object({
                port = string
                type = string
            }))
        })))
    })))

    nat_rule_collection = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules    = list(object({
            name                  = string
            source_addresses      = list(string)
            destination_ports     = list(string)
            destination_address   = optional(string) # default to Firewall public IP Address
            translated_port       = number
            translated_address    = string
            protocols             = list(string)  # ["TCP", "UDP"]
            source_ip_groups      = list(string)
      }))
  })))

  })
}