# =================================================================
# general
# =================================================================
variable "env" {
  description = "The environment in which the route53 will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project in which the route53 will be created"
  type        = string
  default     = "ssr-web-app"
}

variable "region" {
  description = "The region in which the route53 will be created"
  type        = string
  default     = "ap-northeast-1"
}

variable "domain" {
  description = "The domain name"
  type        = string
  default     = "example.com"
}

locals {
  fqn = "${var.env}-${var.project}"
}
