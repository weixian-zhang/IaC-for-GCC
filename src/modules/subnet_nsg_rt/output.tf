

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
  
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg[*].id
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg[*].name
}

output "route_table_id" {
  value =  azurerm_route_table.udr[*].id
}

output "route_table_name" {
  value =  azurerm_route_table.udr[*].name
}