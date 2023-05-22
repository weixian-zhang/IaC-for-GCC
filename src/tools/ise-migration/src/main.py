from azure.storage.fileshare import ShareServiceClient
from config import Config, load_config
from exported_ise import ExportedISEProject, WorkflowInfo
from fileshare import LogicAppFileshareClient
from termcolor import colored
import os
import argparse
# import readline

config = Config()
exportedISE: ExportedISEProject = None
wwwroot = 'site/wwwroot'

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
                
                workflowDir = f'{wwwroot}/{workflowInfo.dirName}'
                
                ok, err = fsclient.upload_file(fileshare_name=fileshareName, 
                                               dir_in_fileshare=workflowDir, 
                                               filename_in_fileshare=exportedISE.workflowFileName, 
                                               file_to_upload_path=workflowInfo.fullWorkflowFilePath,
                                               overwrite=fs.overwrite_workflow)
                if not ok:
                    print(colored(err, 'red'))
            
            # upload parameters.json
            if not os.path.exists(exportedISE.parametersFileNamePath):
                print(colored(f'parameters.json does not exist to upload to \'{storage.account_name}/{fileshareName}/{wwwroot}\'', 'yellow'))
            else:
                ok, err = fsclient.upload_file( fileshare_name=fileshareName, 
                                                dir_in_fileshare=wwwroot, 
                                                filename_in_fileshare=exportedISE.parametersFileName, 
                                                file_to_upload_path=exportedISE.parametersFileNamePath,
                                                overwrite=True)
                if not ok:
                    print(colored(f'Error when upload \'{exportedISE.parametersFileName}\' \n {err}', 'red'))
                else:
                    print(colored(f'uploaded \'{exportedISE.parametersFileName}\' to \'{storage.account_name}/{fileshareName}/{wwwroot}\'', 'green'))
                    
                    
            # upload connections.json
            # upload parameters.json
            if not os.path.exists(exportedISE.connectionsFileNamePath):
                print(colored(f'parameters.json does not exist to upload to \'{storage.account_name}/{fileshareName}/{wwwroot}\'', 'yellow'))
            else:
                ok, err = fsclient.upload_file( fileshare_name=fileshareName, 
                                                dir_in_fileshare=wwwroot, 
                                                filename_in_fileshare=exportedISE.connectionsFileName, 
                                                file_to_upload_path=exportedISE.connectionsFileNamePath,
                                                overwrite=True)
                if not ok:
                    print(colored(f'Error when upload \'{exportedISE.connectionsFileName}\' \n {err}', 'red'))
                else:
                    print(colored(f'uploaded \'{exportedISE.connectionsFileName}\' to \'{storage.account_name}/{fileshareName}/{wwwroot}\'', 'green'))
            
                
                


def upload_parametersJson_to_fileshare(fileshareName, parameterFilePath):
    pass

def upload_connectionsJson_to_fileshare(fileshareName, connectionFilePath):
    pass

def start():
    
    configYamlPath = get_config_from_cmd_arg()

    ok, err, config = load_config(configYamlPath)
    
    if not ok:
        print(colored(f'Error when loading config.yaml. \n {err}', 'red'))
        return
    
    exportedISE = ExportedISEProject(config.exported_ise_directory)
    
    exportedISE.load()
    
    upload_workflows_to_fileshares(config, exportedISE)


def get_config_from_cmd_arg():
    parser = argparse.ArgumentParser(description='welcome to ISE exported workflow deployment tool')
    
    parser.add_argument('configyaml', help='path to config.yaml')
    
    configYamlPath = './config.yaml'
    
    try:
        args = parser.parse_args()
        configYamlPath = args.configyaml
    except:
        pass
    
    return configYamlPath
    

if __name__ == '__main__':
    start() 
    user_input = input('press any key to exit')
    
    
    
    
    

        
    
