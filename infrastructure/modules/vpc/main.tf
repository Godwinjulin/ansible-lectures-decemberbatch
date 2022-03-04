resource "aws_vpc" "main" {

  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = var.tags
}

//Public subnet
resource "aws_subnet" "main-public" {
  count                   = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = element(var.availability_zones, count.index)

  tags = var.tags
}

///Private Subnet
resource "aws_subnet" "main-private" {
  count             = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  vpc_id            = aws_vpc.main[0].id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = var.tags
}

resource "aws_route_table" "rtb" {

  count  = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = var.tags
}

resource "aws_internet_gateway" "igw" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.main[0].id
  tags   = var.tags
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.main-public[*].id, count.index)
  route_table_id = aws_route_table.rtb[0].id
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.main-private[*].id, count.index)
  route_table_id = aws_route_table.rtb[0].id
}
////Security group
resource "aws_security_group" "sg" {

  count       = var.create_vpc && var.security_group ? 1 : 0
  description = "Allow inbound and Outbound traffic"
  vpc_id      = aws_vpc.main[0].id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {

      cidr_blocks = lookup(ingress.value, "cidr_blocks", 0)
      description = lookup(ingress.value, "description", null)
      from_port   = lookup(ingress.value, "from_port", 0)
      to_port     = lookup(ingress.value, "to_port", 0)
      protocol    = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {

      cidr_blocks = lookup(egress.value, "cidr_blocks", 0)
      description = lookup(egress.value, "description", null)
      from_port   = lookup(egress.value, "from_port", 0)
      to_port     = lookup(egress.value, "to_port", 0)
      protocol    = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = var.tags
}