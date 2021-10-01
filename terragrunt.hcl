locals {
    environment_config = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
    environment = local.environment_config.locals.environment
    terraform_token   = get_env("TERRAFORM_WORKSPACE_TOKEN")
}


generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "remote" {
  hostname = "app.terraform.io"
  organization = "cloud-native-skunkworks"
  token =  "${local.terraform_token}"
    workspaces {
      name = "cloud-native-skunkworks-${local.environment}"
    }
  }
}
EOF
}
