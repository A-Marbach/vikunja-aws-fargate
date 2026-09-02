resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project_name}/db-password"

  tags = {
    Name    = "${var.project_name}-db-password"
    Project = var.project_name
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_secretsmanager_secret" "vikunja_service_secret" {
  name = "${var.project_name}/service-secret"

  tags = {
    Name    = "${var.project_name}-service-secret"
    Project = var.project_name
  }
}

resource "aws_secretsmanager_secret_version" "vikunja_service_secret" {
  secret_id     = aws_secretsmanager_secret.vikunja_service_secret.id
  secret_string = var.vikunja_service_secret
}

resource "aws_secretsmanager_secret" "s3_secret_key" {
  name = "${var.project_name}/s3-secret-key"
}

resource "aws_secretsmanager_secret_version" "s3_secret_key" {
  secret_id     = aws_secretsmanager_secret.s3_secret_key.id
  secret_string = aws_iam_access_key.vikunja_s3.secret
}