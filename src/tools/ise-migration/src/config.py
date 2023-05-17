from termcolor import colored
import os
import yaml

class Config:
    
    def __init__(self) -> None:
        self.fsWorkflowMap = []
        self.exported_ise_directory = '../.internal/exported-ise'
        
        
class FileshareWorkflowMap:
    def __init__(self) -> None:
        self.storage_Account_name = ""
        self.fileshareName = ""
        self.sas_url_envvar_name = ""
        self.workflow_folder_names = []
        
def load_config() -> Config:
    
    config = Config()
    configFilePath = os.path.join(os.path.dirname(__file__), 'config.yaml')
    
    with open(configFilePath, "r") as stream:
        try:
            yamlConfig = yaml.safe_load(stream)
            
            if len(yamlConfig) == 0:
                colored('config.yaml is either empty or invalid', 'red')
                return
            
            config.exported_ise_directory = yamlConfig['exported_ise_directory']
            
            for c in yamlConfig['fileshare_workflow_map']:
                wmap = FileshareWorkflowMap()
                wmap.storage_Account_name = c['storage_Account_name']
                wmap.fileshareName = c['fileshareName']
                wmap.sas_url_envvar_name = c['sas_url_envvar_name']
                
                workflow_folders = c['workflow_folder_names'] 
                
                wmap.workflow_folder_names = workflow_folders
                
                config.fsWorkflowMap.append(wmap)
                
            return config
        
        except yaml.YAMLError as exc:
            colored(exc, 'red')