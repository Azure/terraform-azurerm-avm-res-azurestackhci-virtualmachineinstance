variable "custom_location_name" {
  type        = string
  description = "Enter the custom location name of your HCI cluster."
}

variable "image_name" {
  type        = string
  description = "Enter the name of the image you would like to use for the VM deployment"
}

variable "logical_network_name" {
  type        = string
  description = "Enter the name of the logical network you would like to use for the VM deployment"
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

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "vm_admin_password" {
  type        = string
  description = "Admin password for the VM"
  sensitive   = true
}

variable "data_disk_params" {
  type = map(object({
    name       = string
    diskSizeGB = number
    dynamic    = bool
  }))
  default     = {}
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
}

variable "is_marketplace_image" {
  type        = bool
  default     = true
  description = "Set to true if the referenced image is from Azure Marketplace."
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

variable "v_cpu_count" {
  type        = number
  default     = 2
  description = "Number of vCPUs"
}

variable "vm_admin_username" {
  type        = string
  default     = "admin"
  description = " The admin username for the VM."
}
