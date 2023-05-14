

module "firewall_main" {
  source  = "claranet/firewall/azurerm"
  version = "6.4.0"
  
  environment = var.env
  location_short = ""
  client_name    = ""
  stack          = ""
  logs_destinations_ids = [""]

  location       = var.location

  custom_firewall_name  = var.name

  resource_group_name  = var.resource_group_name

  virtual_network_name = var.vnet_name

  subnet_cidr = var.subnet_cidr

  network_rule_collections = var.network_rule_collection

  application_rule_collections = var.application_rule_collection

  nat_rule_collections = var.nat_rule_collection
}