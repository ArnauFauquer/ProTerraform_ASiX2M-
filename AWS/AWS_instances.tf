resource "aws_instance" "aws_pro_nat" {
  count = "${aws_subnet.aws_subnet_pub.count}"
  ami = "${data.aws_ami.nat.id}" # this is a special ami preconfigured to do NAT
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.aws_nat.id}"]
  subnet_id = "${aws_subnet.aws_subnet_pub.*.id[count.index]}"
  ipv6_address_count = 1
  source_dest_check = false
  key_name = "dev-key"

  root_block_device {
    volume_size = 5
  }

  tags {
    Name = "aws_pro_nat ${count.index}"
  }
}

resource "aws_instance" "aws_pro_app" {

  count = "${aws_subnet.aws_subnet_pub.count}"

  ami = "${data.aws_ami.aws_app_ami.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.aws_app.id}"]
  subnet_id = "${aws_subnet.aws_subnet_prib.*.id[count.index]}"
  source_dest_check = false
  key_name = "dev-key"

  root_block_device {
    volume_size = 10
    }
  tags {
    Name = "aws_pro_app ${count.index}"
  }
}