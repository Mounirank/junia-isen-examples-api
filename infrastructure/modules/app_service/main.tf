# modules/app_service/main.tf
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-plan"
  resource_group_name = var.resource_group_name
  location           = var.location
  os_type            = "Linux"
  sku_name           = "B1"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_linux_web_app" "main" {
  name                = "${var.project_name}-app"
  resource_group_name = var.resource_group_name
  location           = var.location
  service_plan_id    = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image     = "ghcr.io/fhuitelec/junia-isen-examples-api:latest"
      docker_registry_url = "https://ghcr.io"
    }

    always_on = true
    
    application_insights_enabled = true
    
    health_check_path = "/"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITES_PORT"        = "80"
    "DATABASE_HOST"        = var.database_host
    "DATABASE_PORT"        = "5432"
    "DATABASE_NAME"        = var.database_name
    "DATABASE_USER"        = var.database_user
    "DATABASE_PASSWORD"    = var.database_password
    "STORAGE_ACCOUNT_URL"  = var.storage_account_url
    
    # FastAPI settings
    "PYTHONPATH"          = "/app"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    
    # Docker settings
    "DOCKER_REGISTRY_SERVER_URL" = "https://ghcr.io"
    "DOCKER_ENABLE_CI"          = "true"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}