resource "aws_lb" "aws-alb" {

  name               = "aws-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.aws_app.id}"]
  subnets            = ["${aws_subnet.aws_subnet_prib.*.id}"]

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "aws-app-alb" {
  name     = "aws-app-alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.aws_vpc_pro.id}"
  stickiness {
    type = "lb_cookie"
    cookie_duration = 3600
  }
}

resource "aws_lb_target_group_attachment" "http" {
  count            = "${aws_instance.aws_pro_app.count}"
  target_group_arn = "${aws_lb_target_group.aws-app-alb.arn}"
  target_id = "${aws_instance.aws_pro_app.*.id[count.index]}"
  port = "80"
}

resource "aws_lb_listener" "forward-aws-app" {
  load_balancer_arn = "${aws_lb.aws-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.aws-app-alb.arn}"
  }
}