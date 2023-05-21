
from setuptools import setup, find_packages
import os 

reqTxtPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'src', 'requirements.txt')
with open(reqTxtPath) as f:
    required = f.read().splitlines()

currentDir = os.path.join(os.path.dirname(os.path.realpath(__file__)))
    
setup(
    name="deploy-ise-exported-workflows",
    version="0.10.0",
    url="https://github.com/weixian-zhang/IaC-for-GCC",
    author="",
    author_email="",
    license="MIT",
    packages=find_packages(
    exclude=[
        "exported-ise",
        "build",
        "dist",
        ".git",
        ".gitignore",
        "Fuzzie.egg-info",
        "README.md"
        ]
       
    ),  #same as name
    install_requires=required
)