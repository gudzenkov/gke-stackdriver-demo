resource "google_monitoring_alert_policy" "uptime_alert" {
  display_name = "Uptime health-checks"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
      display_name = "Uptime Health Check trigger events"
      condition_threshold {
        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\""
        duration = "${var.alert_duration}"
        comparison = "COMPARISON_GT"
        threshold_value = "${var.uptime_check_threshold}"
        trigger = [{count=1}]
        aggregations {
          group_by_fields      = ["metric.label.check_id"]
          cross_series_reducer = "REDUCE_COUNT_FALSE"
          alignment_period     = "${var.alignment_period}"
          per_series_aligner   = "ALIGN_NEXT_OLDER"
        }
      }
  }]
}
