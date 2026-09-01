resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_secrets" {
  name = "${var.project_name}-ecs-secrets-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = [
          aws_secretsmanager_secret.db_password.arn,
          aws_secretsmanager_secret.vikunja_service_secret.arn,
          aws_secretsmanager_secret.s3_secret_key.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_secrets" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_secrets.arn
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "vikunja_s3" {
  name = "${var.project_name}-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.vikunja_files.arn,
          "${aws_s3_bucket.vikunja_files.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vikunja_s3" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.vikunja_s3.arn
}

resource "aws_iam_user" "vikunja_s3" {
  name = "${var.project_name}-s3-user"
}

resource "aws_iam_user_policy" "vikunja_s3" {
  name = "${var.project_name}-s3-user-policy"
  user = aws_iam_user.vikunja_s3.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.vikunja_files.arn,
          "${aws_s3_bucket.vikunja_files.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_access_key" "vikunja_s3" {
  user = aws_iam_user.vikunja_s3.name
}