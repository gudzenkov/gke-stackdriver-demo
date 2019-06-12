# Stackdriver Notification Channels

# Email account or distribution list
resource "google_monitoring_notification_channel" "admin" {
  project = "${var.stackdriver_project}"
  display_name = "DevOps admin"
  type = "email"
  labels = {
    email_address = "${var.admin_email}"
  }
}

# Pager Duty
resource "google_monitoring_notification_channel" "pagerduty" {
  display_name = "Pagerduty"
  type         = "pagerduty"
  project = "${var.stackdriver_project}"

  labels = {
    service_key = "${var.pagerduty_service_key}"
  }
}

# Slack
resource "google_monitoring_notification_channel" "slack" {
  display_name = "Slack"
  type         = "slack"
  project = "${var.stackdriver_project}"

  labels = {
    auth_token   = "${var.slack_auth_token}"
    channel_name = "${var.slack_channel}"
  }
}
