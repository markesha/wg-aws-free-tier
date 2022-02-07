resource "aws_iam_role" "this" {
  name = "SessionManagerPermissions"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  inline_policy {
    name = "s3"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "s3access",
          "Effect" : "Allow",
          "Action" : [
            "s3:*"
          ],
          "Resource" : [
            "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
            "arn:aws:s3:::${aws_s3_bucket.this.bucket}"
          ]
        }
      ]
    })
  }
  inline_policy {
    name = "ssm"

    policy = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "ssm:UpdateInstanceInformation",
              "ssmmessages:CreateControlChannel",
              "ssmmessages:CreateDataChannel",
              "ssmmessages:OpenControlChannel",
              "ssmmessages:OpenDataChannel"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "s3:GetEncryptionConfiguration"
            ],
            "Resource" : "*"
          }
        ]
      }
    )
  }
  tags = local.tags
}

resource "aws_iam_instance_profile" "this" {
  name = "ssm"
  role = aws_iam_role.this.name
}
