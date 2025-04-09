terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.83"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "datafy_role" {
  source  = "datafy-io/iam-role/datafy"
  version = "~> 1.0"

  permissions_level = "AutoScaler"
  permissions_scope = "Global"
}

output "datafy_role_name" {
  value = module.datafy_role.role_name
}

output "datafy_role_arn" {
  value = module.datafy_role.role_arn
}
