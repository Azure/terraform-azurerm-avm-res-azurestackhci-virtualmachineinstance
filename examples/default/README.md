<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

```hcl
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.13)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.74)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

## Resources

The following resources are used by this module:

- [azapi_resource.customlocation](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azapi_resource.logicalNetwork](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azapi_resource.winServerImage](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_customLocationName"></a> [customLocationName](#input\_customLocationName)

Description: The name of the custom location.

Type: `string`

### <a name="input_logicalNetworkName"></a> [logicalNetworkName](#input\_logicalNetworkName)

Description: The name of the logical network

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_vmAdminPassword"></a> [vmAdminPassword](#input\_vmAdminPassword)

Description: Admin password for the VM

Type: `string`

### <a name="input_vmName"></a> [vmName](#input\_vmName)

Description: Name of the VM resource

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_dataDiskParams"></a> [dataDiskParams](#input\_dataDiskParams)

Description: The array description of the dataDisks to attach to the vm. Provide an empty array for no additional disks, or an array following the example below.

Type:

```hcl
list(object({
    diskSizeGB = number
    dynamic    = bool
  }))
```

Default: `[]`

### <a name="input_domainJoinPassword"></a> [domainJoinPassword](#input\_domainJoinPassword)

Description: Optional Password of User with permissions to join the domain. - Required if 'domainToJoin' is specified.

Type: `string`

Default: `""`

### <a name="input_domainJoinUserName"></a> [domainJoinUserName](#input\_domainJoinUserName)

Description: Optional User Name with permissions to join the domain. example: domain-joiner - Required if 'domainToJoin' is specified.

Type: `string`

Default: `""`

### <a name="input_domainTargetOu"></a> [domainTargetOu](#input\_domainTargetOu)

Description: Optional domain organizational unit to join. example: ou=computers,dc=contoso,dc=com - Required if 'domainToJoin' is specified.

Type: `string`

Default: `""`

### <a name="input_domainToJoin"></a> [domainToJoin](#input\_domainToJoin)

Description: Optional Domain name to join - specify to join the VM to domain. example: contoso.com - If left empty, ou, username and password parameters will not be evaluated in the deployment.

Type: `string`

Default: `""`

### <a name="input_downloadWinServerImage"></a> [downloadWinServerImage](#input\_downloadWinServerImage)

Description: Whether to download Windows Server image

Type: `bool`

Default: `true`

### <a name="input_dynamicMemory"></a> [dynamicMemory](#input\_dynamicMemory)

Description: Enable dynamic memory

Type: `bool`

Default: `false`

### <a name="input_dynamicMemoryBuffer"></a> [dynamicMemoryBuffer](#input\_dynamicMemoryBuffer)

Description: Buffer memory in MB when dynamic memory is enabled

Type: `number`

Default: `20`

### <a name="input_dynamicMemoryMax"></a> [dynamicMemoryMax](#input\_dynamicMemoryMax)

Description: Maximum memory in MB when dynamic memory is enabled

Type: `number`

Default: `8192`

### <a name="input_dynamicMemoryMin"></a> [dynamicMemoryMin](#input\_dynamicMemoryMin)

Description: Minimum memory in MB when dynamic memory is enabled

Type: `number`

Default: `512`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_memoryMB"></a> [memoryMB](#input\_memoryMB)

Description: Memory in MB

Type: `number`

Default: `8192`

### <a name="input_privateIPAddress"></a> [privateIPAddress](#input\_privateIPAddress)

Description: The private IP address of the NIC

Type: `string`

Default: `""`

### <a name="input_vCPUCount"></a> [vCPUCount](#input\_vCPUCount)

Description: Number of vCPUs

Type: `number`

Default: `2`

### <a name="input_vmAdminUsername"></a> [vmAdminUsername](#input\_vmAdminUsername)

Description:  The admin username for the VM.

Type: `string`

Default: `"admin"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: ~> 0.3

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/avm-utl-regions/azurerm

Version: ~> 0.1

### <a name="module_test"></a> [test](#module\_test)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->