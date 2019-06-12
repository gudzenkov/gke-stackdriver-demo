### Stackdriver monitoring

output "region" {
  value = "${var.region}"
}

output "stackdriver_project" {
  value = "${var.stackdriver_project}"
}
output "core_project_id" {
  value = "${var.core_project}"
}

output "data_project_id" {
  value = "${var.data_project}"
}
output "kube_project_id" {
  value = "${var.kube_project}"
}


output "notification_channels" {
  value = "${local.notification_channels}"
}
