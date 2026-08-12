# Datafy AWS IAM Role Terraform Module

> **⚠️ DEPRECATED — This module is no longer maintained.**
>
> We moved to a new module repo: [datafy-io/modules/aws](https://registry.terraform.io/modules/datafy-io/modules/aws/latest).  
> This specific module was moved to the [`iam-role` submodule](https://registry.terraform.io/modules/datafy-io/modules/aws/latest/submodules/iam-role) — use it instead:
>
> ```hcl
> module "datafy_role" {
>   source  = "datafy-io/modules/aws//modules/iam-role"
>   version = "~> 1.0"
> }
> ```
>
> No further updates, bug fixes, or releases will be published here.

This Terraform module creates AWS IAM Role resources for Datafy with customizable permissions and scopes.

## Examples
For detailed usage please refer to examples
