data "aws_availability_zones" "this" {}

resource "aws_vpc" "this" {
  cidr_block = local.cidr_block

  tags = merge(local.tags, {
    Name = "${var.region}-vpc"
  })
}

resource "aws_subnet" "public" {
  for_each = toset(local.public_subnet_ranges)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.key
  availability_zone       = data.aws_availability_zones.this.names[index(local.public_subnet_ranges, each.key)]
  map_public_ip_on_launch = true
  tags = merge(local.tags, {
    Name = "public-${index(local.public_subnet_ranges, each.key)}"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "igw"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, {
    Name = "private"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.tags, {
    Name = "public"
  })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

resource "aws_security_group" "ec2" {
  name        = "ec2 sg"
  description = "EC2 SG"

  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 51820
    protocol    = "UDP"
    to_port     = 51820
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "ec2"
  })
}
