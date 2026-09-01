output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}