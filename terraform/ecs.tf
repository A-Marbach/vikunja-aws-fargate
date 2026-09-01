resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name    = "${var.project_name}-cluster"
    Project = var.project_name
  }
}

resource "aws_ecs_task_definition" "vikunja" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "vikunja"
      image     = "vikunja/vikunja:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3456
          hostPort      = 3456
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "VIKUNJA_DATABASE_TYPE"
          value = "postgres"
        },
        {
          name  = "VIKUNJA_DATABASE_HOST"
          value = aws_db_instance.main.address
        },
        {
          name  = "VIKUNJA_DATABASE_USER"
          value = var.db_username
        },
        {
          name  = "VIKUNJA_DATABASE_DATABASE"
          value = "vikunja"
        },
        {
          name  = "VIKUNJA_DATABASE_SSLMODE"
          value = "require"
        },
        {
          name  = "VIKUNJA_SERVICE_PUBLICURL"
          value = "http://${aws_lb.main.dns_name}/"
        },
        {
          name  = "VIKUNJA_FILES_TYPE"
          value = "s3"
        },
        {
          name  = "VIKUNJA_FILES_S3_ENDPOINT"
          value = "https://s3.${var.aws_region}.amazonaws.com"
        },
        {
          name  = "VIKUNJA_FILES_S3_BUCKET"
          value = aws_s3_bucket.vikunja_files.bucket
        },
        {
          name  = "VIKUNJA_FILES_S3_REGION"
          value = var.aws_region
        },
        {
          name  = "VIKUNJA_FILES_S3_ACCESSKEY"
          value = aws_iam_access_key.vikunja_s3.id
        },


      ]

      secrets = [
        {
          name      = "VIKUNJA_DATABASE_PASSWORD"
          valueFrom = aws_secretsmanager_secret.db_password.arn
        },
        {
          name      = "VIKUNJA_SERVICE_SECRET"
          valueFrom = aws_secretsmanager_secret.vikunja_service_secret.arn
        },

        {
          name      = "VIKUNJA_FILES_S3_SECRETKEY"
          valueFrom = aws_secretsmanager_secret.s3_secret_key.arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "vikunja"
        }
      }
    }
  ])

  tags = {
    Name    = "${var.project_name}-task"
    Project = var.project_name
  }
}

resource "aws_ecs_service" "vikunja" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.vikunja.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.vikunja.arn
    container_name   = "vikunja"
    container_port   = 3456
  }

  depends_on = [
    aws_lb_listener.http
  ]

  tags = {
    Name    = "${var.project_name}-service"
    Project = var.project_name
  }
}