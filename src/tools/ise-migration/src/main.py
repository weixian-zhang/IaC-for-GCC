from azure.storage.fileshare import ShareServiceClient
from config import Config, load_config
from exported_ise import ExportedISEProject, WorkflowInfo
from fileshare import LogicAppFileshareClient
from termcolor import colored

config = Config()
exportedISE: ExportedISEProject = None


# assumed constraints: 
    # 1 <= config.storage_accounts => 10
    # 1 <= storage.fileshares => 500
    # 1 <= exportedISE.workflowDirs => 500
# time complexity: O(storage_accounts * n2) = O(n2) where n <= 500 
def upload_workflows_to_fileshares(config: Config, exportedISE: ExportedISEProject):
    
    for storage in config.storage_accounts:
        fsclient = LogicAppFileshareClient(storage.account_name, storage.sas_token)
        
        for fs in storage.fileshares:
            
            fileshareName = fs.fileshareName
            
            for wfn in fs.workflow_folder_names:
                
                if wfn not in exportedISE.workflowDirs:
                    print(colored(f'workflow-folde-name {wfn} is not found in exported-ise-project folder', 'yellow'))
                    continue
                    
                workflowInfo: WorkflowInfo = exportedISE.workflowDirs[wfn]
                
                ok, err = fsclient.upload_workflow(fileshareName, 
                                                   workflowInfo.dirName, 
                                                   exportedISE.workflowFileName, 
                                                   workflowInfo.fullWorkflowFilePath,
                                                   fs.overwrite_workflow)
                
                if not ok:
                    print(colored(err, 'red'))


def upload_parametersJson_to_fileshare(fileshareName, parameterFilePath):
    pass

def upload_connectionsJson_to_fileshare(fileshareName, connectionFilePath):
    pass


def main():
    
    ok, err, config = load_config()
    
    if not ok:
        print(colored(err, 'red'))
        return
    
    exportedISE = ExportedISEProject(config.exported_ise_directory)
    
    exportedISE.load()
    
    upload_workflows_to_fileshares(config, exportedISE)



if __name__ == '__main__':
    main()
    
    
    
    
    

        
    
