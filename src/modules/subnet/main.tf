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
    virtual_network_name = var.vnet-name
    address_prefixes = [var.address-prefix]
    resource_group_name = var.resource_group_name
    private_endpoint_network_policies_enabled = true
}