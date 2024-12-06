variable "admin_password" {
  type        = string
  description = "Admin password"
  sensitive   = true

  validation {
    condition     = length(var.admin_password) > 0
    error_message = "The admin_password cannot be empty"
  }
}

variable "admin_username" {
  type        = string
  description = "Admin username"

  validation {
    condition     = length(var.admin_username) > 0
    error_message = "The admin_username cannot be empty"
  }
}

variable "custom_location_id" {
  type        = string
  description = "The custom location ID for the Azure Stack HCI cluster."
}

variable "image_id" {
  type        = string
  description = "The name of a Marketplace Gallery Image already downloaded to the Azure Stack HCI cluster. For example: winServer2022-01"
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "logical_network_id" {
  type        = string
  description = "The ID of the logical network to use for the NIC."
}

variable "name" {
  type        = string
  description = "Name of the VM resource"

  validation {
    condition     = length(var.name) > 0
    error_message = "The name cannot be empty"
  }
  validation {
    condition     = length(var.name) <= 15
    error_message = "The name must be less than or equal to 15 characters"
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]*$", var.name))
    error_message = "The name must contain only alphanumeric characters and hyphens"
  }
}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "auto_upgrade_minor_version" {
  type        = bool
  default     = true
  description = "Whether to enable auto upgrade minor version"
}

variable "data_disk_params" {
  type = map(object({
    name        = string
    diskSizeGB  = number
    dynamic     = bool
    tags        = optional(map(string))
    containerId = optional(string)
  }))
  default     = {}
  description = "The array description of the dataDisks to attach to the vm. Provide an empty array for no additional disks, or an array following the example below."
}

variable "domain_join_extension_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the domain join extension."
}

variable "domain_join_password" {
  type        = string
  default     = null
  description = "Optional Password of User with permissions to join the domain. - Required if 'domain_to_join' is specified."
  sensitive   = true
}

variable "domain_join_user_name" {
  type        = string
  default     = ""
  description = "Optional User Name with permissions to join the domain. example: domain-joiner - Required if 'domain_to_join' is specified."
}

variable "domain_target_ou" {
  type        = string
  default     = ""
  description = "Optional domain organizational unit to join. example: ou=computers,dc=contoso,dc=com - Required if 'domain_to_join' is specified."
}

variable "domain_to_join" {
  type        = string
  default     = ""
  description = "Optional Domain name to join - specify to join the VM to domain. example: contoso.com - If left empty, ou, username and password parameters will not be evaluated in the deployment."
}

variable "dynamic_memory" {
  type        = bool
  default     = true
  description = "Enable dynamic memory"
}

variable "dynamic_memory_buffer" {
  type        = number
  default     = 20
  description = "Buffer memory in MB when dynamic memory is enabled"
}

variable "dynamic_memory_max" {
  type        = number
  default     = 8192
  description = "Maximum memory in MB when dynamic memory is enabled"
}

variable "dynamic_memory_min" {
  type        = number
  default     = 512
  description = "Minimum memory in MB when dynamic memory is enabled"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "http_proxy" {
  type        = string
  default     = null
  description = "HTTP URL for proxy server. An example URL is:http://proxy.example.com:3128."
  sensitive   = true
}

variable "https_proxy" {
  type        = string
  default     = null
  description = "HTTPS URL for proxy server. The server may still use an HTTP address as shown in this example: http://proxy.example.com:3128."
  sensitive   = true
}

variable "linux_ssh_config" {
  type = object({
    publicKeys = list(object({
      keyData = string
      path    = string
    }))
  })
  default     = null
  description = "SSH configuration with public keys for linux."
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
  nullable    = false
}

variable "memory_mb" {
  type        = number
  default     = 8192
  description = "Memory in MB"
}

variable "nic_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the nic."
}

variable "no_proxy" {
  type        = list(string)
  default     = []
  description = "URLs, which can bypass proxy. Typical examples would be [localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8]"
}

variable "os_type" {
  type        = string
  default     = "Windows"
  description = "The OS type of the VM. Possible values are 'Windows' and 'Linux'."
}

variable "private_ip_address" {
  type        = string
  default     = ""
  description = "The private IP address of the NIC"
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "secure_boot_enabled" {
  type        = bool
  default     = true
  description = "Enable secure boot"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the arc vm."
}

variable "trusted_ca" {
  type        = string
  default     = null
  description = "Alternative CA cert to use for connecting to proxy servers."
}

variable "type_handler_version" {
  type        = string
  default     = "1.3"
  description = "The version of the type handler to use."
}

variable "user_storage_id" {
  type        = string
  default     = ""
  description = "The user storage ID to store images."
}

variable "v_cpu_count" {
  type        = number
  default     = 2
  description = "Number of vCPUs"
}

variable "windows_ssh_config" {
  type = object({
    publicKeys = list(object({
      keyData = string
      path    = string
    }))
  })
  default     = null
  description = "SSH configuration with public keys for windows."
}
