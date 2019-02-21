resource "aws_route53_zone" "aws_private_zone" {
  name = "projecte.local"

  vpc {
    vpc_id = "${aws_vpc.aws_vpc_pro.id}"
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.aws_private_zone.zone_id}"
  name    = "rds"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.aws_mysql_app.endpoint}"]
}

