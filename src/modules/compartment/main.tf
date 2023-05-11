

terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.55.0"
    }
  }
}

provider "azurerm" {
  
}


resource "azurerm_virtual_network" "vnet" {
    
    name = var.vnet_name
    resource_group_name = var.resource_group_name
    location = var.location
    address_space = var.address_spaces
    tags = var.tags
}

module "subnet_nsg" {
    source = "../subnet_nsg"

    for_each = var.subnets

    env = var.env
    resource_group_name = var.resource_group_name
    vnet_name = azurerm_virtual_network.vnet.name
    name = each.value.subnet_name
    nsg_name = each.value.nsg_name
    address_prefix = each.value.address_space
  
}