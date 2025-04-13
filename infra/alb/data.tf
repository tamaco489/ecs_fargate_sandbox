data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-ssr-web-application-tfstate"
    key    = "network/terraform.tfstate"
  }
}

data "terraform_remote_state" "route53" {
  backend = "s3"
  config = {
    bucket = "${var.env}-ssr-web-application-tfstate"
    key    = "route53/terraform.tfstate"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "${var.env}-ssr-web-application-tfstate"
    key    = "acm/terraform.tfstate"
  }
}
