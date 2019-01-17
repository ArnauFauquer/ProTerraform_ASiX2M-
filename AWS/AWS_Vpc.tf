resource "aws_vpc" "aws_vpc_pro" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  assign_generated_ipv6_cidr_block = true

  tags {
    Name = "Aws_vpc_1"
  }
}

resource "aws_internet_gateway" "aws_pro_gateway" {
  vpc_id = "${aws_vpc.aws_vpc_pro.id}"

  tags {
    Name = "Aws_pro_gateway"
  }
}
#Subnet
resource "aws_subnet" "aws_subnet_pub" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidrsubnet(aws_vpc.aws_vpc_pro.cidr_block, 8, count.index + 1)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.aws_vpc_pro.ipv6_cidr_block, 8, count.index + 1)}"
  assign_ipv6_address_on_creation = true
  vpc_id            = "${aws_vpc.aws_vpc_pro.id}"
  map_public_ip_on_launch = true
  
  tags ={
    Name= "AWS_subnet_pub[count.index]"
    depends_on = ["aws_vpc.aws_subnet_pub"]
  }

}

resource "aws_subnet" "aws_subnet_prib" {
  count = "${aws_subnet.aws_subnet_pub.count}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidrsubnet(aws_vpc.aws_vpc_pro.cidr_block, 8, count.index + 10 + 1)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.aws_vpc_pro.ipv6_cidr_block, 8, count.index + 10 + 1)}"
  assign_ipv6_address_on_creation = false
  vpc_id            = "${aws_vpc.aws_vpc_pro.id}"
  map_public_ip_on_launch = false

  tags = {
    Name= "AWS_subnet_prib[count.index]"
  }
}
