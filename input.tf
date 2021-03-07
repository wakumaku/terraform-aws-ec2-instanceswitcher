variable "prefix" {
  description = "Prefix to be used when creating resources"
  type        = string
}

variable "instance_list" {
  description = "Instance(s) to be switched started, stopped, rebooted or terminated"
  type        = list(string)
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

variable "tags" {
  description = "Custom tags to be added to the created resources"
  type        = map(string)
  default     = {}
}
