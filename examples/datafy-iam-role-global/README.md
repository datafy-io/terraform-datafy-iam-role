# Datafy Role of AutoScaler with Global permissions

This example demonstrates how to create a Datafy IAM Role with AutoScaler permissions and a global scope using Terraform.

## Prerequisites

Ensure you have the following installed and configured:

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.2
- AWS CLI with appropriate credentials configured
- Access to the `datafy-io/datafy` Terraform module

## Usage

The Terraform configuration for this example is located in the `main.tf` file. Below is a summary of the configuration:

- **Permissions Level**: `AutoScaler`
- **Permissions Scope**: `Global`

### Steps to Deploy

1. **Initialize Terraform**  
   Run the following command to initialize the Terraform working directory:
    ```bash
    terraform init
    ```

2. **Validate the Configuration**  
   Validate the configuration to ensure there are no syntax errors:
    ```bash
    terraform validate
    ```

3. **Apply the Configuration**  
   Deploy the resources by running:
    ```bash
    terraform apply --auto-approve
    ```

4. **View Outputs**  
   After the deployment, you can view the outputs for the role name and ARN:
    ```bash
    terraform output
    ```

**Outputs**

* **Role Name**: The name of the created IAM role.
* **Role ARN**: The Amazon Resource Name (ARN) of the created IAM role.

### Clean-Up
To remove the resources created by this example, run:
```bash
terraform destroy --auto-approve
```

### Example Configuration
Below is the Terraform configuration used in this example:

```hcl
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

```

### Notes
* Ensure that the AWS account has sufficient permissions to create IAM roles.
* Be sure to clean up resources when they are no longer needed.
