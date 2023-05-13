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


locals {

  route_table_routes = (var.route_table_settings == null) ? [] : var.route_table_settings.routes
}

resource "azurerm_subnet" "subnet" {
    name = var.name
    resource_group_name = var.resource_group_name
    virtual_network_name = var.compartment.vnet_name
    address_prefixes = [var.address_prefix]
}


resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_settings.name
  location            = var.location
  resource_group_name = var.resource_group_name
  
  tags = var.nsg_settings.tags

  dynamic "security_rule" {
    for_each = { for rule in var.nsg_settings.security_rules: rule.name => rule }

    content {
      name                        = security_rule.value["name"]
      priority                    = security_rule.value["priority"]
      direction                   = security_rule.value["direction"]
      access                      = security_rule.value["access"]
      protocol                    = security_rule.value["protocol"]
      source_port_range           = security_rule.value["source_port_range"]
      destination_port_range      = security_rule.value["destination_port_range"]
      source_address_prefix       = security_rule.value["source_address_prefix"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_sub_assoc" {
    subnet_id = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_route_table" "udr" {
  count = var.route_table_settings == null ? 0 : 1
  name = var.route_table_settings.name
  resource_group_name = var.resource_group_name
  location = var.location
  disable_bgp_route_propagation = false

  tags = var.route_table_settings.tags
}

resource "azurerm_route" "udr" {

  for_each = { for idx, route in local.route_table_routes: idx => route }

  name                = "acceptanceTestRoute1"
  resource_group_name = var.resource_group_name
  route_table_name    = var.route_table_settings.name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}
