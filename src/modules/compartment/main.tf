
resource "azurerm_virtual_network" "vnet" {
    
    name = var.compartment.vnet_name
    resource_group_name = var.resource_group_name
    location = var.location
    address_space = var.address_spaces
    tags = var.tags
}

module "subnet_nsg_rt" {
    source = "../subnet_nsg_rt"

    for_each = { for idx, subnet in var.subnets : idx => subnet }

    env = var.env

    resource_group_name = var.resource_group_name

    compartment = {
      vnet_name = var.compartment.vnet_name
    }
    name = each.value.subnet_name

    address_prefix = each.value.address_prefix

    nsg_settings = each.value.nsg_settings

    route_table_settings = each.value.route_table_settings

    depends_on = [
      azurerm_virtual_network.vnet
    ]
}