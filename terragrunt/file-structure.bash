#!/bin/bash -x
# File structure:
# terragrunt/
# ├── environments/
# │   └── dev/
# │       └── s3/
# │           └── terragrunt.hcl
# └── modules/
#     └── s3/
#         └── main.tf
#         └── variables.tf
#         └── outputs.tf
mkdir environments
mkdir modules
mkdir environments/dev
mkdir environments/dev/s3
touch environments/dev/s3/terragrunt.hcl

mkdir modules/s3
touch modules/s3/main.tf
touch modules/s3/variables.tf
touch modules/s3/outputs.tf
