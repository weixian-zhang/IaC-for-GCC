
import os
from termcolor import colored

class WorkflowDir:
    def __init__(self, dirName, fullFilePath) -> None:
        self.dirName = dirName
        self.fullFilePath = fullFilePath
        
class ExportedISE:
    
    def __init__(self, iseExportedDir:str) -> None:
                
        self.hostJson = 'host.json'
        self.connectionsJson= 'connections.json'
        self.parametersJson= 'parameters.json'
        self.workflowFileName = 'workflow.json'
        
        self.dir_to_ignore = ['.development', '.logs','.vscode']
        self.files_to_ignore = ['.funcignore','.gitignore']
    
        self.iseExportedDir = iseExportedDir
        self.workflowDirs: list[WorkflowDir] = []
        self.hostJsonPath = ''
        self.connectionsJsonPath = ''
        self.parametersJsonPath = ''
        
    def load(self):
        
        allDirs = os.listdir(self.iseExportedDir)
        
        for dir in allDirs:
            
            if dir == self.connectionsJson:
                self.connectionsJsonPath = os.path.join(self.iseExportedDir, dir)
                continue
            
            if dir == self.parametersJson:
                self.parametersJsonPath = os.path.join(self.iseExportedDir, dir)
                continue
            
            if dir == self.hostJson:
                self.hostJsonPath = os.path.join(self.iseExportedDir, dir)
                continue
            
            if dir in self.dir_to_ignore or dir in self.files_to_ignore:
                continue
            
            wrkfDir = os.path.join(self.iseExportedDir, dir)
            wrkfFile = os.path.join(self.iseExportedDir, dir, self.workflowFileName)
            self.workflowDirs.append(WorkflowDir(wrkfDir, wrkfFile))
            
            print(colored(f'workflow detected at ${wrkfDir}', 'green'))
            
        