variable "env" {
  
}

variable "prefix_env_in_name" {
  default = true
}

variable "location" {
    default = "Southeast Asia"
}

variable "resource_group_name" {
  
}

variable "name" {
  
}

variable "vnet_name" {
  
}

variable "address_prefix" {
  
}

variable "nsg_settings" {
  type = object({
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
  })
}

# next hop type = VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance or None
variable "route_table_settings" {
    
    type = object({
      name = string
      tags = map(string)
      routes = list(object({
        name                = string
        address_prefix      = string
        next_hop_type       = string
      }))
    })
}
