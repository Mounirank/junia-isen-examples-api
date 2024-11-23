output "server_name" {
  description = "The name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "database_name" {
  description = "The name of the database"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

output "server_fqdn" {
  description = "The fully qualified domain name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "connection_string" {
  description = "The connection string for the database"
  value       = "postgres://${var.postgres_username}:${var.postgres_password}@${azurerm_postgresql_flexible_server.main.fqdn}/${azurerm_postgresql_flexible_server_database.main.name}"
  sensitive   = true
}
