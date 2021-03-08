variable "prefix" {
  description = "Prefix to be used when creating resources"
  type        = string
}

variable "instance_list" {
  description = "Instance(s) to be switched started, stopped, rebooted or terminated"
  type        = list(string)
  default     = []
}

variable "schedules" {
  description = "Schedules when the actions over the instance(s)"
  type = object({
    start     = list(string)
    stop      = list(string)
    reboot    = list(string)
    terminate = list(string)
    switch    = list(string)
  })
  default = {
    start     = []
    stop      = []
    reboot    = []
    terminate = []
    switch    = []
  }
}

variable "role_permissions_boundary" {
  type        = string
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  default     = null
}

variable "role_path" {
  type        = string
  description = "Path to the role."
  default     = "/"
}

variable "policies_path" {
  type        = string
  description = "Path in which to create the policy."
  default     = "/"
}

variable "tags" {
  description = "Custom tags to be added to the created resources"
  type        = map(string)
  default     = {}
}
