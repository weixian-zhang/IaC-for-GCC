

output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}


output "subnets" {
  value = {
    subnet_id = [for k, mod in module.subnet_nsg_rt : mod.subnet_id]
    subnet_name = [for k, mod in module.subnet_nsg_rt : mod.subnet_name]
    nsg_id = [for k, mod in module.subnet_nsg_rt : mod.nsg_id]
    nsg_name = [for k, mod in module.subnet_nsg_rt : mod.nsg_name]
    route_table_id = [for k, mod in module.subnet_nsg_rt : mod.route_table_id]
    route_table_name = [for k, mod in module.subnet_nsg_rt : mod.route_table_name]
  }
}