
from setuptools import setup
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
    url="https://github.com/realpython/reader",
    author="Real Python",
    author_email="info@realpython.com",
    license="MIT",
    classifiers=[
        "Programming Language :: Python :: 3",
    ],
    packages=["reader"],
    include_package_data=True,
    install_requires=required,  
    entry_points={"console_scripts": ["realpython=reader.__main__:main"]},
)