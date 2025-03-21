terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.24.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 3.22.0"
    }
  }
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}

data "azurerm_dashboard_grafana" "main" {
  name                = var.grafana_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "grafana" {
  resource_group_name = var.resource_group_name
  name                = var.grafana_managed_identity
}

provider "grafana" {
  url  = data.azurerm_dashboard_grafana.main.endpoint
  auth = var.grafana_auth
}
