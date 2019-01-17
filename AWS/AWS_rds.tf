resource "aws_db_instance" "tranxfer_db" {
  allocated_storage    = 20
  storage_type         = "standard"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.medium"
  name                 = "mydb"
  username             = "${var.mysql-login}"
  password             = "${var.mysql-passwd}"
  parameter_group_name = "tranxfer-mysql-dev"
  db_subnet_group_name = "${aws_db_subnet_group.tranxfer_db.name}"
  vpc_security_group_ids = ["${aws_security_group.tranxfer_db.id}"]
  deletion_protection  = true
  publicly_accessible  = true

  tags {
    Name = "atlasian"
  }

}
resource "aws_db_subnet_group" "tranxfer_db"  {
  name = "tranxfer_db"
  // remove aws_subnet.tranxfer_public when finish migrating?
  subnet_ids = [
    "${aws_subnet.tranxfer_private.*.id}", "${aws_subnet.tranxfer_public.*.id}"]
}

resource "aws_security_group" "tranxfer_db" {
  name        = "tranxfer_db"
  description = "tranxfer_db"
  vpc_id      = "${aws_vpc.tranxfer_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${aws_instance.tranxfer_atlassian.private_ip}/32"]
    ipv6_cidr_blocks = ["${aws_instance.tranxfer_atlassian.ipv6_addresses[0]}/128"]
  }

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = ["${aws_security_group.tranxfer-node.id}"]
    description     = "Allow pods to communicate with the DB"
  }

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = ["${aws_security_group.tranxfer_nat.id}"]
    description     = "Allow nats to communicate with the DB for temporary tunneling from Hetzner"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${var.ip-necsia}"]
  }

  tags {
    Name = "tranxfer_db"
  }
}