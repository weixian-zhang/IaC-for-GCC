

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


module "firewall" {

  count = (var.firewall_settings == null) ? 0 : 1
  
  source = "../firewall"
  
  env = var.env
  
  location = var.location

  resource_group_name = var.resource_group_name

  compartment = { subnet_id = module.compartment.subnet_info.subnets[local.azfw_subneg_name] }

  name = var.firewall_settings.firewall_name

  public_ip_name = var.firewall_settings.public_ip_name

  firewall_policy_name = var.firewall_settings.policy_name

  sku_tier = var.firewall_settings.sku_tier

  private_ip_ranges_not_snat = var.firewall_settings.private_ip_ranges

  nat_rule_collection = var.firewall_settings.nat_rule_collection

  network_rule_collection = var.firewall_settings.network_rule_collection

  application_rule_collection = var.firewall_settings.application_rule_collection

  depends_on = [ 
      module.compartment
  ]
}