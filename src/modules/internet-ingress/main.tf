

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

# data "azurerm_resource_group" "data_existing_rg" {
#     name = var.resource_group_name
# }

resource "azurerm_resource_group" "rg" {
    count = (var.resource_group_name != "") ? 1 : 0
    name = var.resource_group_name
    location = var.location
    tags = var.tags
}


module "compartment" {

  source = "../compartment"

  compartment = {
    vnet_name = var.compartment.vnet_name
  }
  address_spaces = var.address_spaces
  env = var.env
  location = var.location
  resource_group_name = var.resource_group_name

  subnets = var.subnets

  tags = var.tags

  depends_on = [ 
    azurerm_resource_group.rg
   ]
}