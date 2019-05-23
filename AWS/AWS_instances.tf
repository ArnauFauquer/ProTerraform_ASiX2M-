resource "aws_instance" "aws_pro_nat" {
  count = "${aws_subnet.aws_subnet_pub.count}"
  ami = "ami-024107e3e3217a248" # this is a special ami preconfigured to do NAT
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.aws_nat.id}"]
  subnet_id = "${aws_subnet.aws_subnet_pub.*.id[count.index]}"
  ipv6_address_count = 1
  source_dest_check = false
  key_name = "dev-key"

  root_block_device {
    volume_size = 8
    volume_type = "standard"
  }

  tags {
    Name = "aws_pro_nat ${count.index}"
  }
}

locals {
  aws_app = <<USERDATA
  #!/bin/bash
  cat <<EOF1 >> /docker-compose.yml
  ${file("docker-compose.yml")}


  mkdir /data/bitnami
  docker-compose up -d
 USERDATA
}

resource "aws_instance" "aws_pro_app" {

  count = "${aws_subnet.aws_subnet_pub.count}"
  ami = "ami-08d658f84a6d84a80"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.aws_app.id}"]
  subnet_id = "${aws_subnet.aws_subnet_prib.*.id[count.index]}"
  source_dest_check = false
  key_name = "dev-key"
  user_data_base64 = "${base64encode(local.aws_app)}"

  root_block_device {
    volume_size = 60
    volume_type = "standard"
    }
  tags {
    Name = "aws_pro_app ${count.index}"
  }
}

resource "aws_instance" "aws_test-app" {

  count = "1"
  ami = "ami-08d658f84a6d84a80"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.aws_app.id}"]
  subnet_id = "${aws_subnet.aws_subnet_prib.*.id[count.index]}"
  source_dest_check = false
  key_name = "dev-key"
  user_data_base64 = "${base64encode(local.aws_app)}"

  root_block_device {
    volume_size = 60
    volume_type = "standard"
  }
  tags {
    Name = "aws_test ${count.index}"
  }
}