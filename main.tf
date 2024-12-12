provider "azurerm" {
  # resource_provider_registrations = "none"
  skip_provider_registration = true
  subscription_id                 = var.ARM_SUBSCRIPTION_ID
  client_id                       = var.ARM_CLIENT_ID
  tenant_id                       = var.ARM_TENANT_ID
  client_secret                   = var.ARM_CLIENT_SECRET
  features {
  }
}

locals {
  env_name = "ramon"
}
               
data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "lab_we" {
  name = var.RESOURCE_GROUP_NAME
}

data "azurerm_storage_account" "sa" {
  name                = var.STORAGE_ACCOUNT_NAME
  resource_group_name = data.azurerm_resource_group.lab_we.name
}


resource "azurerm_service_plan" "getting_started" {
  name                = "tfdp-getting-started-${local.env_name}"
  resource_group_name = data.azurerm_resource_group.lab_we.name
  location            = data.azurerm_resource_group.lab_we.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "getting_started" {
  name                = "tfdp-getting-started-${local.env_name}"
  resource_group_name = data.azurerm_resource_group.lab_we.name
  location            = data.azurerm_resource_group.lab_we.location
  service_plan_id     = azurerm_service_plan.getting_started.id

  site_config {
    application_stack {
      docker_image_name   = "nginx:1.25"
      docker_registry_url = "https://index.docker.io"
    }
  }

  storage_account {
    account_name = data.azurerm_storage_account.sa.name
    access_key   = data.azurerm_storage_account.sa.primary_access_key
    type         = "AzureFiles"
    share_name   = data.azurerm_storage_account.sa.name
    mount_path   = "/usr/share/nginx/html"
    name         = "nginx_files"
  }
}