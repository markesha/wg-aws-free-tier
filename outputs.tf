output "cli" {
  value = var.state == "on" ? "aws --profile ${var.profile} s3 cp s3://${aws_s3_bucket.this.bucket}/config.yaml config.yaml && cat config.yaml" : null
}
