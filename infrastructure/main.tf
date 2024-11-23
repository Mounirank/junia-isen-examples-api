terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "7bee3ef3-fd9c-42a5-9cf6-2dd862e6f821"
}

resource "azurerm_resource_group" "main" {
  name     = "junia-isen-api-rg"  
  location = "francecentral"
  tags = {
    Environment = "dev"
    Project     = "junia-isen-api"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "junia-isen-api-vnet"
  address_space       = ["10.0.0.0/16"]
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = "dev"
    Project     = "junia-isen-api"
  }
}

# Subnet pour App Service
resource "azurerm_subnet" "app_service" {
  name                 = "app-service-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}


# Subnet pour PostgreSQL
resource "azurerm_subnet" "database" {
  name                 = "database-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
  
  delegation {
    name = "fs-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Zone DNS privée pour PostgreSQL
resource "azurerm_private_dns_zone" "database" {  # Cette ressource est nommée "database"
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = "junia-isen-api-rg"

  depends_on = [
    azurerm_resource_group.main
  ]
  
  tags = {
    Environment = "dev"
    Project     = "junia-isen-api"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.database.name  # Changé "postgres" en "database"
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  depends_on = [
    azurerm_private_dns_zone.database,
    azurerm_virtual_network.main
  ]
}

# Storage Account pour Blob Storage
resource "azurerm_storage_account" "main" {
  name                     = "juniaisenapisa"
  resource_group_name      = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
  
  # Suppression temporaire des network_rules
  # network_rules {
  #   default_action             = "Deny"
  #   virtual_network_subnet_ids = [azurerm_subnet.app_service.id]
  #   bypass                     = ["AzureServices"]
  # }

  tags = {
    Environment = "dev"
    Project     = "junia-isen-api"
  }
}

# Container Blob
resource "azurerm_storage_container" "content" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}


# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "junia-isen-api-plan"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  os_type            = "Linux"
  sku_name           = "B1"

  tags = {
    Environment = "dev"
    Project     = "junia-isen-api"
  }
}

# App Service
resource "azurerm_linux_web_app" "main" {
  name                = "junia-isen-api-app"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  service_plan_id    = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image_name        = "nginx:latest"
      docker_registry_url      = "https://index.docker.io"
    }
  }
  app_settings = {
    "WEBSITES_PORT"                 = "8080"
    "STORAGE_ACCOUNT_NAME"          = azurerm_storage_account.main.name
    "STORAGE_ACCOUNT_KEY"           = azurerm_storage_account.main.primary_access_key
    "DATABASE_URL"                  = "postgres://nkayere:Mounira18@${azurerm_private_dns_zone.database.name}/juniadb"
  }

  tags = {
    Environment = "dev"
    Project     = "junia-isen-api"
  }
}