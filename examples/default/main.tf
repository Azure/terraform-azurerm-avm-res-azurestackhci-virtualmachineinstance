terraform {
  required_version = "~> 1.5"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }
}

provider "azurerm" {
  features {}
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "~> 0.1"
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
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

data "azapi_resource" "win_server_image" {
  type      = "Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview"
  name      = "winServer2022-01"
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
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  count                 = var.download_win_server_image ? 1 : 0
  resource_group_name   = var.resource_group_name
  location              = data.azurerm_resource_group.rg.location
  custom_location_id    = data.azapi_resource.customlocation.id
  name                  = var.name
  image_id              = data.azapi_resource.win_server_image.id
  logical_network_id    = data.azapi_resource.logical_network.id
  admin_username        = var.vm_admin_username
  admin_password        = var.vm_admin_password
  v_cpu_count           = var.v_cpu_count
  memory_mb             = var.memory_mb
  dynamic_memory        = var.dynamic_memory
  dynamic_memory_max    = var.dynamic_memory_max
  dynamic_memory_min    = var.dynamic_memory_min
  dynamic_memory_buffer = var.dynamic_memory_buffer
  data_disk_params      = var.data_disk_params
  private_ip_address    = var.private_ip_address
  domain_to_join        = var.domain_to_join
  domain_target_ou      = var.domain_target_ou
  domain_join_user_name = var.domain_join_user_name
  domain_join_password  = var.domain_join_password
}
