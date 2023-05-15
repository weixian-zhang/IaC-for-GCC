resource "azurerm_firewall_policy" "firewall_policy" {
  name                = var.firewall_policy_name
  resource_group_name = var.resource_group_name
  location            = var.location
  threat_intelligence_mode = "Deny"
  dns {
    proxy_enabled = true
  }
  tags = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_rules" {
  name               = "firewall-policy-rules"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 500
  

  dynamic "nat_rule_collection" {
      for_each = try({ for collection in var.nat_rule_collection : collection.name => collection }, toset([]))

      content {
          name                = nat_rule_collection.key
          priority            = nat_rule_collection.value.priority
          action              = nat_rule_collection.value.action
          
          dynamic "rule" {
            for_each = nat_rule_collection.value.rules

            content {
              name                  = rule.value.name
              source_addresses      = rule.value.source_addresses
              source_ip_groups      = rule.value.source_ip_groups
              destination_ports     = rule.value.destination_ports
              destination_address   = azurerm_public_ip.firewall_public_ip.ip_address
              translated_address    = rule.value.translated_address
              translated_port       = rule.value.translated_port
              protocols             = rule.value.protocols
            }
          }
      }
  }


  dynamic "network_rule_collection" {
    for_each = try({ for collection in var.network_rule_collection : collection.name => collection }, toset([]))

    content {
      name                = network_rule_collection.key
      priority            = network_rule_collection.value.priority
      action              = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.value.name
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_addresses = rule.value.destination_addresses
          destination_ip_groups = rule.value.destination_ip_groups
          destination_fqdns     = rule.value.destination_fqdns
          destination_ports     = rule.value.destination_ports
          protocols             = rule.value.protocols 
        }
      }
    }
  }

  dynamic "application_rule_collection" {
      for_each = try({ for collection in var.application_rule_collection : collection.name => collection }, toset([]))

      content {
          name                = application_rule_collection.key
          priority            = application_rule_collection.value.priority
          action              = application_rule_collection.value.action

          dynamic "rule" {
            for_each = application_rule_collection.value.rules

            content {
              name             = rule.value.name
              source_addresses = rule.value.source_addresses
              source_ip_groups = rule.value.source_ip_groups
              destination_fqdns = rule.value.destination_fqdns
              destination_urls = rule.value.destination_urls
              destination_fqdn_tags = rule.value.destination_fqdn_tags
              web_categories   =  rule.value.web_categories

              dynamic "protocols" {
                for_each = rule.value.protocols
                content {
                  port = protocols.value.port
                  type = protocols.value.type
                }
              }
            }
          }
      }
  }
}