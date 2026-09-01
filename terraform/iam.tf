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
          aws_secretsmanager_secret.vikunja_service_secret.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_secrets" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_secrets.arn
}