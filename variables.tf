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

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations
variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = <<DESCRIPTION
A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.
DESCRIPTION  
}

variable "data_disk_params" {
  type = list(object({
    diskSizeGB = number
    dynamic    = bool
  }))
  default     = []
  description = "The array description of the dataDisks to attach to the vm. Provide an empty array for no additional disks, or an array following the example below."
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
  default     = false
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

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
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
