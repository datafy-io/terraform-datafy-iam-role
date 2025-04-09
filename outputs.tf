output "role_name" {
  value       = aws_iam_role.datafy.name
  description = "The name of IAM role for Datafy.io"
}

output "role_arn" {
  value       = aws_iam_role.datafy.arn
  description = "The ARN of IAM role for Datafy.io"
}
