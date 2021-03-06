resource "aws_db_instance" "aws_mysql_app" {
  allocated_storage    = 20
  engine               = "mysql"
  identifier = "aws-mysql-app"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "wordpress"
  username             = "${var.mysql-login}"
  password             = "${var.mysql-passwd}"
  db_subnet_group_name = "${aws_db_subnet_group.aws_db_subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.aws_db.id}"]
  deletion_protection  = false

  tags {
    Name = "AWS_mysql_app"
  }

}
resource "aws_db_subnet_group" "aws_db_subnet"  {
  name = "tranxfer_db"
  // remove aws_subnet.tranxfer_public when finish migrating?
  subnet_ids = [
    "${aws_subnet.aws_subnet_prib.*.id}", "${aws_subnet.aws_subnet_pub.*.id}"]
}

resource "aws_security_group" "aws_db" {
  name        = "aws_db"
  description = "aws_db"
  vpc_id      = "${aws_vpc.aws_vpc_pro.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags {
    Name = "aws_db"
  }
}

resource "aws_security_group_rule" "aws-sgr-bd_app" {
  from_port = 3306
  protocol = "TCP"
  security_group_id = "${aws_security_group.aws_db.id}"
  cidr_blocks = ["${aws_instance.aws_pro_app.*.private_ip[count.index]}/32"]
  to_port = 3306
  type = "ingress"
}
resource "aws_security_group_rule" "aws-sgr-bd_nat" {
  from_port = 3306
  protocol = "TCP"
  security_group_id = "${aws_security_group.aws_db.id}"
  cidr_blocks = ["${aws_instance.aws_pro_nat.*.private_ip[count.index]}/32"]
  to_port = 3306
  type = "ingress"
}