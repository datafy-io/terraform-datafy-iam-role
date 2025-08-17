resource "aws_iam_openid_connect_provider" "datafy" {
  url = var.oidc_url
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280",
  ]
  tags = var.tags
}

resource "aws_iam_role" "datafy" {
  name        = var.role_name
  description = "Service Role for Datafy.io"
  tags        = var.tags

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "OIDC",
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.datafy.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${trimprefix(var.oidc_url, "https://")}:aud" = "sts.amazonaws.com",
            "${trimprefix(var.oidc_url, "https://")}:sub" = "datafy.io"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "datafy" {
  name = "DatafyIOPolicy"
  role = aws_iam_role.datafy.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeRegions",
        ],
        "Resource" : "*",
        "Condition" = var.permissions_scope == "Regional" ? {
          "StringEquals" = {
            "aws:RequestedRegion" = var.regions
          }
        } : {}
      },
      {
        "Effect" : var.permissions_level == "Sensor" ? "Deny" : "Allow",
        "Action" : [
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:DeleteVolume",
          "ec2:DeleteSnapshot",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateSnapshots",
          "ebs:StartSnapshot",
        ],
        "Resource" : "*",
        "Condition" = var.permissions_scope == "Regional" ? {
          "StringEquals" = {
            "aws:RequestedRegion" = var.regions
          }
        } : {}
      },
      {
        "Effect" : var.permissions_level == "Sensor" ? "Deny" : "Allow",
        "Action" : [
          "ebs:PutSnapshotBlock",
          "ebs:CompleteSnapshot",
          "ebs:ListSnapshotBlocks",
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : merge(
            var.permissions_scope == "Regional" ? {
              "aws:RequestedRegion" : var.regions
            } : {},
            {
              "aws:ResourceTag/Managed-By" : "Datafy.io"
            }
          )
        }
      },
      {
        "Effect" : var.permissions_level == "Sensor" ? "Deny" : "Allow",
        "Action" : [
          "ec2:CreateTags"
        ],
        "Resource" : [
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:snapshot/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "ec2:CreateAction" : [
              "CreateVolume",
              "CreateSnapshot",
              "CreateSnapshots",
            ]
          }
        }
      },
      {
        "Effect" : var.permissions_level == "Sensor" ? "Deny" : "Allow",
        "Action" : [
          "ec2:CreateTags"
        ],
        "Resource" : [
          "arn:aws:ec2:*:*:snapshot/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestTag/Managed-By" : "Datafy.io"
          }
        }
      },
      {
        "Effect" : var.permissions_level == "Sensor" ? "Deny" : "Allow",
        "Action" : [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ],
        "Resource" : [
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:snapshot/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/Managed-By" : "Datafy.io"
          }
        }
      },
    ]
  })
}

resource "aws_ssm_parameter" "datafy_version" {
  name        = "/datafy/role/version"
  type        = "String"
  value       = local.role_version != null ? local.role_version : ""
  description = "Datafy.io AWS Role version"
}

resource "aws_iam_role_policy" "datafy_validation" {
  name = "DatafyIOValidationPolicy"
  role = aws_iam_role.datafy.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter"
        ],
        "Resource" : aws_ssm_parameter.datafy_version.arn,
      },
      {
        "Effect" : "Allow"
        "Action" : [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:SimulatePrincipalPolicy",
          "iam:GetContextKeysForPrincipalPolicy",
        ],
        "Resource" : aws_iam_role.datafy.arn,
      },
    ]
  })
}
