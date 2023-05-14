
variable "env" {
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

variable "subnet_cidr" {
  
}

variable "network_rule_collection" {
    type = list(object({
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
    }))
}


variable "application_rule_collection" {
  type = list(object({
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
  }))
}

variable "nat_rule_collection" {
  type = list(object({
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
  }))
}



