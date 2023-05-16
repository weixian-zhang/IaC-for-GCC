data "azurerm_monitor_diagnostic_categories" "diag_log_categories" {
    count = length(var.resource_ids)
    resource_id = var.resource_ids[count.index]
}

data "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group
}