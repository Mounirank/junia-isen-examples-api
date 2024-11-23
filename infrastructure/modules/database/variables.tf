# modules/database/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "database_subnet_id" {
  description = "ID of the subnet for the database"
  type        = string
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone"
  type        = string
}

variable "postgres_username" {
  description = "PostgreSQL admin username"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}