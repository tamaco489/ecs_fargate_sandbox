resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.public_subnet
  cidr_block              = each.value["cidr"]
  availability_zone       = "${var.region}${each.value["az"]}"
  map_public_ip_on_launch = true

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-public-subnet-${each.value["az"]}"
    AZ      = "${each.value["az"]}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.private_subnet
  cidr_block              = each.value["cidr"]
  availability_zone       = "${var.region}${each.value["az"]}"
  map_public_ip_on_launch = false

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-private-subnet-${each.value["az"]}"
    AZ      = "${each.value["az"]}"
  }
}
