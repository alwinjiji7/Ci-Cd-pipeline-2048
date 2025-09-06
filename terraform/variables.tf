variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "2048-game"
}

variable "environment" {
  description = "Environment (dev, prod, etc)"
  type        = string
  default     = "dev"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "2048-game-repo"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "2048-cluster"
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "2048-service"
}

variable "app_port" {
  description = "Port the app runs on"
  type        = number
  default     = 80
}