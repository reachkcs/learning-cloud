terraform {
  source = "../../../modules/s3"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  bucket_name = "my-dev-bucket-kcs"
  environment = "dev"
  region      = "us-east-1"
}