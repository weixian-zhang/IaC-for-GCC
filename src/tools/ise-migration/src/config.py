from termcolor import colored
import os
import yaml

class Config:
    
    def __init__(self) -> None:
        self.storage_accounts = []
        self.exported_ise_directory = '../.internal/exported-ise'

class StorageAccount:
    def __init__(self) -> None:
        self.account_name = ''
        self.sas_token_envvar_name = ''
        self.sas_token = ''   # load from env variable
        self.fileshares = []
        
class Fileshare:
    def __init__(self) -> None:
        self.fileshareName = ''
        self.overwrite_workflow = True
        self.workflow_folder_names = []
        
class StorageWorkflowMap:
    def __init__(self) -> None:
        self.storage_accounts = []
        self.fileshareName = ""
        self.sas_token_envvar_name = ""
        self.workflow_folder_names = []
        
def load_config() -> tuple([str, bool, Config]):
    
    config = Config()
    configFilePath = os.path.join(os.path.dirname(__file__), 'config.yaml')
    
    with open(configFilePath, "r") as stream:
        try:
            yamlConfig = yaml.safe_load(stream)
            
            if len(yamlConfig) == 0:
                colored('config.yaml is either empty or invalid', 'red')
                return
            
            config.exported_ise_directory = yamlConfig['exported_ise_directory']
            
            for strg in yamlConfig['logicapp_storage_accounts']:
                
                strgAcct = strg['storage_account']
                sa = StorageAccount()
                sa.account_name = strgAcct['account_name'] if strgAcct['account_name'] is not None else ''
                sa.sas_token_envvar_name = strgAcct['sas_token_envvar_name'] if strgAcct['sas_token_envvar_name'] is not None else ''
                
                sa.sas_token = os.environ.get(sa.sas_token_envvar_name)
                if sa.sas_token == None:
                    errMsg = 'error getting sas_token with invalid environment variable name'
                    print(colored(errMsg, 'red'))
                    return False, errMsg, None
                    
                
                for fs in strgAcct['fileshares']:
                    
        
                    fileshare = Fileshare()
                    fileshare.fileshareName = fs['file_share_name'] if fs['file_share_name'] is not None else ''
                    fileshare.overwrite_workflow = bool(fs['overwrite_workflow']) if fs['overwrite_workflow'] is not None else False
                    fileshare.workflow_folder_names = fs['workflow_folder_names'] if fs['workflow_folder_names'] is not None else []
                    
                    sa.fileshares.append(fileshare)
                

                fileshare.workflow_folder_names = set(fileshare.workflow_folder_names)
                
                config.storage_accounts.append(sa)
                
            return True, '', config
        
        except yaml.YAMLError as exc:
            return False, exc, None