
resource "aws_iam_role" "ecr_role" {
  name = "${var.ecr_prefix}-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags

}

resource "aws_iam_role_policy" "ecr_iam_role_policy" {
  name        = "${var.ecr_prefix}EcsEcrAccess"
  role        = aws_iam_role.ecr_role.id
  policy      = file("${path.module}/policy.json")
}

output "ecr_iam_policy_id" {
  description = "Policy ID"
  value       = aws_iam_role_policy.ecr_iam_role_policy.id
}
