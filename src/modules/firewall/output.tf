

output "firewall_id" {
  value = azurerm_firewall.firewall.id
}

output "firewall_policy_id" {
  value = azurerm_firewall_policy.firewall_policy.id
}

output "firewall_public_ip" {
  value = azurerm_public_ip.firewall_public_ip.ip_address
}

output "diagnostic_settings_log_category_types" {
    value = module.diagnostic_settings.log_category_types
}