#!/bin/bash -x
tofu init
tofu validate
tofu plan -var-file="terraform.tfvars"
tofu apply -var-file="terraform.tfvars" -auto-approve
tofu destroy -var-file="terraform.tfvars" -auto-approve

