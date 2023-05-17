from azure.storage.fileshare import ShareServiceClient
import yaml

from config import Config, load_config
from exported_ise import ExportedISE, WorkflowInfo
from logicapp_fileshare_client import LogicAppFileshareClient
from termcolor import colored

fileshare_client = None
config = Config()
exportedISE: ExportedISE = None



    #fileshare_client = ShareServiceClient(account_url="https://<my_account_name>.file.core.windows.net", credential=)

def upload_workflow_to_fileshare():
    
    for storage in config.storage_accounts:
        fsclient = LogicAppFileshareClient(storage.account_name, storage.sas_token)
        
        for fs in storage.fileshares:
            fileshareName = fs.fileshareName
            
            for wfn in fs.workflow_folder_names:
                
                workflowInfo: WorkflowInfo = exportedISE.workflowDirs[wfn]
                
                fsclient.upload_workflow(fileshareName, workflowInfo.dirName,  workflowInfo.fullWorkflowFilePath)

def upload_parametersJson_to_fileshare():
    pass

def upload_connectionsJson_to_fileshare():
    pass

def upload_hostJson_to_fileshare():
    pass

def main():
    
    ok, config = load_config()
    
    if not ok:
        print(colored('config.yaml failed to load due to missing values or invalid schema', 'red'))
        return
    
    exportedISE = ExportedISE(config.exported_ise_directory)
    
    exportedISE.load()
    
    
    
    
    
    pass


if __name__ == '__main__':
    main()
    
    
    
    
    

        
    
