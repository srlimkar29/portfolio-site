terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  # shortcut: local state, applied by hand once. Move to HCP Terraform (free)
  # and apply from the pipeline when more than this one resource is managed.
}

# Subscription comes from the ARM_SUBSCRIPTION_ID environment variable.
provider "azurerm" {
  features {}
}

variable "name" {
  description = "Name of the Static Web App"
  type        = string
  default     = "swa-portfolio"
}

variable "location" {
  description = "Azure region (Static Web Apps supports only a few)"
  type        = string
  default     = "westeurope"
}

resource "azurerm_resource_group" "site" {
  name     = "rg-portfolio"
  location = var.location
}

resource "azurerm_static_web_app" "site" {
  name                = var.name
  resource_group_name = azurerm_resource_group.site.name
  location            = azurerm_resource_group.site.location
  sku_tier            = "Free"
  sku_size            = "Free"
}

output "site_url" {
  value = "https://${azurerm_static_web_app.site.default_host_name}"
}

output "deploy_token" {
  value     = azurerm_static_web_app.site.api_key
  sensitive = true
}
