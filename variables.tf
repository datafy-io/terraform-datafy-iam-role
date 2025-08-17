variable "permissions_level" {
  type        = string
  default     = "AutoScaler"
  description = "Defines the level of permissions for the role (Sensor or AutoScaler)."

  validation {
    condition     = contains(["Sensor", "AutoScaler"], var.permissions_level)
    error_message = "Invalid value for permissions_level. Allowed values are 'Sensor' or 'AutoScaler'."
  }
}

variable "permissions_scope" {
  type        = string
  default     = "Global"
  description = "Use 'Global' to apply permissions across all AWS regions. Use 'Regional' to limit permissions to selected regions, which must be specified in 'Regions'."

  validation {
    condition     = contains(["Regional", "Global"], var.permissions_scope)
    error_message = "Invalid value for permissions_scope. Allowed values are 'Regional' or 'Global'."
  }
}

variable "regions" {
  type        = list(string)
  default     = []
  description = "List of AWS regions where the role should be restricted (only required if permissions_scope is 'Regional'). Example: us-east-1,us-west-2"

  validation {
    condition     = var.permissions_scope == "Regional" || length(var.regions) == 0
    error_message = "Invalid value for regions. Regions must be empty when permissions_scope is set to 'Global'."
  }

  validation {
    condition     = var.permissions_scope == "Global" || length(var.regions) != 0
    error_message = "Invalid value for regions. Regions must not be empty when permissions_scope is set to 'Regional'."
  }

  validation {
    condition = var.permissions_scope == "Global" || alltrue([
      for r in var.regions : contains(["us-east-1", "us-east-2", "us-west-1", "us-west-2", "af-south-1", "ap-east-1", "ap-south-1", "ap-south-2", "ap-southeast-1", "ap-southeast-2", "ap-southeast-3", "ap-northeast-1", "ap-northeast-2", "ap-northeast-3", "ca-central-1", "eu-central-1", "eu-central-2", "eu-west-1", "eu-west-2", "eu-west-3", "eu-north-1", "eu-south-1", "eu-south-2", "me-central-1", "me-south-1", "sa-east-1", "cn-north-1", "cn-northwest-1", "us-gov-west-1", "us-gov-east-1", "il-central-1", "es-central-1", "mx-central-1"], r)
    ])
    error_message = "Invalid value for regions."
  }
}

variable "role_name" {
  type        = string
  description = "Name of the IAM role to be created. This should be unique within the AWS account and region."
  default     = "DatafyIORole"

  validation {
    condition     = length(var.role_name) > 0
    error_message = "Role name cannot be empty."
  }
}

variable "oidc_url" {
  type        = string
  description = "OIDC URL for the IAM role. This is typically the URL of the OIDC provider that will be used to authenticate users."
  default     = "https://oidc.datafy.io"

  validation {
    condition     = can(regex("https://[a-zA-Z0-9.-]+", var.oidc_url))
    error_message = "Invalid OIDC URL format."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the created resources."
  default     = {}
}

locals {
  role_version = try(
    [
      for m in lookup(jsondecode(file("${path.root}/.terraform/modules/modules.json")), "Modules", []) :
      m.Version if try(startswith(m.Source, "registry.terraform.io/datafy-io/iam-role"), false) && can(m.Version)
    ][0],
    null
  )
}
