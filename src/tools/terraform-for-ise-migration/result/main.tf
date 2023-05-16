


terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.55.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
  client_id         = var.client_id
  client_secret     = var.client_secret 
}



resource "azurerm_logic_app_workflow" "logicapp" {
  name = "logicapp-workflow-from-terraform"
  location            = "eastasia"
  resource_group_name = "gcc-hk"
  tags                = {}
}

// Deploy the ARM template to configure the workflow in the Logic App
data "local_file" "arm_tpl_file" {
    filename = "workflow_arm.json"
}

// Deploy the ARM template workflow
resource "azurerm_template_deployment" "workflow" {
  depends_on = [azurerm_logic_app_workflow.logicapp]
  
  name = "logicapp-workflow-from-terraform"
  resource_group_name = "gcc-hk"
#   parameters = merge({
#     "workflowName" = "logicapp-workflow-from-terraform",
#     "location"     = "eastasia"
#   }, {}) #var.parameters)

  deployment_mode = "Incremental"

  template_body = data.local_file.arm_tpl_file.content
}