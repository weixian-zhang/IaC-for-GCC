variable "env" {
}

variable "location" {
    default = "Southeast Asia"
}

variable "resource_group_name" {
  
}

# vnet name
variable "vnet_name" {
  
}

variable "address_spaces" {
  type = list(string)
}

variable "tags" {
 
}

variable "subnets" {
  type = list(object({
    type = object({

        subnet_name                 = string
        address_prefix              = string
        nsg_name                    = string
        tags                        = list(string)

        nsg_settings = object({
          name = string
          tags = {}
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

        route_table_settings =  object({
          name = string
          tags = {}
          routes = list(object({
            name                = string
            address_prefix      = string
            next_hop_type       = string
          }))
        })
        
      })
  })
  )
}