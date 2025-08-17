output "role_name" {
  value       = aws_iam_role.datafy.name
  description = "The name of IAM role for Datafy.io"
}

output "role_arn" {
  value       = aws_iam_role.datafy.arn
  description = "The ARN of IAM role for Datafy.io"
}

output "ssm_parameter_arn" {
  description = "ARN of the SSM parameter for Datafy.io"
  value       = aws_ssm_parameter.datafy_version.arn
}
