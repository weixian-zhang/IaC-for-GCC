## IaC-for-GCC  

This repo contains:
* Terraform modules of Azure Landing Zone examples used in GCC platform
* Integration Service Environment (ISE) exported workflows migration toolkit

<br />

### ISE Exported Workflows Migration Toolkit  

As ISE will be [retiring on August 31th 2024](https://github.com/azure-deprecation/dashboard/issues/247), the Azure team has developed a [workflow export tool](https://learn.microsoft.com/en-us/azure/logic-apps/export-from-ise-to-standard-logic-app) to support migrating of ISE workflows to Logic App Standard workflows.  
This export tool exports each workflow into a separate folder, following the [project structure of Logic App Standard](https://github.com/MicrosoftDocs/azure-docs/blob/main/includes/logic-apps-single-tenant-project-structure-visual-studio-code.md).  

Workflows in Logic App is treated like Web Apps and Function Apps which allow you to develop and test Logic Apps in VSCode with [Logic App Standard extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurelogicapps).  
\*As Logic App is treated like an App, deployment Logic App through IaC like ARM or Terraform will not be possible.

![image](https://github.com/weixian-zhang/IaC-for-GCC/assets/43234101/6f334358-444c-474b-86f4-2b36367af241)  



