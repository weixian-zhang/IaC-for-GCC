from azure.storage.fileshare import ShareServiceClient
from config import Config, load_config
from exported_ise import ExportedISEProject, WorkflowInfo
from fileshare import LogicAppFileshareClient
from termcolor import colored
import os
import argparse
from log import Logger

config = Config()
exportedISE: ExportedISEProject = None
wwwroot = 'site/wwwroot'
logger = Logger()

# assumed constraints: 
    # 1 <= config.storage_accounts => 10
    # 1 <= storage.fileshares => 500
    # 1 <= exportedISE.workflowDirs => 500
# time complexity: O(storage_accounts * n2) = O(n2) where n <= 500 
def upload_workflows_to_fileshares(config: Config, exportedISE: ExportedISEProject):
    
    logger.info('begin upload workflows, parameters.json and connections.json to fileshares \n')
    
    for storage in config.storage_accounts:
        
        fsclient = LogicAppFileshareClient(storage.account_name, storage.sas_token)
        
        logger.info(f'uploading at storage {storage.account_name}')
        
        for fs in storage.fileshares:
            
            fileshareName = fs.fileshareName
            
            logger.info(f'at fileshare {fileshareName}')
            
            for wfn in fs.workflow_folder_names:
                
                if wfn not in exportedISE.workflowDirs:
                    logger.warn(f'workflow-folde-name {wfn} is not found in exported-ise-project folder')
                    continue
                    
                workflowInfo: WorkflowInfo = exportedISE.workflowDirs[wfn]
                
                workflowDir = f'{wwwroot}/{workflowInfo.dirName}'
                
                ok, err = fsclient.upload_file(fileshare_name=fileshareName, 
                                               dir_in_fileshare=workflowDir, 
                                               filename_in_fileshare=exportedISE.workflowFileName, 
                                               file_to_upload_path=workflowInfo.fullWorkflowFilePath,
                                               overwrite=fs.overwrite_workflow)
                if not ok:
                    logger.error(err)
            
            
            upload_parametersJson_to_fileshare(fsclient, storage.account_name, fileshareName, exportedISE)
            
            upload_connectionsJson_to_fileshare(fsclient, storage.account_name, fileshareName, exportedISE)
            
                
            
# upload parameters.json
def upload_parametersJson_to_fileshare(fsclient, storage_account_name, file_share_name, exportedISE: ExportedISEProject):
    if not os.path.exists(exportedISE.parametersFileNamePath):
        logger.warn(f'parameters.json does not exist to upload to \'{storage_account_name}/{file_share_name}/{wwwroot}\'')
    else:
        ok, err = fsclient.upload_file( fileshare_name=file_share_name, 
                                        dir_in_fileshare=wwwroot, 
                                        filename_in_fileshare=exportedISE.parametersFileName, 
                                        file_to_upload_path=exportedISE.parametersFileNamePath,
                                        overwrite=True)
        if not ok:
            logger.error(f'Error when upload \'{exportedISE.parametersFileName}\' \n {err}')
        else:
            logger.success(f'uploaded \'{exportedISE.parametersFileName}\' to \'{storage_account_name}/{file_share_name}/{wwwroot}\'')

# upload connections.json
def upload_connectionsJson_to_fileshare(fsclient, storage_account_name, file_share_name, exportedISE: ExportedISEProject):
    if not os.path.exists(exportedISE.connectionsFileNamePath):
        logger.info(f'parameters.json does not exist to upload to \'{storage_account_name}/{file_share_name}/{wwwroot}\'')
    else:
        ok, err = fsclient.upload_file( fileshare_name=file_share_name, 
                                        dir_in_fileshare=wwwroot, 
                                        filename_in_fileshare=exportedISE.connectionsFileName, 
                                        file_to_upload_path=exportedISE.connectionsFileNamePath,
                                        overwrite=True)
        if not ok:
            logger.error(f'Error when upload \'{exportedISE.connectionsFileName}\' \n {err}')
        else:
            logger.success(f'uploaded \'{exportedISE.connectionsFileName}\' to \'{storage_account_name}/{file_share_name}/{wwwroot}\'')



def start():
    
    configYamlPath = get_config_from_cmd_arg()
    
    logger.info(f'loading config.yaml from: {configYamlPath}')
    
    ok, err, config = load_config(configYamlPath)
    
    if not ok:
        logger.error(f'Error when loading config.yaml. \n {err}')
        #print(colored(f'Error when loading config.yaml. \n {err}', 'red'))
        return
    
    logger.info(f'config.yaml loaded \n')
    
    logger.info(f'loading ISE exported project folder structure from: {config.exported_ise_directory}')
    
    exportedISE = ExportedISEProject(config.exported_ise_directory)
    
    exportedISE.load()
    
    logger.info(f'ISE exported project folder structurel loaded \n')
    
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
    
    
    
    
    

        
    
