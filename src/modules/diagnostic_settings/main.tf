

# https://www.mediaglasses.blog/2021/08/30/some-terraform-azure-notes/

# https://github.com/claranet/terraform-azurerm-diagnostic-settings/blob/master/locals.tf

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories

# data "vsphere_datastore" "datastore" {
#   for_each = var.CwVMs

#   name          = each.value.Datastore
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# resource "vsphere_virtual_machine" "dev-vm" {
#   for_each = var.CwVMs
#   name  = "crosswork-${each.key}"

#   datastore_id     = data.vsphere_datastore.datastore[each.key].id
# }


# intentionally ignore metric, only targeting logs
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
    count = (local.law_id == "") ? 0 : length(var.resource_ids)

    name                       = "diag-${local.resource_names_from_ids[count.index]}"
    target_resource_id         = var.resource_ids[count.index]
    log_analytics_workspace_id = local.law_id
    
    dynamic "log" {
        for_each = data.azurerm_monitor_diagnostic_categories.diag_log_categories[count.index].log_category_types

        content {
            category = log.value
            retention_policy {
                days    = var.retention_days
                enabled = true
            }
        }
    }

  
}