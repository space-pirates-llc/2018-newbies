variable "rds_master_password" {
  type = "string"
}

resource "aws_iam_role" "rds_service_role" {
  name = "RDSMonitoringRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "managed-rds-policy" {
  role       = "${aws_iam_role.rds_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_subnet_group" "training-field" {
  count = "${length(var.teams)}"
  name  = "${format("db-subnet-private-%d", count.index)}"

  subnet_ids = [
    "${element(aws_subnet.training-field-private-a.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-c.*.id, count.index)}",
    "${element(aws_subnet.training-field-private-d.*.id, count.index)}",
  ]

  tags {
    Team = "${element(var.teams, count.index)}"
  }
}

resource "aws_db_instance" "training-field" {
  count                       = "${length(var.teams)}"
  allocated_storage           = 40
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  backup_retention_period     = 7
  backup_window               = "17:00-18:00"
  maintenance_window          = "Mon:15:30-Mon:16:30"
  monitoring_interval         = "5"
  monitoring_role_arn         = "${aws_iam_role.rds_service_role.arn}"
  identifier                  = "nova-${element(var.teams, count.index)}"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7.21"
  instance_class              = "db.t2.small"
  name                        = "nova"
  username                    = "nova"
  password                    = "${var.rds_master_password}"
  db_subnet_group_name        = "${element(aws_db_subnet_group.training-field.*.name, count.index)}"

  vpc_security_group_ids = [
    "${element(aws_default_security_group.training-field-private.*.id, count.index)}",
  ]

  tags {
    Team = "${element(var.teams, count.index)}"
  }
}
