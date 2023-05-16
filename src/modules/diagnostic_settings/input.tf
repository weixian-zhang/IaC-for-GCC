

variable "log_analytics_workspace_name" {
  type = string
}

variable "log_analytics_workspace_resource_group" {
  type = string
}

variable "resource_ids" {
   description = "a list of resource ids to enable diagnostic settings on"
   type = list(string)
}

variable "retention_days" {
  default = 365
}