variable "client_id" {
}

variable "client_secret" {
}

variable "subscription_id" {
}

variable "tenant_id" {
}

variable "env" {
  type = string
  default = "dev"
}

variable "location" {
  default = "southeastasia"
}

variable "resource_group_name" {
  type = string
  default = "rg-logic-app-standard"
}

variable "existing_log_analytics_workspace_id" {
  default = ""
}

variable "new_log_analytics_workspace_name" {
  default = "log-logicapp-standard-001"
}

variable "app_insights_name" {
  default = "appi-logicapp-standard-001"
}

variable "app_service_plan_name" {
  default = "asp-logicapp-standard-001"
}


variable "logic_app_settings" {
  default =  [
    {
        storage_name = "strgloappstdterr1"
        logic_apps = [
            {
                #resource_group_name = optional(string)  # default var.resource_group_name
                logic_app_name = "ise-migrated-logicapp-001"
                #app_service_plan_sku_size = optional(string) # default WS1
                app_service_plan_name = "asp-ise-migrated-logicapp-001"  # if name is the same, logic app will be "grouped" in thesame app service plan
            },
            {
                #resource_group_name = optional(string)  # default var.resource_group_name
                logic_app_name = "ise-migrated-logicapp-002"
                #app_service_plan_sku_size = optional(string) # default WS1
                app_service_plan_name = "asp-ise-migrated-logicapp-001"  # if name is the same, logic app will be "grouped" in thesame app service plan
            },
            {
                #resource_group_name = optional(string)  # default var.resource_group_name
                logic_app_name = "ise-migrated-logicapp-003"
                #app_service_plan_sku_size = optional(string) # default WS1
                app_service_plan_name = "asp-ise-migrated-logicapp-002"  # if name is the same, logic app will be "grouped" in thesame app service plan
            }
        ]
    },
    {
        storage_name = "strgloappstdterr2"
        logic_apps = [
            {
                #resource_group_name = optional(string)  # default var.resource_group_name
                logic_app_name = "ise-migrated-logicapp-004"
                #app_service_plan_sku_size = optional(string) # default WS1
                app_service_plan_name = "asp-ise-migrated-logicapp-004"  # if name is the same, logic app will be "grouped" in thesame app service plan
            },
            {
                #resource_group_name = optional(string)  # default var.resource_group_name
                logic_app_name = "ise-migrated-logicapp-005"
                #app_service_plan_sku_size = optional(string) # default WS1
                app_service_plan_name = "asp-ise-migrated-logicapp-005"  # if name is the same, logic app will be "grouped" in thesame app service plan
            },
            {
                #resource_group_name = optional(string)  # default var.resource_group_name
                logic_app_name = "ise-migrated-logicapp-006"
                #app_service_plan_sku_size = optional(string) # default WS1
                app_service_plan_name = "asp-ise-migrated-logicapp-005"  # if name is the same, logic app will be "grouped" in thesame app service plan
            }
        ]
    }
  ]

  type = list(object({
    storage_name = string
    logic_apps = list(object({
      resource_group_name = optional(string)  # default var.resource_group_name
      logic_app_name = string
      app_service_plan_sku_size = optional(string) # default WS1
      app_service_plan_name = string  # if name is the same, logic app will be "grouped" in thesame app service plan
    }))
  }))
}

# *note: Service Provide Connection gets the connection access key,
# conn_string and other secrets from Logic App -> Configuration -> App Settings
# In situation when migrating workflows from ISE, consider using this option to add "API Connection" key/secret here
# secret values can be in tfvars or recommended to be in env vars TF_VAR_{secret}
variable "logic_app_global_app_settings" {
    default = {}
}

variable "tags" {
  default = {}
}

# tier vCPU	Memory(GB)
# WS1	 1	  3.5
# WS2	 2	  7
# WS3	 4	  14
# variable "app_service_plan_sku" {
#   default = "WS1"
# }

# variable "storage_name" {
#   default = "stlogicappstd1"
# }

# variable "logicapp_name" {
#   default = "logic-standard-dev-1"
# }

# variable "logicapp_fileshare_name" {
#   default = "fileshare-logic-standard-dev-001"
# }
