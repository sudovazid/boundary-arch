#!/bin/bash
echo "Running Terraform backend"
cd boundary-backend-tf
terraform destroy -auto-approve