# =================================================================
# general
# =================================================================
variable "env" {
  description = "The environment in which the frontend service will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project in which the frontend service will be created"
  type        = string
  default     = "ssr-web-app"
}

variable "region" {
  description = "The region in which the frontend service will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.project}"
}
