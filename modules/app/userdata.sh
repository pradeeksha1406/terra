#!/bin/bash

dnf install python3.12-pip -y | tee -a /opt/userdata.log
pip3.12 install boto3 botocore | tee -a /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/pradeeksha1406/Revise-infra-ansible.git main.yml -e role_name=${role_name} -e env={{env}} | tee -a /opt/userdata.log


