# Stackdriver Monitoring

locals {

  notify_none = []
  notify_admin = [
    "${google_monitoring_notification_channel.admin.name}"
  ]

  notify_all = [
    "${google_monitoring_notification_channel.admin.name}",
    "${google_monitoring_notification_channel.slack.name}",
    "${google_monitoring_notification_channel.pagerduty.name}"
  ]

  notification_channels = "${local.notify_none}"
}
