
from loguru import logger
from termcolor import colored
import sys

class Logger:
    
    _instance = None
    
    # singleton
    def __new__(class_, *args, **kwargs):
        if not isinstance(class_._instance, class_):
            class_._instance = object.__new__(class_, *args, **kwargs)
            logger.add("ise-workflow-migrate_{time}.log")
        return class_._instance
    
    def __init__(self) -> None:
        pass
        
        
    def success(self, log: str):
        logger.success(log)
        #print(colored(log, 'green'))
        
    def info(self, log: str):
        logger.info(log)
        #print(colored(log, 'blue'))
        
    def warn(self, err: str):
        logger.warning(err)
        #print(colored(err, 'yellow'))
        
    def error(self, err: Exception):
        errMsg = str(err)
        logger.error(errMsg)
        #print(colored(errMsg, 'red'))
        
    def breakline(self,noOfBreaks = 1):
        if noOfBreaks > 1:
            for x in range(noOfBreaks - 1):
                logger.warning('\n')
        else:
            logger.warning('\n')
        
    