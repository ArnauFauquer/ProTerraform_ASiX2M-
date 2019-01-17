resource "aws_route_table" "aws_pub_rt" {
  vpc_id = "${aws_vpc.aws_vpc_pro.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.aws_pro_gateway.id}"
  }
  tags {
    Name = "Public Subnet"
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = "${aws_internet_gateway.aws_pro_gateway.id}"
  }
  tags {
    Name = "Public Subnet v6"
  }
}

resource "aws_route_table_association" "aws_routet_pub" {
  count = "${aws_subnet.aws_subnet_pub.count}"

  subnet_id      = "${aws_subnet.aws_subnet_pub.*.id[count.index]}"
  route_table_id = "${aws_route_table.aws_pub_rt.id}"
}


resource "aws_route_table" "aws_priv_rt" {
  vpc_id = "${aws_vpc.aws_vpc_pro.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.aws_pro_app.*.id[count.index]}"
  }
  tags {
    Name = "Public Subnet"
  }
  route {
    ipv6_cidr_block = "::/0"
    instance_id = "${aws_instance.aws_pro_nat.*.id[count.index]}"
  }
  tags {
    Name = "Public Subnet v6"
  }
}

resource "aws_route_table_association" "aws_route_priv" {
  count = "${aws_subnet.aws_subnet_prib.count}"

  subnet_id      = "${aws_subnet.aws_subnet_prib.*.id[count.index]}"
  route_table_id = "${aws_route_table.aws_priv_rt.id}"
}