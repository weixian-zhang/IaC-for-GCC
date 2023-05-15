

variable "client_id" {
}

variable "client_secret" {
}

variable "subscription_id" {
}

variable "tenant_id" {
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "resource_ids" {
   description = "a list of resource ids to enable diagnostic settings on"
   type = list(string)
}

variable "retention_days" {
  default = 365
}