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