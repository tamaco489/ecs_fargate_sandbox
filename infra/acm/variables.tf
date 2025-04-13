# =================================================================
# general
# =================================================================
variable "env" {
  description = "The environment in which the acm will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project in which the acm will be created"
  type        = string
  default     = "ssr-web-app"
}

locals {
  fqn = "${var.env}-${var.project}"
}
