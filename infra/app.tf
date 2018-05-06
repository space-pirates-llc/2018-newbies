resource "aws_iam_role" "app" {
  name = "ApplicationRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "app" {
  name = "ApplicationRolePolicy"
  role = "${aws_iam_role.app.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "app" {
  name = "ApplicationInstanceProfile"
  role = "${aws_iam_role.app.name}"
}

resource "aws_lb" "app" {
  count              = "${length(var.teams)}"
  name               = "app-${element(var.teams, count.index)}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${element(aws_security_group.training-field-public.*.id, count.index)}"]

  subnets = [
    "${element(aws_subnet.training-field-public-a.*.id, count.index)}",
    "${element(aws_subnet.training-field-public-c.*.id, count.index)}",
    "${element(aws_subnet.training-field-public-d.*.id, count.index)}",
  ]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  ip_address_type                  = "dualstack"

  tags {
    Name = "app-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_lb_target_group" "app" {
  count    = "${length(var.teams)}"
  name     = "app-${element(var.teams, count.index)}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${element(aws_vpc.training-field.*.id, count.index)}"

  health_check {
    interval = 5
    timeout  = 2
    protocol = "HTTP"
  }

  tags {
    Name = "app-${element(var.teams, count.index)}"
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_lb_listener" "app" {
  count             = "${length(var.teams)}"
  load_balancer_arn = "${element(aws_lb.app.*.arn, count.index)}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${element(aws_lb_target_group.app.*.arn, count.index)}"
    type             = "forward"
  }
}

resource "aws_launch_configuration" "app" {
  count                       = "${length(var.teams)}"
  image_id                    = "${data.aws_ami.app.id}"
  name                        = "nova-${element(var.teams, count.index)}"
  instance_type               = "t2.medium"
  key_name                    = "${element(var.teams, count.index)}"
  security_groups             = ["${element(aws_default_security_group.training-field-private.*.id, count.index)}"]
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.app.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  count                = "${length(var.teams)}"
  name                 = "app-${element(var.teams, count.index)}"
  launch_configuration = "${element(aws_launch_configuration.app.*.name, count.index)}"
  max_size             = 2
  min_size             = 2
  health_check_type    = "EC2"

  vpc_zone_identifier = [
    "${element(aws_subnet.training-field-private-a.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-c.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-d.*.id, count.index)}",
  ]

  target_group_arns = ["${element(aws_lb_target_group.app.*.arn, count.index)}"]

  tags = [
    {
      key                 = "Name"
      value               = "app-${element(var.teams, count.index)}"
      propagate_at_launch = true
    },
    {
      key                 = "Team"
      value               = "${element(var.teams, count.index)}"
      propagate_at_launch = true
    },
    {
      key                 = "Use"
      value               = "app"
      propagate_at_launch = true
    },
  ]
}
