output "storage_account" {
  description = "The storage account details"
  value = {
    name                = azurerm_storage_account.main.name
    primary_access_key  = azurerm_storage_account.main.primary_access_key
  }
  sensitive = true
}

output "content_container_name" {
  description = "The name of the content container"
  value       = azurerm_storage_container.content.name
}