variable "env" {
  
}

variable "resource_group_name" {
  
}

variable "name" {
  
}

variable "vnet-name" {
  
}

variable "address-prefix" {
  
}

variable "nsg_config" {
    # default = {
    #     name = ""
    #     rules = [
    #         {
    #             priority                    = 1000
    #             direction                   = "Inbound"
    #             access                      = "Allow"
    #             protocol                    = "Tcp"
    #             source_port_range           = "*"
    #             destination_port_range      = "3389"
    #             source_address_prefix       = "*"
    #             destination_address_prefix  = var.address_prefixes
    #         },
    #         {
    #             priority                    = 1100
    #             direction                   = "Inbound"
    #             access                      = "Allow"
    #             protocol                    = "Tcp"
    #             source_port_range           = "*"
    #             destination_port_range      = "22"
    #             source_address_prefix       = "*"
    #             destination_address_prefix  = var.address_prefixes
    #         },
    #     ]
    # }
    type = object({
      name = string 
      rules = list(object({
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