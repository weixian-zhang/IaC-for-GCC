output "subnet_info" {
  value = module.compartment.subnet_info
}

output "vnet_id" {
    value =  module.compartment.vnet_id
}

output "firewall_id" {
  value = module.firewall[0].firewall_id
}

output "firewall_policy_id" {
  value = module.firewall[0].firewall_policy_id
}

output "firewall_public_ip" {
  value = module.firewall[0].firewall_public_ip
}