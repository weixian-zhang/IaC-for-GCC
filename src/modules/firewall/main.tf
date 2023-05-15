
resource "azurerm_public_ip" "firewall_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = local.public_ip_allocation_method
  sku                 = local.public_ip_sku
  zones               = local.zones
  tags = var.tags
}


resource "azurerm_firewall" "firewall" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  zones               = local.zones
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id
  
  ip_configuration  {
    name                 = local.firewall_ip_configuration_name
    subnet_id            = var.compartment.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }

  private_ip_ranges = var.private_ip_ranges_not_snat

  tags = var.tags
}