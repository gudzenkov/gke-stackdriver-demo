# Stackdriver Alert Policies for Cloud API resources

resource "google_monitoring_alert_policy" "api_quota" {
  provider = "google-beta"
  project = "${var.stackdriver_project}"
  display_name = "API Quota"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [
  {
    display_name = "The total consumed allocation quota"
    condition_threshold {
      filter = "metric.type=\"serviceruntime.googleapis.com/quota/allocation/usage\" resource.type=\"consumer_quota\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Quota exceeded errors"
    condition_threshold {
      filter = "metric.type=\"serviceruntime.googleapis.com/quota/exceeded\" resource.type=\"consumer_quota\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  },
  {
    display_name = "The limit for the quota"
    condition_threshold {
      filter = "metric.type=\"serviceruntime.googleapis.com/quota/limit\" resource.type=\"consumer_quota\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  ]
}

resource "google_monitoring_alert_policy" "api_consumed" {
  project = "${var.stackdriver_project}"
  display_name = "API Consumed"
  enabled = "false"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [
 {
   display_name = "Failed rquests count by API method"
   condition_threshold {
     filter = "metric.type=\"serviceruntime.googleapis.com/api/request_count\" resource.type=\"consumed_api\" metric.labels.response_code_class!=\"2xx\""
     duration = "${var.alert_duration}"
     comparison = "COMPARISON_LT"
     aggregations {
       alignment_period = "${var.alignment_period}"
       per_series_aligner = "ALIGN_RATE"
     }
   }
 },
 {
   display_name = "Total API requests count"
   condition_threshold {
     filter = "metric.type=\"serviceruntime.googleapis.com/api/request_count\" resource.type=\"consumed_api\""
     duration = "${var.alert_duration}"
     comparison = "COMPARISON_LT"
     aggregations {
       group_by_fields = ["resource.method"]
       alignment_period = "${var.alignment_period}"
       per_series_aligner = "ALIGN_RATE"
     }
   }
 },
  {
    display_name = "Failed requests by API method (%)"
    condition_threshold {
      filter = "metric.type=\"serviceruntime.googleapis.com/api/request_count\" resource.type=\"consumed_api\" metric.labels.response_code_class!=\"2xx\""
      denominator_filter = "metric.type=\"serviceruntime.googleapis.com/api/request_count\" resource.type=\"consumed_api\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.api_failed_request_pct}"
      denominator_aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
      }
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  },
  {
    display_name = "Distribution of latency"
    condition_threshold {
      filter = "metric.type=\"serviceruntime.googleapis.com/api/request_latencies\" resource.type=\"consumed_api\" resource.label.\"method\"!=monitoring.regex.full_match(\"google.monitoring.*\")"
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.api_request_latencies}"
      aggregations {
        group_by_fields = ["resource.method"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_PERCENTILE_95"
      }
    }
  }]
}
