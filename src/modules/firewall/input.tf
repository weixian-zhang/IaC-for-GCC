# azure authn for testing only

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
}

variable "name" {
  
}

variable "tags" {
  default = {}
}

variable "compartment" {
    type = object({
      subnet_id = string
    })
}

variable "firewall_name" {
  
}

variable "subnet_cidr" {
  
}

variable "public_ip_name" {
  
}

variable "existing_firewall_policy_id" {
  default = ""
}

variable "firewall_policy_name" {
}

variable "private_ip_ranges" {
  description = "A list of private IP ranges to which traffic will not be SNAT."
  default = []
}

variable "firewall_private_ip_ranges" {
  description = "A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

# Standard or Premium
variable "sku" {
    default = "Standard"
}


variable "network_rule_collection" {
  default = []
  type = list(object({
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
  }))
}


# destination_urls: Specifies a list of destination URLs for which policy should hold. Needs Premium SKU for Firewall Policy. Conflicts with destination_fqdns
# destination_fqdns: Specifies a list of destination FQDNs. Conflicts with destination_urls
# destination_fqdn_tags: Specifies a list of destination FQDN tags
# web categories: "ChildAbuseImages","Gambling","HateAndIntolerance","IllegalDrug","IllegalSoftware","Nudity",
# "PornographyOrSexuallyExplicit" (does not work), "Violence","Weapons"
variable "application_rule_collection" {
  default = []
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = optional(list(object({
        name             = string
        source_addresses = list(string)
        destination_fqdns     = optional(list(string)) 
        destination_urls = optional(list(string)) 
        destination_fqdn_tags = optional(list(string))
        source_ip_groups = optional(list(string))
        web_categories   = optional(list(string))
        protocols = list(object({
          port = string
          type = string
        }))
    })))
  }))
}

variable "nat_rule_collection" {
  default = []
  type = list(object({
      name     = string
      priority = number
      action   = string
      rules    = list(object({
            name                  = string
            source_addresses      = list(string)
            destination_ports     = list(string)
            destination_address   = string # Firewall public IP Address
            translated_port       = number
            translated_address    = string
            protocols             = list(string)  # ["TCP", "UDP"]
            source_ip_groups      = list(string)
      }))
  }))
}



