# Stackdriver Alert Policies for Cloud Storage resources

resource "google_monitoring_alert_policy" "storage_requests_count" {
  provider = "google-beta"
  project = "${var.stackdriver_project}"
  display_name = "Storage Requests"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  documentation {
    content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  }
  conditions = [{
    display_name = "API requests count"
    condition_threshold {
      filter = "metric.type=\"storage.googleapis.com/api/request_count\" resource.type=\"gcs_bucket\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.storage_requests_count}"
      aggregations {
        group_by_fields = ["resource.labels.bucket_name"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }]
}
resource "google_monitoring_alert_policy" "storage_object_count" {
  provider = "google-beta"
  project = "${var.stackdriver_project}"
  display_name = "Storage Objects Count"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  documentation {
    content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  }
  conditions = [{
    display_name = "Total number of objects per bucket"
    condition_threshold {
      filter = "metric.type=\"storage.googleapis.com/storage/object_count\" resource.type=\"gcs_bucket\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.storage_object_count}"
      aggregations {
        group_by_fields = ["resource.labels.bucket_name"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}
