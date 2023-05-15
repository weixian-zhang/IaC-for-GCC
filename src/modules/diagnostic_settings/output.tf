

output "log_category_types" {
    value = [for logcat in data.azurerm_monitor_diagnostic_categories.diag_log_categories: logcat.log_category_types]
}