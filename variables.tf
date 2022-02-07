variable "region" {
  description = "Region"
  default     = "eu-west-1"
}

variable "state" {
  description = "State of the WG server"
  default     = "off"
  validation {
    condition     = contains(["on", "off"], var.state)
    error_message = "Server state can be 'off' or 'on'."
  }
}

variable "profile" {
  description = "awscli profile name"
  default     = "personal"
}
