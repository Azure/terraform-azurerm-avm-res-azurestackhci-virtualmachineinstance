terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "0000000-0000-00000-000000"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# This is required for resource modules
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azapi_resource" "customlocation" {
  type      = "Microsoft.ExtendedLocation/customLocations@2021-08-15"
  name      = var.custom_location_name
  parent_id = data.azurerm_resource_group.rg.id
}

data "azapi_resource" "vm_image" {
  type      = var.is_marketplace_image ? "Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview" : "Microsoft.AzureStackHCI/galleryImages@2023-09-01-preview"
  name      = var.image_name
  parent_id = data.azurerm_resource_group.rg.id
}

data "azapi_resource" "logical_network" {
  type      = "Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview"
  name      = var.logical_network_name
  parent_id = data.azurerm_resource_group.rg.id
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"

  admin_password        = var.vm_admin_password
  admin_username        = var.vm_admin_username
  custom_location_id    = data.azapi_resource.customlocation.id
  image_id              = data.azapi_resource.vm_image.id
  location              = data.azurerm_resource_group.rg.location
  logical_network_id    = data.azapi_resource.logical_network.id
  name                  = var.name
  resource_group_name   = var.resource_group_name
  data_disk_params      = var.data_disk_params
  domain_join_password  = var.domain_join_password
  domain_join_user_name = var.domain_join_user_name
  domain_target_ou      = var.domain_target_ou
  domain_to_join        = var.domain_to_join
  dynamic_memory        = var.dynamic_memory
  dynamic_memory_buffer = var.dynamic_memory_buffer
  dynamic_memory_max    = var.dynamic_memory_max
  dynamic_memory_min    = var.dynamic_memory_min
  enable_telemetry      = var.enable_telemetry
  memory_mb             = var.memory_mb
  private_ip_address    = var.private_ip_address
  v_cpu_count           = var.v_cpu_count
}
