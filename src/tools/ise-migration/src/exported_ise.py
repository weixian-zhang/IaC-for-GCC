
import os
from termcolor import colored

class WorkflowInfo:
    def __init__(self, dirName, dirPath, fullWorkflowFilePath) -> None:
        self.dirName = dirName
        self.dirPath = dirPath
        self.fullWorkflowFilePath = fullWorkflowFilePath
        
class ExportedISEProject:
    
    def __init__(self, iseExportedDir:str) -> None:
                
        self.hostJson = 'host.json'
        self.connectionsFileName= 'connections.json'
        self.parametersFileName = 'parameters.json'
        self.workflowFileName = 'workflow.json'
        
        self.dir_to_ignore = ['.development', '.logs','.vscode']
        self.files_to_ignore = ['.funcignore','.gitignore', 'host.json', 'local.settings.json']
    
        self.iseExportedDir = iseExportedDir
        self.workflowDirs = {}
        self.hostJsonPath = ''
        self.connectionsFileNamePath = ''
        self.parametersFileNamePath = ''
        
    def load(self):
        
        allDirs = os.listdir(self.iseExportedDir)
        
        # set parameters.json path
        paramPath = os.path.join(self.iseExportedDir, self.parametersFileName)
        if os.path.exists(paramPath):
            self.parametersFileNamePath = paramPath
            
        connsPath = os.path.join(self.iseExportedDir, self.connectionsFileName)
        if os.path.exists(connsPath):
            self.connectionsFileNamePath = connsPath
        
        for dir in allDirs:
            
            if dir == self.connectionsFileName:
                self.connectionsFileNamePath = os.path.join(self.iseExportedDir, dir)
                continue
            
            if dir == self.parametersFileName:
                self.parametersFileNamePath = os.path.join(self.iseExportedDir, dir)
                continue
            
            if dir in self.dir_to_ignore or dir in self.files_to_ignore:
                continue
            
            
            
            dirNameOnly = dir
            wrkfDir = os.path.join(self.iseExportedDir, dir)
            
            if os.path.isdir(wrkfDir):
                wrkfFile = os.path.join(self.iseExportedDir, dir, self.workflowFileName)
                self.workflowDirs[dirNameOnly] = WorkflowInfo(dirNameOnly, wrkfDir, wrkfFile)
            
                print(colored(f'workflow detected at ${wrkfDir}', 'green'))
            
        