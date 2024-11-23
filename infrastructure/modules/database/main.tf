# modules/database/main.tf
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "${var.project_name}-psql"
  resource_group_name = var.resource_group_name
  location            = var.location
  
  delegated_subnet_id = var.database_subnet_id
  private_dns_zone_id = var.private_dns_zone_id
  
  administrator_login    = var.postgres_username
  administrator_password = var.postgres_password

  sku_name = "B_Standard_B1ms"
  version  = "13"
  
  storage_mb = 32768

  backup_retention_days = 7

  public_network_access_enabled = false

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "juniadb"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}