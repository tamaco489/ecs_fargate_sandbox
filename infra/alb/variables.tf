# =================================================================
# general
# =================================================================
variable "env" {
  description = "The environment in which the alb will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project in which the alb will be created"
  type        = string
  default     = "ssr-web-application"
}

variable "region" {
  description = "The region in which the alb will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.project}"
}
