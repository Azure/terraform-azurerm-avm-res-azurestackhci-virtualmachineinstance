variable "customLocationName" {
  type        = string
  description = "The name of the custom location."
}

variable "logicalNetworkName" {
  type        = string
  description = "The name of the logical network"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "vmAdminPassword" {
  type        = string
  description = "Admin password for the VM"
  sensitive   = true
}

variable "vmName" {
  type        = string
  description = "Name of the VM resource"

  validation {
    condition     = length(var.vmName) > 0
    error_message = "The vmName cannot be empty"
  }
  validation {
    condition     = length(var.vmName) <= 15
    error_message = "The vmName must be less than or equal to 15 characters"
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]*$", var.vmName))
    error_message = "The vmName must contain only alphanumeric characters and hyphens"
  }
}

variable "dataDiskParams" {
  type = list(object({
    diskSizeGB = number
    dynamic    = bool
  }))
  default     = []
  description = "The array description of the dataDisks to attach to the vm. Provide an empty array for no additional disks, or an array following the example below."
}

variable "domainJoinPassword" {
  type        = string
  default     = ""
  description = "Optional Password of User with permissions to join the domain. - Required if 'domainToJoin' is specified."
  sensitive   = true
}

variable "domainJoinUserName" {
  type        = string
  default     = ""
  description = "Optional User Name with permissions to join the domain. example: domain-joiner - Required if 'domainToJoin' is specified."
}

variable "domainTargetOu" {
  type        = string
  default     = ""
  description = "Optional domain organizational unit to join. example: ou=computers,dc=contoso,dc=com - Required if 'domainToJoin' is specified."
}

variable "domainToJoin" {
  type        = string
  default     = ""
  description = "Optional Domain name to join - specify to join the VM to domain. example: contoso.com - If left empty, ou, username and password parameters will not be evaluated in the deployment."
}

variable "downloadWinServerImage" {
  type        = bool
  default     = true
  description = "Whether to download Windows Server image"
}

variable "dynamicMemory" {
  type        = bool
  default     = false
  description = "Enable dynamic memory"
}

variable "dynamicMemoryBuffer" {
  type        = number
  default     = 20
  description = "Buffer memory in MB when dynamic memory is enabled"
}

variable "dynamicMemoryMax" {
  type        = number
  default     = 8192
  description = "Maximum memory in MB when dynamic memory is enabled"
}

variable "dynamicMemoryMin" {
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

variable "memoryMB" {
  type        = number
  default     = 8192
  description = "Memory in MB"
}

variable "privateIPAddress" {
  type        = string
  default     = ""
  description = "The private IP address of the NIC"
}

variable "vCPUCount" {
  type        = number
  default     = 2
  description = "Number of vCPUs"
}

variable "vmAdminUsername" {
  type        = string
  default     = "admin"
  description = " The admin username for the VM."
}
