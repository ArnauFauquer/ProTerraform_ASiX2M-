resource "aws_security_group" "aws_nat" {
  name = "vpc_nat"
  description = "Allow traffic to pass from the private subnet to the internet"
  vpc_id      = "${aws_vpc.aws_vpc_pro.id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${var.ip_stucom}"]
  }

  tags {
    Name = "AWS_NAT_SG"
  }
}

resource "aws_security_group_rule" "app-internet" {
  count = "${aws_subnet.aws_subnet_prib.count}"
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.aws_nat.id}"
  to_port = 0
  cidr_blocks = ["${aws_subnet.aws_subnet_prib.*.cidr_block[count.index]}"]
  ipv6_cidr_blocks = ["${aws_subnet.aws_subnet_prib.*.ipv6_cidr_block[count.index]}"]
  type = "ingress"
}

resource "aws_security_group" "aws_app" {
  name = "aws_app"
  description = "aws app inbound traffic"
  vpc_id = "${aws_vpc.aws_vpc_pro.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [
      "${var.cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = [
      "::/0"]
  }
}