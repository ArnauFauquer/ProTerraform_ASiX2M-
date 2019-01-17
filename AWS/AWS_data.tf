data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

data "aws_ami" "nat" {
  filter {
    name = "name"
    values = [
      "amzn-ami-vpc-nat-hvm-*"]
  }
  most_recent = true
}

variable "cidr" {
  type = "string"
  default = "10.0.0.0/16"
}

data "aws_ami" "aws_app_ami" {
  filter {
    name = "state"
    values = [
      "available"]
  }
}