# Stackdriver Alert Policies for Cloud Load Balancing resources

resource "google_monitoring_alert_policy" "lb_l7_https" {
  provider = "google-beta"
  project = "${var.stackdriver_project}"
  display_name = "LoadBalancer L7 HTTPS"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  documentation {
    content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  }
  conditions = [{
    display_name = "Backend Latency"
    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/https/backend_latencies\" resource.type=\"https_lb_rule\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.lb_backend_latencies}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_PERCENTILE_95"
        group_by_fields = ["resource.labels.url_map_name"]
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  },{
    display_name = "Backend Requests count"
    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/https/backend_request_count\" resource.type=\"https_lb_rule\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.lb_backend_request_count}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["resource.labels.url_map_name", "metric.labels.response_code_class"]
      }
    }
  },{
    display_name = "Frontend RTT of each client-proxy connection (95th pct)"
    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/https/frontend_tcp_rtt\" resource.type=\"https_lb_rule\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.lb_frontend_tcp_rtt}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_PERCENTILE_95"
        group_by_fields = ["resource.labels.forwarding_rule_name"]
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  },{
    display_name = "Total latencies (95th pct)"
    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/https/total_latencies\" resource.type=\"https_lb_rule\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.lb_total_latencies}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_PERCENTILE_95"
        group_by_fields = ["resource.labels.url_map_name"]
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "lb_l3_internal" {
  project = "${var.stackdriver_project}"
  display_name = "LoadBalancer L3 Internal"
  enabled = "false"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "L3 RTT Latency (95th pct)"
    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/l3/internal/rtt_latencies\" resource.type=\"internal_tcp_lb_rule\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.lb_l3_internal_backend_latencies}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_PERCENTILE_95"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "lb_l3_tcp" {
  project = "${var.stackdriver_project}"
  display_name = "LoadBalancer L3 TCP/SSL Proxy"
  enabled = "false"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "L3 Frontend RTT Latency (95th pct)"
    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/tcp_ssl_proxy/frontend_tcp_rtt\" resource.type=\"tcp_ssl_proxy_rule\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.lb_l3_tcp_backend_latencies}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_PERCENTILE_95"
      }
    }
  }]
}
