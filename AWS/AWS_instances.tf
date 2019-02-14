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
EOF1
  mkdir /data/bitnami
  docker-compose up -d
 USERDATA
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
  user_data_base64 = "${base64encode(local.aws_app)}"

  root_block_device {
    volume_size = 60
    volume_type = "standard"
    }
  tags {
    Name = "aws_pro_app ${count.index}"
  }
}