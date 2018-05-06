resource "aws_elb" "bastion" {
  count           = "${length(var.teams)}"
  name            = "bastion-${element(var.teams, count.index)}"
  security_groups = ["${element(aws_security_group.training-field-public.*.id, count.index)}"]

  subnets = [
    "${element(aws_subnet.training-field-public-a.*.id, count.index)}",
    "${element(aws_subnet.training-field-public-c.*.id, count.index)}",
    "${element(aws_subnet.training-field-public-d.*.id, count.index)}",
  ]

  internal = false

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  cross_zone_load_balancing = true
  connection_draining       = true

  health_check {
    target              = "TCP:22"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 5
    timeout             = 3
  }

  tags {
    Name = "bastion-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_launch_configuration" "bastion" {
  count                       = "${length(var.teams)}"
  image_id                    = "${data.aws_ami.ubuntu.id}"
  name                        = "bastion-${element(var.teams, count.index)}"
  instance_type               = "t2.micro"
  spot_price                  = "0.1"
  key_name                    = "${element(var.teams, count.index)}"
  security_groups             = ["${element(aws_default_security_group.training-field-private.*.id, count.index)}"]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  count                = "${length(var.teams)}"
  name                 = "bastion-${element(var.teams, count.index)}"
  launch_configuration = "${element(aws_launch_configuration.bastion.*.name, count.index)}"
  max_size             = 1
  min_size             = 1
  health_check_type    = "EC2"

  vpc_zone_identifier = [
    "${element(aws_subnet.training-field-private-a.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-c.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-d.*.id, count.index)}",
  ]

  load_balancers = ["${element(aws_elb.bastion.*.name, count.index)}"]

  tags = [
    {
      key                 = "Name"
      value               = "bastion-${element(var.teams, count.index)}"
      propagate_at_launch = true
    },
    {
      key                 = "Team"
      value               = "${element(var.teams, count.index)}"
      propagate_at_launch = true
    },
    {
      key                 = "Use"
      value               = "bastion"
      propagate_at_launch = true
    },
  ]
}
