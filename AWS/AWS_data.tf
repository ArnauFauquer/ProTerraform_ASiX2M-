provider "aws" {
  region = "eu-west-1"
  profile = ""
}

data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

variable "cidr" {
  type = "string"
  default = "10.0.0.0/16"
}
