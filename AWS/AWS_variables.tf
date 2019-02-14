variable "ip_stucom" {
  type = "string"
  default = "2.139.181.130/32"
}

variable "region" {
  type = "string"
  default = "eu-west-1"
}

variable "mysql-login" {
  default = "aws_admin"
}
variable "mysql-passwd" {}