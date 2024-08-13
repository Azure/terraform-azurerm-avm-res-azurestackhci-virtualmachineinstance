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
  name      = var.customLocationName
  parent_id = data.azurerm_resource_group.rg.id
}

data "azapi_resource" "winServerImage" {
  type      = "Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview"
  name      = "winServer2022-01"
  parent_id = data.azurerm_resource_group.rg.id
}

data "azapi_resource" "logicalNetwork" {
  type      = "Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview"
  name      = var.logicalNetworkName
  parent_id = data.azurerm_resource_group.rg.id
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  count               = var.downloadWinServerImage ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.rg.location
  customLocationId    = data.azapi_resource.customlocation.id
  vmName              = var.vmName
  imageId             = data.azapi_resource.winServerImage.id
  logicalNetworkId    = data.azapi_resource.logicalNetwork.id
  adminUsername       = var.vmAdminUsername
  adminPassword       = var.vmAdminPassword
  vCPUCount           = var.vCPUCount
  memoryMB            = var.memoryMB
  dynamicMemory       = var.dynamicMemory
  dynamicMemoryMax    = var.dynamicMemoryMax
  dynamicMemoryMin    = var.dynamicMemoryMin
  dynamicMemoryBuffer = var.dynamicMemoryBuffer
  dataDiskParams      = var.dataDiskParams
  privateIPAddress    = var.privateIPAddress
  domainToJoin        = var.domainToJoin
  domainTargetOu      = var.domainTargetOu
  domainJoinUserName  = var.domainJoinUserName
  domainJoinPassword  = var.domainJoinPassword
}
