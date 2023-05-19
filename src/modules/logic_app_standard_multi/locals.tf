

locals {
  
  base_app_settings = {
          "FUNCTIONS_WORKER_RUNTIME"     = "node"
          "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
          "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsights.instrumentation_key
          "ApplicationInsightsAgent_EXTENSION_VERSION" = "2"
  }

  global_app_settings = merge(local.base_app_settings, var.logic_app_global_app_settings)

  logic_apps = { 
    for idx, logicapp in flatten([
        for idx, setting in var.logic_app_settings : 
        [ 
            for idx, logic_app in setting.logic_apps: merge(logic_app, {"storage_name" : setting.storage_name})
        ]
    ]) : idx => logicapp
  }
  # result:
    #   {
    #   "0" = {
    #     "app_service_plan_name" = "asp-ise-migrated-logicapp-001"
    #     "app_service_plan_sku_size" = tostring(null)
    #     "logic_app_name" = "ise-migrated-logicapp-001"
    #     "resource_group_name" = tostring(null)
    #     "storage_name" = "strgloappstdterr1"
    #   }
    #   "1" = {
    #     "app_service_plan_name" = "asp-ise-migrated-logicapp-001"
    #     "app_service_plan_sku_size" = tostring(null)
    #     "logic_app_name" = "ise-migrated-logicapp-002"
    #     "resource_group_name" = tostring(null)
    #     "storage_name" = "strgloappstdterr1"
    #   }
    #   "2" = {
    #     "app_service_plan_name" = "asp-ise-migrated-logicapp-002"
    #     "app_service_plan_sku_size" = tostring(null)
    #     "logic_app_name" = "ise-migrated-logicapp-003"
    #     "resource_group_name" = tostring(null)
    #     "storage_name" = "strgloappstdterr1"
    #   }
    #   "3" = {
    #     "app_service_plan_name" = "asp-ise-migrated-logicapp-004"
    #     "app_service_plan_sku_size" = tostring(null)
    #     "logic_app_name" = "ise-migrated-logicapp-004"
    #     "resource_group_name" = tostring(null)
    #     "storage_name" = "strgloappstdterr2"
    #   }
    # ...
}