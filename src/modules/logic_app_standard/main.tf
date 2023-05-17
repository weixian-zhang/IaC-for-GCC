
#Create a storage account to be used by the logic apps
resource "azurerm_storage_account" "logicapp_storage" {
    name                     = var.storage_name
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "ZRS"
}

#Create a plan for the logic apps to run on
resource "azurerm_app_service_plan" "app_service_plan" {
    name                    = var.app_service_plan_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    kind                    = "elastic"
    is_xenon                = "false"
    per_site_scaling        = "false"
    reserved                = "false"
    tags                    = {}
    zone_redundant          = "false"
    sku {
        tier = "WorkflowStandard"
        size = var.app_service_plan_sku
    }
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
resource "azurerm_application_insights" "appinsights_logicapp" {
    name                = var.app_insights_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    application_type    = "web"
    workspace_id        = (var.existing_log_analytics_workspace_id == "") ? azurerm_log_analytics_workspace.law[0].id : var.existing_log_analytics_workspace_id
}

#Create a Logic App on the plan
resource "azurerm_logic_app_standard" "logic_app_standard" {
    name                        = var.logicapp_name
    location                    = var.location
    resource_group_name         = var.resource_group_name
    app_service_plan_id         = azurerm_app_service_plan.app_service_plan.id
    storage_account_name        = azurerm_storage_account.logicapp_storage.name
    storage_account_access_key  = azurerm_storage_account.logicapp_storage.primary_access_key
    storage_account_share_name  = var.logicapp_fileshare_name   # name of fileshare where all workflows, connections.json and parameters.json are kept

    https_only                  = true
    version                     = "~4"

    identity  {
        type = "SystemAssigned"
    }

    app_settings = {
          "FUNCTIONS_WORKER_RUNTIME"     = "node"
          "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
          "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsights_logicapp.instrumentation_key
          "ApplicationInsightsAgent_EXTENSION_VERSION" = "2"
    }
}
