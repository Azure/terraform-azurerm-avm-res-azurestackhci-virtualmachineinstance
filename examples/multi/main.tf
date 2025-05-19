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
  type      = "Microsoft.ExtendedLocation/customLocations@2021-08-15"
  name      = var.custom_location_name
  parent_id = data.azurerm_resource_group.rg.id
}

data "azapi_resource" "vm_image" {
  for_each = local.virtual_machines

  type      = each.value.is_marketplace_image ? "Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview" : "Microsoft.AzureStackHCI/galleryImages@2023-09-01-preview"
  name      = each.value.image_name
  parent_id = data.azurerm_resource_group.rg.id
}

data "azapi_resource" "logical_network" {
  for_each = local.virtual_machines

  type      = "Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview"
  name      = each.value.logical_network_name
  parent_id = data.azurerm_resource_group.rg.id
}


# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"
  # source             = "Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm"
  # version            = "~>0.0"

  for_each = local.virtual_machines

  enable_telemetry    = var.enable_telemetry
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.rg.location
  custom_location_id  = data.azapi_resource.customlocation.id
  name                = each.key
  image_id            = data.azapi_resource.vm_image[each.key].id
  logical_network_id  = data.azapi_resource.logical_network[each.key].id

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


  # # Optional block to configure a proxy server for your VM
  # http_proxy = "http://username:password@proxyserver.contoso.com:3128"
  # https_proxy = "https://username:password@proxyserver.contoso.com:3128"
  # no_proxy = [
  #     "localhost",
  #     "127.0.0.1"
  # ]
  # trusted_ca = "-----BEGIN CERTIFICATE-----....-----END CERTIFICATE-----"

}
