resource "aws_internet_gateway" "ssr_web_app" {
  vpc_id = aws_vpc.main.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-igw"
  }
}

# resource "aws_nat_gateway" "ssr_web_app" {
#   allocation_id = aws_eip.nat_gw.id
#   subnet_id     = aws_subnet.public_subnet["a"].id

#   tags = {
#     Env     = var.env
#     Project = var.project
#     Name    = "${var.env}-${var.project}-ngw"
#   }
# }
