output "role_arn" {
  value       = aws_iam_role.datafy.arn
  description = "The ARN of IAM role for Datafy.io"
}
