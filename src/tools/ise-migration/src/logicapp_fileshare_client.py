
from azure.storage.fileshare import ShareServiceClient, ShareDirectoryClient
import os
from termcolor import colored


class LogicAppFileshareClient:
    
    def __init__(self, account_name, sas_token) -> None:
        
        self.wwwroot = 'site/wwwroot'
        
        self.storage_client = ShareServiceClient(account_url=f"https://{account_name}.file.core.windows.net", credential=sas_token)
        
        
        
        
        
    def upload_workflow(self, fileshareName, workflowDirName, localWorkflowFilePath):
        
        try:
            file_client  = self.storage_client.get_share_client(fileshareName)
        
            workflowDir = os.path.join(self.wwwroot, workflowDirName)
            
            dir_client = file_client.get_directory_client(workflowDir)
            
            dir_client.create_directory()
            
            dir_client.upload_file(file_name=localWorkflowFilePath)
        
        except Exception as e:
            print(colored(f'Error whole uploading workflow {localWorkflowFilePath}', 'red'))
        
        
        