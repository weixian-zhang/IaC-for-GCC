
variable "environment_name" {
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
  default = "log-logicapp-standard"
}

variable "app_insights_name" {
  default = "appi-logicapp-standard"
}

variable "app_service_plan_name" {
  default = "asp-logicapp-standard"
}

# tier vCPU	Memory(GB)
# WS1	 1	  3.5
# WS2	 2	  7
# WS3	 4	  14
variable "app_service_plan_sku" {
  default = "WS1"
}

variable "storage_name" {
  default = "stlogicappstd1"
}

variable "logicapp_name" {
  default = "logic-standard-dev-1"
}

variable "logicapp_fileshare_name" {
  default = "fileshare-logic-standard-dev-001"
}
