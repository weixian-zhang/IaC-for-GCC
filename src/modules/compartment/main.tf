
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.55.0"
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
    
    name = var.vnet_name
    resource_group_name = var.resource_group_name
    location = var.location
    address_space = var.address_spaces
    tags = var.tags
}

module "subnet_nsg_rt" {
    source = "../subnet_nsg_rt"

    for_each = var.subnets

    env = var.env
    resource_group_name = var.resource_group_name
    vnet_name = azurerm_virtual_network.vnet.name
    name = each.value.subnet_name
    address_prefix = each.value.address_prefix

    nsg_settings = each.value.nsg_settings

    route_table_settings = each.value.route_table_settings

  
}