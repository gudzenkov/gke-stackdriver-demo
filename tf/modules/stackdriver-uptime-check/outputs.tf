output "uptime_check_id" {
  value = "${local.uptime_check_id}"
}
output "uptime_check_name" {
  value = "${google_monitoring_uptime_check_config.uptime_check.name}"
}
