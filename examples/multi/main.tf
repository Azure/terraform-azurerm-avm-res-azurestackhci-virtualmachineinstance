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

locals {
  virtual_machines = {
    vm1 = {
      is_marketplace_image = true                               # Set to true if the referenced image is from Azure Marketplace.
      image_name           = "2022-datacenter-azure-edition-01" # Enter the name of the image you would like to use for the VM deployment.
      logical_network_name = "lnetstatic"                       # Enter the name of the logical network you would like to use for the VM deployment.
    }
    vm2 = {
      is_marketplace_image = true
      image_name           = "win10-22h2-ent-g2-01"
      logical_network_name = "lnetstatic"
    }
  }
}

# This is required for resource modules
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azapi_resource" "customlocation" {
  name      = var.custom_location_name
  parent_id = data.azurerm_resource_group.rg.id
  type      = "Microsoft.ExtendedLocation/customLocations@2021-08-15"
}

data "azapi_resource" "vm_image" {
  for_each = local.virtual_machines

  name      = each.value.image_name
  parent_id = data.azurerm_resource_group.rg.id
  type      = each.value.is_marketplace_image ? "Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview" : "Microsoft.AzureStackHCI/galleryImages@2023-09-01-preview"
}

data "azapi_resource" "logical_network" {
  for_each = local.virtual_machines

  name      = each.value.logical_network_name
  parent_id = data.azurerm_resource_group.rg.id
  type      = "Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview"
}


# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source   = "../../"
  for_each = local.virtual_machines

  admin_password        = var.vm_admin_password
  admin_username        = var.vm_admin_username
  custom_location_id    = data.azapi_resource.customlocation.id
  image_id              = data.azapi_resource.vm_image[each.key].id
  location              = data.azurerm_resource_group.rg.location
  logical_network_id    = data.azapi_resource.logical_network[each.key].id
  name                  = each.key
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
