#!/bin/bash
cd deploy_infrastructure

# Retrieve the ALB hostname from Terraform output
ALB_HOSTNAME=$(jq -r '.alb_hostname.value' terraform_output.json)

cd ..
# Overwrite the REACT_APP_ALB_HOSTNAME in your .env file
