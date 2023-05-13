
variable "env" {
  
}

# used for GCC compartment config, exist in every GCC module
# contain properties: vnet_name and/or existing_vnet_id
# subnet requires vnet_name while some resources require vnet_id.
# this variable makes GCC compartment settings explicit
variable "compartment" {
    type = object({
      vnet_name = string 
    })
}

variable "location" {
    default = "Southeast Asia"
}

variable "resource_group_name" {
  
}

variable "name" {
  
}

variable "address_prefix" {
  
}

variable "nsg_settings" {
  default = null
  type = object({
    name = string
    tags = map(string)
    security_rules = optional(list(object({
        name                        = string
        priority                    =  number
        direction                   = string
        access                      = string
        protocol                    = string
        source_port_range           = string
        destination_port_range      = string
        source_address_prefix       = string
        destination_address_prefix  = string
      })))
  })

  #  validation {
  #   condition = var.nsg_settings == null || length(var.nsg_settings.security_rules) > 0
  #   error_message = "All destination_types must be one of CIDR_BLOCK,NETWORK_SECURITY_GROUP or SERVICE_CIDR_BLOCK!"
  #  }
}

# next hop type = VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance or None
variable "route_table_settings" {
    default = null
    type = object({
      name = string
      tags = map(string)
      routes = list(object({
        name                = string
        address_prefix      = string
        next_hop_type       = string
        next_hop_in_ip_address = string
      }))
    })
}
