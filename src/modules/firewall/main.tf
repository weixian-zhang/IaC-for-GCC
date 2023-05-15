#for test only

terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.55.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
  client_id         = var.client_id
  client_secret     = var.client_secret 
}

# for test only end





resource "azurerm_public_ip" "firewall_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = local.public_ip_allocation_method
  sku                 = local.public_ip_sku
  zones               = local.public_ip_zones
  tags = var.tags
}




# resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_rules" {
#   count = (var.existing_firewall_policy_id == "") ? 0 : 1

#   name               = "firewall-policy-rules"
#   firewall_policy_id = azurerm_firewall_policy.firewall_policy[0].id
#   priority           = 500

#   dynamic "nat_rule_collection" {
#       for_each = try({ for collection in var.nat_rule_collection : collection.name => collection }, toset([]))

#       name                = each.key
#       azure_firewall_name = azurerm_firewall.firewall.name
#       resource_group_name = var.resource_group_name
#       priority            = each.value.priority
#       action              = each.value.action

#       dynamic "rule" {
#         for_each = each.value.rules
#         content {
#           name                  = rule.value.name
#           source_addresses      = rule.value.source_addresses
#           source_ip_groups      = rule.value.source_ip_groups
#           destination_ports     = rule.value.destination_ports
#           destination_addresses = rule.value.destination_addresses
#           translated_address    = rule.value.translated_address
#           translated_port       = rule.value.translated_port
#           protocols             = rule.value.protocols
#         }
#       }
      
#   }

#   # dynamic "network_rule_collection" {
#   #     for_each = try({ for collection in var.network_rule_collection : collection.name => collection }, toset([]))

#   #     name                = each.key
#   #     azure_firewall_name = azurerm_firewall.firewall.name
#   #     resource_group_name = var.resource_group_name
#   #     priority            = each.value.priority
#   #     action              = each.value.action

#   #     dynamic "rule" {
#   #       for_each = each.value.rules
#   #       content {
#   #         name                  = rule.value.name
#   #         source_addresses      = rule.value.source_addresses
#   #         source_ip_groups      = rule.value.source_ip_groups
#   #         destination_addresses = rule.value.destination_addresses
#   #         destination_ip_groups = rule.value.destination_ip_groups
#   #         destination_fqdns     = rule.value.destination_fqdns
#   #         destination_ports     = rule.value.destination_ports
#   #         protocols             = rule.value.protocols
#   #       }
#   #     }
#   # }

#   # dynamic "application_rule_collection" {
#   #     for_each = try({ for collection in var.application_rule_collection : collection.name => collection }, toset([]))

#   #     name                = each.key
#   #     azure_firewall_name = azurerm_firewall.firewall.name
#   #     resource_group_name = var.resource_group_name
#   #     priority            = each.value.priority
#   #     action              = each.value.action

#   #     dynamic "rule" {
#   #       for_each = each.value.rules
#   #       content {
#   #         name             = rule.value.name
#   #         source_addresses = rule.value.source_addresses
#   #         source_ip_groups = rule.value.source_ip_groups
#   #         target_fqdns     = rule.value.target_fqdns
#   #         dynamic "protocol" {
#   #           for_each = rule.value.protocols
#   #           content {
#   #             port = protocol.value.port
#   #             type = protocol.value.type
#   #           }
#   #         }
#   #       }
#   #     }
#   # }
# }




resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku

  ip_configuration {
    name                 = local.firewall_ip_configuration_name
    subnet_id            = var.compartment.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }

  # dynamic "ip_configuration" {
  #   for_each = toset(var.additional_public_ips)
  #   content {
  #     name                 = lookup(ip_configuration.value, "name")
  #     public_ip_address_id = lookup(ip_configuration.value, "public_ip_address_id")
  #   }
  # }

  private_ip_ranges = var.firewall_private_ip_ranges

  firewall_policy_id = (var.existing_firewall_policy_id == "") ? azurerm_firewall_policy.firewall_policy[0].id : var.existing_firewall_policy_id

  # dns_servers = var.dns_servers

  tags = var.tags

  # lifecycle {
  #   precondition {
  #     condition     = !(var.azurerm_firewall_policy.firewall_policy.id != null && (var.network_rule_collections != null || var.application_rule_collections != null || var.nat_rule_collections != null))
  #     error_message = "Do not use var.firewall_policy_id with var.network_rule_collections, var.application_rule_collections or var.nat_rule_collections variables. Migrate them into your policy."
  #   }
  # }
}

# resource "azurerm_firewall_network_rule_collection" "network_rule_collection" {
#   for_each = try({ for collection in var.network_rule_collections : collection.name => collection }, toset([]))

#   name                = each.key
#   azure_firewall_name = azurerm_firewall.firewall.name
#   resource_group_name = var.resource_group_name
#   priority            = each.value.priority
#   action              = each.value.action

#   dynamic "rule" {
#     for_each = each.value.rules
#     content {
#       name                  = rule.value.name
#       source_addresses      = rule.value.source_addresses
#       source_ip_groups      = rule.value.source_ip_groups
#       destination_addresses = rule.value.destination_addresses
#       destination_ip_groups = rule.value.destination_ip_groups
#       destination_fqdns     = rule.value.destination_fqdns
#       destination_ports     = rule.value.destination_ports
#       protocols             = rule.value.protocols
#     }
#   }
# }

# resource "azurerm_firewall_application_rule_collection" "application_rule_collection" {
#   for_each = try({ for collection in var.application_rule_collections : collection.name => collection }, toset([]))

#   name                = each.key
#   azure_firewall_name = azurerm_firewall.firewall.name
#   resource_group_name = var.resource_group_name
#   priority            = each.value.priority
#   action              = each.value.action

#   dynamic "rule" {
#     for_each = each.value.rules
#     content {
#       name             = rule.value.name
#       source_addresses = rule.value.source_addresses
#       source_ip_groups = rule.value.source_ip_groups
#       target_fqdns     = rule.value.target_fqdns
#       dynamic "protocol" {
#         for_each = rule.value.protocols
#         content {
#           port = protocol.value.port
#           type = protocol.value.type
#         }
#       }
#     }
#   }
# }

# resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection" {
#   for_each = try({ for collection in var.nat_rule_collections : collection.name => collection }, toset([]))

#   name                = each.key
#   azure_firewall_name = azurerm_firewall.firewall.name
#   resource_group_name = var.resource_group_name
#   priority            = each.value.priority
#   action              = each.value.action
#   dynamic "rule" {
#     for_each = each.value.rules
#     content {
#       name                  = rule.value.name
#       source_addresses      = rule.value.source_addresses
#       source_ip_groups      = rule.value.source_ip_groups
#       destination_ports     = rule.value.destination_ports
#       destination_addresses = rule.value.destination_addresses
#       translated_address    = rule.value.translated_address
#       translated_port       = rule.value.translated_port
#       protocols             = rule.value.protocols
#     }
#   }
# }

# module "firewall_main" {
#   source  = "claranet/firewall/azurerm"
#   version = "6.4.0"
  
#   environment = var.env
#   location_short = ""
#   client_name    = ""
#   stack          = ""
#   logs_destinations_ids = [""]

#   location       = var.location

#   custom_firewall_name  = var.name

#   resource_group_name  = var.resource_group_name

#   virtual_network_name = var.compartment.vnet_name

#   subnet_cidr = var.subnet_cidr

#   network_rule_collections = var.network_rule_collection

#   application_rule_collections = var.application_rule_collection

#   nat_rule_collections = var.nat_rule_collection
# }