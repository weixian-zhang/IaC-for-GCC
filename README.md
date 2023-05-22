## IaC-for-GCC  

This repo contains:
* Terraform modules of Azure Landing Zone examples used on [Goverment on Commercial Cloud platform](https://www.developer.tech.gov.sg/products/categories/infrastructure-and-hosting/government-on-commercial-cloud/overview.html)
* Integration Service Environment (ISE) exported workflows migration toolkit
  * Some facts about Logic App Standard to note
  * How migration toolkit works

<br />

### ISE Exported Workflows Migration Toolkit  

As ISE will be [retiring on August 31th 2024](https://github.com/azure-deprecation/dashboard/issues/247), the Azure team has developed a [workflow export tool](https://learn.microsoft.com/en-us/azure/logic-apps/export-from-ise-to-standard-logic-app) to support migrating of ISE workflows to Logic App Standard workflows.  
This export tool exports each workflow into a separate folder, following the [project structure of Logic App Standard](https://github.com/MicrosoftDocs/azure-docs/blob/main/includes/logic-apps-single-tenant-project-structure-visual-studio-code.md).  

Workflows in Logic App is treated like Web Apps and Function Apps which allow you to develop and test Logic Apps in VSCode with [Logic App Standard extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurelogicapps).  


### Some facts about Logic App Standard to note:
* As Logic App is treated like an App, deployment Logic App through IaC like ARM or Terraform is not be possible.
* 1 Logic App Standard can contains many workflows. The practice is to have 10-15 workflows per Logic App 
* Logic App Standard requires a mounted Azure Fileshare to store workflows. Each workflow is located in site/wwwroot/workflow-folder-name
* ISE workflow's API Connections is known as "Service Provider Connections"
* the secret value of each service connection for example Event Hub connection string, Storage connection string are read from [Logic App's App Settings](https://learn.microsoft.com/en-us/azure/logic-apps/edit-app-settings-host-settings?tabs=azure-portal#manage-app-settings---localsettingsjson)  
* 

<br />

### How migration toolkit works
This migration toolkit contains 2 artifacts:
* [Terraform module](https://github.com/weixian-zhang/IaC-for-GCC/tree/main/src/modules/logic_app_standard_multi) - Allows you to create multiple Logic App Standards, Storage accounts and filshares.
* Cmdline app (Python zipapp) - Upload workflows
  * deploy-ise-workflows-v0.6.0.zip
  * config.yaml

![image](https://github.com/weixian-zhang/IaC-for-GCC/assets/43234101/6f334358-444c-474b-86f4-2b36367af241)  



