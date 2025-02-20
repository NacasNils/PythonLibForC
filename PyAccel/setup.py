from setuptools import setup, find_packages
import codecs
import os


VERSION = '0.0.1'
DESCRIPTION = 'Streaming video data via networks'

# Setting up
setup(
    name="PyAccel",
    version=VERSION,
    author="Nils Lyrevik",
    author_email="guslyrni@student.gu.se",
    description=DESCRIPTION,
    packages=find_packages(),
    install_requires=['numpy'],
    keywords=['python', 'c-code', 'c', 'cuda', 'Nvidia', 'GPU'],
    classifiers=[
        "Development Status :: 1 - Planning",
        "Intended Audience :: Developers",
        "Programming Language :: Python :: 3",
        "Operating System :: Unix",
        "Operating System :: MacOS :: MacOS X",
        "Operating System :: Microsoft :: Windows",
    ]
)
