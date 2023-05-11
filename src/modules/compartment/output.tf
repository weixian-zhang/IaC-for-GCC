

output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "subnets" {
    value = tomap({
        subnet_name = module.subnet_nsg_rt[*].subnet_name
        subnet_id = module.subnet_nsg_rt[*].subnet_id
    })
}