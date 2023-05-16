
# intentionally ignore metric, only targeting logs
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
    #count = (local.law_id == "") ? 0 : length(var.resource_ids)
    for_each = {for idx,rid in var.resource_ids: idx => rid }

    name                       = "diag-${local.resource_names_from_ids[each.key]}"
    target_resource_id         = each.value
    log_analytics_workspace_id = local.law_id

    dynamic "enabled_log" {
        for_each = data.azurerm_monitor_diagnostic_categories.diag_log_categories[each.key].log_category_types
        content {
            category = enabled_log.value

            retention_policy {
                enabled = false
            }
        }
    }
  
}