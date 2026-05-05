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
  profile = "development"
}

module "datafy_role" {
  source  = "../../"
  # version = "~> 1.0"

  account_id        = "123e4567-e89b-12d3-a456-426614174000"
  permissions_level = "AutoScaler"
  permissions_scope = "Global"
}

output "datafy_role_arn" {
  value = module.datafy_role.role_arn
}
