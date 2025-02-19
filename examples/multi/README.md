<!-- BEGIN_TF_DOCS -->
# Multiple VM provisioning example

This deploys multiple VMs each with different image.

```hcl
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azapi_resource.customlocation](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azapi_resource.logical_network](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azapi_resource.vm_image](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_custom_location_name"></a> [custom\_location\_name](#input\_custom\_location\_name)

Description: Enter the custom location name of your HCI cluster.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_vm_admin_password"></a> [vm\_admin\_password](#input\_vm\_admin\_password)

Description: Admin password for the VM

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_data_disk_params"></a> [data\_disk\_params](#input\_data\_disk\_params)

Description: The array description of the dataDisks to attach to the vm. Provide an empty array for no additional disks, or an array following the example below.

Type:

```hcl
map(object({
    name       = string
    diskSizeGB = number
    dynamic    = bool
  }))
```

Default: `{}`

### <a name="input_domain_join_password"></a> [domain\_join\_password](#input\_domain\_join\_password)

Description: Optional Password of User with permissions to join the domain. - Required if 'domain\_to\_join' is specified.

Type: `string`

Default: `null`

### <a name="input_domain_join_user_name"></a> [domain\_join\_user\_name](#input\_domain\_join\_user\_name)

Description: Optional User Name with permissions to join the domain. example: domain-joiner - Required if 'domain\_to\_join' is specified.

Type: `string`

Default: `""`

### <a name="input_domain_target_ou"></a> [domain\_target\_ou](#input\_domain\_target\_ou)

Description: Optional domain organizational unit to join. example: ou=computers,dc=contoso,dc=com - Required if 'domain\_to\_join' is specified.

Type: `string`

Default: `""`

### <a name="input_domain_to_join"></a> [domain\_to\_join](#input\_domain\_to\_join)

Description: Optional Domain name to join - specify to join the VM to domain. example: contoso.com - If left empty, ou, username and password parameters will not be evaluated in the deployment.

Type: `string`

Default: `""`

### <a name="input_dynamic_memory"></a> [dynamic\_memory](#input\_dynamic\_memory)

Description: Enable dynamic memory

Type: `bool`

Default: `true`

### <a name="input_dynamic_memory_buffer"></a> [dynamic\_memory\_buffer](#input\_dynamic\_memory\_buffer)

Description: Buffer memory in MB when dynamic memory is enabled

Type: `number`

Default: `20`

### <a name="input_dynamic_memory_max"></a> [dynamic\_memory\_max](#input\_dynamic\_memory\_max)

Description: Maximum memory in MB when dynamic memory is enabled

Type: `number`

Default: `8192`

### <a name="input_dynamic_memory_min"></a> [dynamic\_memory\_min](#input\_dynamic\_memory\_min)

Description: Minimum memory in MB when dynamic memory is enabled

Type: `number`

Default: `512`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb)

Description: Memory in MB

Type: `number`

Default: `8192`

### <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address)

Description: The private IP address of the NIC

Type: `string`

Default: `""`

### <a name="input_v_cpu_count"></a> [v\_cpu\_count](#input\_v\_cpu\_count)

Description: Number of vCPUs

Type: `number`

Default: `2`

### <a name="input_vm_admin_username"></a> [vm\_admin\_username](#input\_vm\_admin\_username)

Description:  The admin username for the VM.

Type: `string`

Default: `"admin"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_test"></a> [test](#module\_test)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->