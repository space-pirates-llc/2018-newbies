variable "teams" {
  type = "list"

  default = [
    "squirrel",
    "panda",
    "rabbit",
  ]
}

# VPC

resource "aws_vpc" "training-field" {
  count                            = "${length(var.teams)}"
  cidr_block                       = "${cidrsubnet("10.0.0.0/8", 8, count.index)}"
  assign_generated_ipv6_cidr_block = true

  tags {
    Name = "${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "training-field" {
  count  = "${length(var.teams)}"
  vpc_id = "${element(aws_vpc.training-field.*.id, count.index)}"

  tags {
    Name = "igw-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_egress_only_internet_gateway" "training-field" {
  count  = "${length(var.teams)}"
  vpc_id = "${element(aws_vpc.training-field.*.id, count.index)}"
}

# NAT

resource "aws_eip" "training-field" {
  count = "${length(var.teams)}"
  vpc   = true

  tags {
    Target = "NAT"
    Name   = "nat-${element(var.teams, count.index)}"
    Team   = "${element(var.teams, count.index)}"
  }
}

resource "aws_nat_gateway" "training-field" {
  count         = "${length(var.teams)}"
  allocation_id = "${element(aws_eip.training-field.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.training-field-public-a.*.id, count.index)}"
  depends_on    = ["aws_eip.training-field", "aws_subnet.training-field-public-a"]

  tags {
    Name = "nat-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

# Subnet

resource "aws_subnet" "training-field-public-a" {
  count                           = "${length(var.teams)}"
  vpc_id                          = "${element(aws_vpc.training-field.*.id, count.index)}"
  cidr_block                      = "${cidrsubnet(element(aws_vpc.training-field.*.cidr_block, count.index), 8, 0)}"
  ipv6_cidr_block                 = "${cidrsubnet(element(aws_vpc.training-field.*.ipv6_cidr_block, count.index), 8, 0)}"
  availability_zone               = "ap-northeast-1a"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags {
    Name = "tf-public-a-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_subnet" "training-field-public-c" {
  count                           = "${length(var.teams)}"
  vpc_id                          = "${element(aws_vpc.training-field.*.id, count.index)}"
  cidr_block                      = "${cidrsubnet(element(aws_vpc.training-field.*.cidr_block, count.index), 8, 1)}"
  ipv6_cidr_block                 = "${cidrsubnet(element(aws_vpc.training-field.*.ipv6_cidr_block, count.index), 8, 1)}"
  availability_zone               = "ap-northeast-1c"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags {
    Name = "tf-public-c-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_subnet" "training-field-public-d" {
  count                           = "${length(var.teams)}"
  vpc_id                          = "${element(aws_vpc.training-field.*.id, count.index)}"
  cidr_block                      = "${cidrsubnet(element(aws_vpc.training-field.*.cidr_block, count.index), 8, 2)}"
  ipv6_cidr_block                 = "${cidrsubnet(element(aws_vpc.training-field.*.ipv6_cidr_block, count.index), 8, 2)}"
  availability_zone               = "ap-northeast-1d"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags {
    Name = "tf-public-d-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_subnet" "training-field-private-a" {
  count                           = "${length(var.teams)}"
  vpc_id                          = "${element(aws_vpc.training-field.*.id, count.index)}"
  cidr_block                      = "${cidrsubnet(element(aws_vpc.training-field.*.cidr_block, count.index), 8, 3)}"
  ipv6_cidr_block                 = "${cidrsubnet(element(aws_vpc.training-field.*.ipv6_cidr_block, count.index), 8, 3)}"
  availability_zone               = "ap-northeast-1a"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags {
    Name = "tf-private-a-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_subnet" "training-field-private-c" {
  count                           = "${length(var.teams)}"
  vpc_id                          = "${element(aws_vpc.training-field.*.id, count.index)}"
  cidr_block                      = "${cidrsubnet(element(aws_vpc.training-field.*.cidr_block, count.index), 8, 4)}"
  ipv6_cidr_block                 = "${cidrsubnet(element(aws_vpc.training-field.*.ipv6_cidr_block, count.index), 8, 4)}"
  availability_zone               = "ap-northeast-1c"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags {
    Name = "tf-private-c-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_subnet" "training-field-private-d" {
  count                           = "${length(var.teams)}"
  vpc_id                          = "${element(aws_vpc.training-field.*.id, count.index)}"
  cidr_block                      = "${cidrsubnet(element(aws_vpc.training-field.*.cidr_block, count.index), 8, 5)}"
  ipv6_cidr_block                 = "${cidrsubnet(element(aws_vpc.training-field.*.ipv6_cidr_block, count.index), 8, 5)}"
  availability_zone               = "ap-northeast-1d"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags {
    Name = "tf-private-d-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

# Routes Table

resource "aws_route_table" "training-field-public" {
  count  = "${length(var.teams)}"
  vpc_id = "${element(aws_vpc.training-field.*.id, count.index)}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_internet_gateway.training-field.*.id, count.index)}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${element(aws_egress_only_internet_gateway.training-field.*.id, count.index)}"
  }

  tags {
    Name = "tf-public-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }

  depends_on = ["aws_internet_gateway.training-field"]
}

resource "aws_route_table_association" "training-field-public-a" {
  count          = "${length(var.teams)}"
  subnet_id      = "${element(aws_subnet.training-field-public-a.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.training-field-public.*.id, count.index)}"
}

resource "aws_route_table_association" "training-field-public-c" {
  count          = "${length(var.teams)}"
  subnet_id      = "${element(aws_subnet.training-field-public-c.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.training-field-public.*.id, count.index)}"
}

resource "aws_route_table_association" "training-field-public-d" {
  count          = "${length(var.teams)}"
  subnet_id      = "${element(aws_subnet.training-field-public-d.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.training-field-public.*.id, count.index)}"
}

resource "aws_default_route_table" "training-field-private" {
  count                  = "${length(var.teams)}"
  default_route_table_id = "${element(aws_vpc.training-field.*.default_route_table_id, count.index)}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.training-field.*.id, count.index)}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${element(aws_egress_only_internet_gateway.training-field.*.id, count.index)}"
  }

  tags {
    Name = "tf-private-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }

  depends_on = ["aws_nat_gateway.training-field"]
}

resource "aws_route_table_association" "training-field-private-a" {
  count          = "${length(var.teams)}"
  subnet_id      = "${element(aws_subnet.training-field-private-a.*.id, count.index)}"
  route_table_id = "${element(aws_default_route_table.training-field-private.*.id, count.index)}"
}

resource "aws_route_table_association" "training-field-private-c" {
  count          = "${length(var.teams)}"
  subnet_id      = "${element(aws_subnet.training-field-private-c.*.id, count.index)}"
  route_table_id = "${element(aws_default_route_table.training-field-private.*.id, count.index)}"
}

resource "aws_route_table_association" "training-field-private-d" {
  count          = "${length(var.teams)}"
  subnet_id      = "${element(aws_subnet.training-field-private-d.*.id, count.index)}"
  route_table_id = "${element(aws_default_route_table.training-field-private.*.id, count.index)}"
}

# ACL

resource "aws_network_acl" "training-field-public" {
  count  = "${length(var.teams)}"
  vpc_id = "${element(aws_vpc.training-field.*.id, count.index)}"

  depends_on = [
    "aws_subnet.training-field-public-a",
    "aws_subnet.training-field-public-c",
    "aws_subnet.training-field-public-d",
  ]

  subnet_ids = [
    "${element(aws_subnet.training-field-public-a.*.id, count.index)}",
    "${element(aws_subnet.training-field-public-c.*.id, count.index)}",
    "${element(aws_subnet.training-field-public-d.*.id, count.index)}",
  ]

  ingress {
    action     = "allow"
    rule_no    = 100
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action          = "allow"
    rule_no         = 101
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
  }

  egress {
    action     = "allow"
    rule_no    = 100
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action          = "allow"
    rule_no         = 101
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
  }

  tags {
    Name = "training-field-public"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_default_network_acl" "training-field-private" {
  count                  = "${length(var.teams)}"
  default_network_acl_id = "${element(aws_vpc.training-field.*.default_network_acl_id, count.index)}"

  depends_on = [
    "aws_subnet.training-field-private-a",
    "aws_subnet.training-field-private-c",
    "aws_subnet.training-field-private-d",
  ]

  subnet_ids = [
    "${element(aws_subnet.training-field-private-a.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-c.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-d.*.id, count.index)}",
  ]

  ingress {
    action     = "allow"
    rule_no    = 100
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action          = "allow"
    rule_no         = 101
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
  }

  egress {
    action     = "allow"
    rule_no    = 100
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action          = "allow"
    rule_no         = 101
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
  }

  tags {
    Name = "training-field-private"
    Team = "${element(var.teams, count.index)}"
  }
}

# Security Group

resource "aws_security_group" "training-field-public" {
  count      = "${length(var.teams)}"
  depends_on = ["aws_vpc.training-field"]
  vpc_id     = "${element(aws_vpc.training-field.*.id, count.index)}"

  name = "training-field-public"

  tags {
    Name = "training-field-public"
    Team = "${element(var.teams, count.index)}"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_default_security_group" "training-field-private" {
  count      = "${length(var.teams)}"
  depends_on = ["aws_vpc.training-field"]
  vpc_id     = "${element(aws_vpc.training-field.*.id, count.index)}"

  tags {
    Name = "training-field-private"
    Team = "${element(var.teams, count.index)}"
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${element(aws_security_group.training-field-public.*.id, count.index)}"]
    self            = true
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${element(aws_vpc.training-field.*.cidr_block, count.index)}"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["${element(aws_vpc.training-field.*.ipv6_cidr_block, count.index)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}
