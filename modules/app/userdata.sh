#!/bin/bash

#dnf install python3.11-pip -y
#pip3.11 install boto3 botocore

sudo dnf install nginx
sudo systemctl enable nginx
sudo systemctl start nginx
