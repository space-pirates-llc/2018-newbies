resource "aws_iam_role" "codedeploy" {
  name = "CodeDeployRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codedeploy" {
  name = "CodeDeployPolicy"
  role = "${aws_iam_role.codedeploy.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DeleteLifecycleHook",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLifecycleHooks",
        "autoscaling:PutLifecycleHook",
        "autoscaling:RecordLifecycleActionHeartbeat",
        "codedeploy:*",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "tag:GetTags",
        "tag:GetResources",
        "sns:Publish"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codedeploy_app" "nova" {
  count = "${length(var.teams)}"
  name  = "nova-${element(var.teams, count.index)}"
}

resource "aws_codedeploy_deployment_group" "nova" {
  count                  = "${length(var.teams)}"
  app_name               = "${element(aws_codedeploy_app.nova.*.name, count.index)}"
  deployment_group_name  = "nova-${element(var.teams, count.index)}"
  service_role_arn       = "${aws_iam_role.codedeploy.arn}"
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  autoscaling_groups     = ["${element(aws_autoscaling_group.app.*.id, count.index)}"]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
