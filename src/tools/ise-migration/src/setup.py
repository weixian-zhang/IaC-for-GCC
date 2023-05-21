
from setuptools import setup, find_packages
import os 

reqTxtPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'requirements.txt')
with open(reqTxtPath) as f:
    required = f.read().splitlines()
    
setup(
    name="deploy-ise-exported-workflows",
    version="1.0.0",
    description="Read the latest Real Python tutorials",
    long_description="",
    long_description_content_type="text/markdown",
    url="https://github.com/weixian-zhang/IaC-for-GCC",
    author="weixian",
    author_email="",
    license="MIT",
    classifiers=[
        "Programming Language :: Python :: 3",
    ],
    packages=find_packages(),
    include_package_data=True,
    install_requires=required,  
    entry_points={"console_scripts": ["iseworkflowdeploy=iseworkflowdeploy.main:main"]},
)