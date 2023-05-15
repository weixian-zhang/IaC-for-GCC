
locals {
  subnet_ids = [for mod in module.subnet_nsg_rt : mod.subnet_id]
  subnet_names = [for mod in module.subnet_nsg_rt : mod.subnet_name]
  subnets = zipmap(local.subnet_names, local.subnet_ids)

  nsg_ids = flatten([for mod in module.subnet_nsg_rt : mod.nsg_id])
  nsg_names = flatten([for mod in module.subnet_nsg_rt : mod.nsg_name])
  nsgs = zipmap(local.nsg_names, local.nsg_ids)

  route_table_ids = flatten([for mod in module.subnet_nsg_rt : mod.route_table_id])
  route_table_names = flatten([for mod in module.subnet_nsg_rt : mod.route_table_name])
  route_tables = zipmap(local.route_table_names, local.route_table_ids )
}

output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}


output "subnet_info" {
  value = {
    subnets     = local.subnets
    nsgs        = local.nsgs
    route_tables = local.route_tables
  }
}