# =================================================================
# public
# =================================================================
resource "aws_route_table" "public" {
  for_each = var.public_subnet
  vpc_id = aws_vpc.ssr_web_app.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-public-rt-${each.value["az"]}"
    AZ      = "${each.value["az"]}"
  }
}

resource "aws_route" "public_internet_gateway" {
  for_each = var.public_subnet

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ssr_web_app.id
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnet

  route_table_id = aws_route_table.public[each.key].id
  subnet_id      = aws_subnet.public_subnet[each.key].id
}

# =================================================================
# private
# =================================================================
resource "aws_route_table" "private" {
  for_each = var.private_subnet
  vpc_id = aws_vpc.ssr_web_app.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-private-rt-${each.value["az"]}"
    AZ      = "${each.value["az"]}"
  }
}

resource "aws_route" "private_nat_gateway" {
  for_each = var.private_subnet

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ssr_web_app.id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet

  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = aws_subnet.private_subnet[each.key].id
}
