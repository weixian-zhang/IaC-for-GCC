
from azure.storage.fileshare import ShareServiceClient, ShareDirectoryClient, ShareClient
import os
from termcolor import colored
from log import Logger

class LogicAppFileshareClient:
    
    def __init__(self, account_name, sas_token) -> None:
        
        self.account_name = account_name
        self.sas_token = sas_token
        self.logger = Logger()
        
        
    def upload_file(self, fileshare_name, dir_in_fileshare, filename_in_fileshare, file_to_upload_path, overwrite=True) -> tuple([bool, str]):
        
        try:
            
            self.logger.info(f'try connecting to storage account \'{self.account_name}\'')
            
            storage_client = ShareServiceClient(account_url=f"https://{self.account_name}.file.core.windows.net", credential=self.sas_token)
            
            strgExist, strgErr = self.is_storage_exist(storage_client)
            if strgExist:
                self.logger.info(f'connected to storage account \'{self.account_name}\'')
            else:
                return False, f'Error when connecting to storage account \'{self.account_name}\'. \n {strgErr}'
            
            file_client  = storage_client.get_share_client(fileshare_name)
            
            self.logger.info(f'try connecting to fileshare \'{self.account_name}/{fileshare_name}\'')
            
            fsExist, fsErr = self.is_fileshare_exist(file_client)
            if fsExist:
                self.logger.info(f'connected to fileshare \'{self.account_name}/{fileshare_name}\'')
            else:
                return False, f'Error when connecting to fileshare {self.account_name}/{fileshare_name} \n {fsErr}'
    
            
            dir_client = file_client.get_directory_client(dir_in_fileshare)
            
            if not self.is_fileshare_dir_exist(dir_client):
                dir_client.create_directory()
                
                self.logger.info(f'created workflow folder \'{self.account_name}/{dir_in_fileshare}\'')
            else:
                self.logger.info(f'directory \'{fileshare_name}/{dir_in_fileshare}\' already exist')
            
            
            ok, err, workflowContent = self.read_file_as_str(file_to_upload_path)
            
            if not ok:
                return False, err
            
            if not self.is_file_exist_in_fileshare(dir_client, filename_in_fileshare) or overwrite:
                dir_client.upload_file(file_name=filename_in_fileshare, data=workflowContent)
                self.logger.info(f'overwriting workflow \'{dir_in_fileshare}\' with \'{self.account_name}/{dir_in_fileshare}\' \n')
            else:
                self.logger.success(f'Workflow \'{dir_in_fileshare}\' already exist in \'{self.account_name}/{dir_in_fileshare}\' \n')
            
            
            return True, ''
        
        except Exception as e:
            return False, e
    
    def is_storage_exist(self, storage_client: ShareServiceClient) -> tuple([bool, str]):
        try:
            storage_client.get_service_properties()
            return True, ''
        except Exception as e:
            return False, str(e)
    
    def is_fileshare_exist(self, share_client: ShareClient) -> tuple([bool, str]):
        try:
            share_client.get_share_properties()
            return True, ''
        except Exception as e:
            return False, str(e)
            
    
    def is_file_exist_in_fileshare(self, dir_client :ShareDirectoryClient, filename):
        fileClient = dir_client.get_file_client(filename)
        
        try:
            fileClient.get_file_properties()
            return True
        except:
            return False
    
    def is_fileshare_dir_exist(self, dirClient: ShareDirectoryClient):
        
        try:
            dirClient.get_directory_properties()
            return True
        except:
            return False
        
    def read_file_as_str(self, filepath) -> tuple([bool,str,str]):
        try:
            if not os.path.exists(filepath):
                return False, f'file does not exists: {filepath}', ''
            
            with open(filepath, 'r') as file:
                data = file.read()
                return True, '', data
        except Exception as e:
            return False, e.message, ''
            
        
        
        
        