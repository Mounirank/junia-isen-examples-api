resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location           = var.location
  environment        = var.environment
  project_name       = var.project_name
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location           = var.location
  environment        = var.environment
  project_name       = var.project_name
}

module "database" {
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.main.name
  location           = var.location
  environment        = var.environment
  project_name       = var.project_name
  
  database_subnet_id   = module.network.database_subnet_id
  private_dns_zone_id  = module.network.private_dns_zone_id
  
  postgres_username    = var.postgres_username
  postgres_password    = var.postgres_password
}
