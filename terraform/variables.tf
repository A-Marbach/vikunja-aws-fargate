variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "vikunja-fargate"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "vikunja"
}

variable "db_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}


variable "vikunja_service_secret" {
  description = "Vikunja service secret"
  type        = string
  sensitive   = true
}