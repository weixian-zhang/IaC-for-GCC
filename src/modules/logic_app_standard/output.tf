
output "logicapp_standard_id" {
  value = azurerm_logic_app_standard.logic_app_standard.id
}

output "storage_id" {
  value = azurerm_storage_account.logicapp_storage.id
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.app_service_plan.id
}