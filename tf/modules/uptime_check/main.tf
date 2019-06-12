data "google_project" "project" {}

locals {
  header_keys = "${compact(concat(keys(var.headers), list("Content-Type", "Accept", var.auth_token!="" ? "Authorization" : "")))}"
  header_values = "${compact(concat(values(var.headers), list(var.content_type, var.content_accept, var.auth_token!="" ? format("token %s",var.auth_token) : "")))}"
  merged_headers = "${zipmap(local.header_keys, local.header_values)}"
  uptime_check_id = "${element(split("/",google_monitoring_uptime_check_config.uptime_check.id),3)}"
}

resource "google_monitoring_uptime_check_config" "uptime_check" {
  display_name = "${var.name != "" ? var.name : format("%s%s",var.host,var.path)}"
  period = "${var.period}"
  timeout = "${var.timeout}"

  http_check {
    path = "${var.path}"
    port = "${var.port != 0 ? var.port : var.use_ssl != "" ? 443 : 80}"
    use_ssl = "${var.use_ssl}"
    mask_headers = "${var.auth_token!="" ? true : var.mask_headers}"
    headers = "${local.merged_headers}"
  }
  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = "${data.google_project.project.project_id}"
      host = "${var.host}"
    }
  }
  content_matchers {
    content = "${var.match}"
  }
}

resource "google_monitoring_alert_policy" "uptime_alert" {
  count = "${var.alerting || var.policy_name != "" ? 1 : 0}"
  depends_on = ["google_monitoring_uptime_check_config.uptime_check"]
  display_name = "${var.policy_name != "" ? var.policy_name : format("Uptime %s", title(element(split("/",var.path),1)))}"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${var.notifications}"]
  conditions = [{
    display_name = "Uptime Health Check on ${google_monitoring_uptime_check_config.uptime_check.display_name}"
    condition_threshold {
      filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.uptime_check_id}\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.alert_threshold}"
      trigger = [{count=1}]
      aggregations {
        group_by_fields      = ["resource.*"]
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        alignment_period     = "${var.alignment_period}"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }
    }
  }]
}
