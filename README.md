<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-azurestackhci-virtualmachineinstance

Provision for AzureStackHCI virtual machine.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azapi_resource.data_disks](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.domain_join](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.hybrid_compute_machine](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.nic](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.virtual_machine](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password)

Description: Admin password

Type: `string`

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: Admin username

Type: `string`

### <a name="input_custom_location_id"></a> [custom\_location\_id](#input\_custom\_location\_id)

Description: The custom location ID for the Azure Stack HCI cluster.

Type: `string`

### <a name="input_image_id"></a> [image\_id](#input\_image\_id)

Description: The name of a Marketplace Gallery Image already downloaded to the Azure Stack HCI cluster. For example: winServer2022-01

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_logical_network_id"></a> [logical\_network\_id](#input\_logical\_network\_id)

Description: The ID of the logical network to use for the NIC.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the VM resource

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_auto_upgrade_minor_version"></a> [auto\_upgrade\_minor\_version](#input\_auto\_upgrade\_minor\_version)

Description: Whether to enable auto upgrade minor version

Type: `bool`

Default: `true`

### <a name="input_data_disk_params"></a> [data\_disk\_params](#input\_data\_disk\_params)

Description: The array description of the dataDisks to attach to the vm. Provide an empty array for no additional disks, or an array following the example below.

Type:

```hcl
map(object({
    name        = string
    diskSizeGB  = number
    dynamic     = bool
    tags        = optional(map(string))
    containerId = optional(string)
  }))
```

Default: `{}`

### <a name="input_domain_join_extension_tags"></a> [domain\_join\_extension\_tags](#input\_domain\_join\_extension\_tags)

Description: (Optional) Tags of the domain join extension.

Type: `map(string)`

Default: `null`

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

### <a name="input_http_proxy"></a> [http\_proxy](#input\_http\_proxy)

Description: HTTP URL for proxy server. An example URL is:http://proxy.example.com:3128.

Type: `string`

Default: `null`

### <a name="input_https_proxy"></a> [https\_proxy](#input\_https\_proxy)

Description: HTTPS URL for proxy server. The server may still use an HTTP address as shown in this example: http://proxy.example.com:3128.

Type: `string`

Default: `null`

### <a name="input_linux_ssh_config"></a> [linux\_ssh\_config](#input\_linux\_ssh\_config)

Description: SSH configuration with public keys for linux.

Type:

```hcl
object({
    publicKeys = list(object({
      keyData = string
      path    = string
    }))
  })
```

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description: Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb)

Description: Memory in MB

Type: `number`

Default: `8192`

### <a name="input_nic_tags"></a> [nic\_tags](#input\_nic\_tags)

Description: (Optional) Tags of the nic.

Type: `map(string)`

Default: `null`

### <a name="input_no_proxy"></a> [no\_proxy](#input\_no\_proxy)

Description: URLs, which can bypass proxy. Typical examples would be [localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8]

Type: `list(string)`

Default: `[]`

### <a name="input_os_type"></a> [os\_type](#input\_os\_type)

Description: The OS type of the VM. Possible values are 'Windows' and 'Linux'.

Type: `string`

Default: `"Windows"`

### <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address)

Description: The private IP address of the NIC

Type: `string`

Default: `""`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_secure_boot_enabled"></a> [secure\_boot\_enabled](#input\_secure\_boot\_enabled)

Description: Enable secure boot

Type: `bool`

Default: `true`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the arc vm.

Type: `map(string)`

Default: `null`

### <a name="input_trusted_ca"></a> [trusted\_ca](#input\_trusted\_ca)

Description: Alternative CA cert to use for connecting to proxy servers.

Type: `string`

Default: `null`

### <a name="input_type_handler_version"></a> [type\_handler\_version](#input\_type\_handler\_version)

Description: The version of the type handler to use.

Type: `string`

Default: `"1.3"`

### <a name="input_user_storage_id"></a> [user\_storage\_id](#input\_user\_storage\_id)

Description: The user storage ID to store images.

Type: `string`

Default: `""`

### <a name="input_v_cpu_count"></a> [v\_cpu\_count](#input\_v\_cpu\_count)

Description: Number of vCPUs

Type: `number`

Default: `2`

### <a name="input_windows_ssh_config"></a> [windows\_ssh\_config](#input\_windows\_ssh\_config)

Description: SSH configuration with public keys for windows.

Type:

```hcl
object({
    publicKeys = list(object({
      keyData = string
      path    = string
    }))
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: This is the full output for the resource.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->