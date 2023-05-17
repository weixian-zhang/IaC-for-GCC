from azure.storage.fileshare import ShareServiceClient
import yaml

from config import Config, load_config
from exported_ise import ExportedISE
from termcolor import colored

fileshare_client = None
config = Config()
exportedISE = None



    #fileshare_client = ShareServiceClient(account_url="https://<my_account_name>.file.core.windows.net", credential=)


def main():
    
    config = load_config()
    
    if config is None:
        print(colored('config.yaml failed to load due to missing values or invalid schema', 'red'))
        return
    
    exportedISE = ExportedISE(config.exported_ise_directory)
    
    exportedISE.load()
    
    pass


if __name__ == '__main__':
    main()
    
    
    
    
    

        
    
