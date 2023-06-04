
# terraform {
#   required_providers {
#     azurerm = {
#         source = "hashicorp/azurerm"
#         version = "3.55.0"
#     }

#     random = {
#       source  = "hashicorp/random"
#       version = "3.4.3"
#     }
#   }
# }

# provider "azurerm" {
#   features {}

#   subscription_id   = var.subscription_id
#   tenant_id         = var.tenant_id
#   client_id         = var.client_id
#   client_secret     = var.client_secret 
# }

resource "random_integer" "fileshare_suffix" {
  min = 1
  max = 10000
  seed = timestamp()
}


#Create a storage account to be used by the logic apps
resource "azurerm_storage_account" "logicapp_storage" {
    for_each = { for idx, setting in var.logic_app_settings : idx => setting  }

    name                     = each.value.storage_name #var.storage_name
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "ZRS"
}

#Create a log analytics workspace for use by logic apps and app insights in workspace mode
resource "azurerm_log_analytics_workspace" "law" {
    count = (var.existing_log_analytics_workspace_id == "") ? 1 : 0
    name                = var.new_log_analytics_workspace_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    sku                 = "PerGB2018"
    retention_in_days   = 30
}

#Create an app insights instance for the logic apps to send telemetry to
resource "azurerm_application_insights" "appinsights" {
    name                = var.app_insights_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    application_type    = "web"
    workspace_id        = (var.existing_log_analytics_workspace_id == "") ? azurerm_log_analytics_workspace.law[0].id : var.existing_log_analytics_workspace_id
}

#an app service plan for the logic apps to run on
resource "azurerm_app_service_plan" "app_service_plan" {
    for_each = local.logic_apps 

    name                    = each.value.app_service_plan_name
    location                = var.location
    resource_group_name     = coalesce(each.value.resource_group_name, var.resource_group_name)
    kind                    = "elastic"
    is_xenon                = "false"
    per_site_scaling        = "false"
    reserved                = "false"
    tags                    = var.tags
    zone_redundant          = "true"
    sku {
        tier = "WorkflowStandard"
        size = coalesce(each.value.app_service_plan_sku_size, "WS1")
    }
}

#Create a Logic App on the plan
resource "azurerm_logic_app_standard" "logic_app_standard" {
    for_each = local.logic_apps 

    name                        = each.value.logic_app_name
    location                    = var.location
    resource_group_name         = coalesce(each.value.resource_group_name, var.resource_group_name)
    app_service_plan_id         = azurerm_app_service_plan.app_service_plan[each.key].id
    storage_account_name        = azurerm_storage_account.logicapp_storage[each.value.storage_index].name
    storage_account_access_key  = azurerm_storage_account.logicapp_storage[each.value.storage_index].primary_access_key
    storage_account_share_name  = each.value.logic_app_name # name of fileshare where all workflows, connections.json and parameters.json are kept

    https_only                  = true
    version                     = "~4"

    identity  {
        type = "SystemAssigned"
    }

    app_settings = local.global_app_settings
}
