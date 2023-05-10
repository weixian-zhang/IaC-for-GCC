terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.55.0"
    }
  }
}


resource "azurerm_subnet" "subnet" {
    name = var.name
    
    virtual_network_name = var.vnet_name
    address_prefixes = [var.address_prefix]
    resource_group_name = var.resource_group_name
    private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "nsg" {

  name                = var.prefix_env_in_name ? "${var.nsg_name}-${var.env}" : var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
 
  dynamic "security_rule" {
    for_each = var.nsg_security_rules

    content {
      name                        = each.value[0] == "" ? "Default_rule" : each.value[0]
      priority                    = each.value[1] == "" ? 1000 : each.value[1]
      direction                   = each.value[2] == "" ? "Inbound" : each.value[2]
      access                      = each.value[3] == "" ? "Deny" : each.value[3]
      protocol                    = each.value[4] == "" ? "Tcp" : each.value[4]
      source_port_range           = each.value[5] == "" ? "*" : each.value[5]
      destination_port_range      = each.value[6] == "" ? "*" : each.value[6]
      source_address_prefix       = each.value[7] == "" ? "*" : each.value[7]
      destination_address_prefix  = each.value[8] == "" ? "*" : each.value[8]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_sub_assoc" {
    subnet_id = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}
