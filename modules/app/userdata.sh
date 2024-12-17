#!/bin/bash

#dnf install python3.11-pip -y
#pip3.11 install boto3 botocore

sudo dnf install nginx | tee -a /opt/userdata.log
sudo systemctl enable nginx | tee -a /opt/userdata.log
sudo systemctl start nginx | tee -a /opt/userdata.log
