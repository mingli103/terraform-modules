variable "additional_tag_map" {
  type    = map(string)
  default = {}
}

variable "app_name" {
  type        = string
  description = "What app is this resource for"
  default     = ""
}

variable "service_name" {
  type        = string
  description = "What service is this resource for"
  default     = ""
}

variable "environment_name" {
  type        = string
  description = "What environment is this resource in"
}

variable "team_name" {
  type        = string
  description = "What team owns this resource"
  default     = ""
}
