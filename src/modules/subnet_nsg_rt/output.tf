

output "subnet_id" {
  value = {
    subnet_id = azurerm_subnet.subnet.id
  }
}

output "subnet_name" {
  value = {
    subnet_id = azurerm_subnet.subnet.name
  }
}

output "nsg_id" {
  value = {
    nsg_id = azurerm_network_security_group.nsg[*].id
  }
}

# output "route_table_id" {
#   value = {
#     route_table_id = azurerm_route_table.udr[*].id
#   }
# }