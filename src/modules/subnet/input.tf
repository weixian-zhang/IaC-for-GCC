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

variable "vnet-name" {
  
}

variable "address_prefix" {
  
}

variable "nsg_name" {
  
}

variable "nsg_security_rules" {
    default = [
            {
                name                        = "RDP"
                priority                    = 1000
                direction                   = "Inbound"
                access                      = "Allow"
                protocol                    = "Tcp"
                source_port_range           = "*"
                destination_port_range      = "3389"
                source_address_prefix       = "*"
                destination_address_prefix  = "10.0.0.0/24"
            },
            {
                name                        = "SSH"
                priority                    = 1100
                direction                   = "Inbound"
                access                      = "Allow"
                protocol                    = "Tcp"
                source_port_range           = "*"
                destination_port_range      = "22"
                source_address_prefix       = "*"
                destination_address_prefix  = "10.0.1.0/24"
            }
        ]

    type = list(object({
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

  
}