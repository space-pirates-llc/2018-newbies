output "num-of-teams" {
  value = "${length(var.teams)}"
}

output "ipv4-cidr-blocks" {
  value = ["${aws_vpc.training-field.*.cidr_block}"]
}

output "ipv6-cidr-blocks" {
  value = ["${aws_vpc.training-field.*.ipv6_cidr_block}"]
}

output "bastion-dns" {
  value = ["${aws_elb.bastion.*.dns_name}"]
}

output "app-dns" {
  value = ["${aws_lb.app.*.dns_name}"]
}

output "db-host" {
  value = ["${aws_db_instance.training-field.*.dns_name}"]
}
