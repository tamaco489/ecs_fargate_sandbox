data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-ssr-web-application-tfstate"
    key    = "network/terraform.tfstate"
  }
}
