# Stackdriver Alert Policies for BigTable resources

resource "google_monitoring_alert_policy" "bigtable_cluster" {
  project = "${var.stackdriver_project}"
  provider = "google"
  display_name = "BigTable Cluster"
  enabled = "true"
  combiner = "OR"
  notification_channels = [
    "${google_monitoring_notification_channel.admin.name}",
    #"${google_monitoring_notification_channel.slack.name}"
  ]
  # Documentation section requires provider "google-beta" v2.x
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "Cluster Node Count"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/cluster/node_count\" AND resource.type=\"bigtable_cluster\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "${var.bigtable_cluster_node_count}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields = ["resource.labels.cluster"]
      }
    }
  },{
    display_name = "Cluster CPU Total load"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/cluster/cpu_load\" AND resource.type=\"bigtable_cluster\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.bigtable_cluster_total_cpu_load}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields = ["resource.labels.cluster"]
      }
    }
  },{
    display_name = "Cluster CPU Hottest load"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/cluster/cpu_load_hottest_node\" AND resource.type=\"bigtable_cluster\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.bigtable_cluster_hottest_cpu_load}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields = ["resource.labels.cluster"]
      }
    }
  },{
    display_name = "Cluster HDD utilization"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/cluster/disk_load\" AND resource.type=\"bigtable_cluster\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.bigtable_cluster_disk_load}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields = ["resource.labels.cluster"]
      }
    }
  },{
    display_name = "Cluster Storage Utilization"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/cluster/storage_utilization\" AND resource.type=\"bigtable_cluster\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.bigtable_cluster_storage_utilization}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields = ["resource.labels.cluster"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "bigtable_server" {
  project = "${var.stackdriver_project}"
  provider = "google"
  display_name = "BigTable Server"
  enabled = "true"
  combiner = "OR"
  notification_channels = [
    "${google_monitoring_notification_channel.admin.name}",
    #"${google_monitoring_notification_channel.slack.name}"
  ]
  # Documentation section requires provider "google-beta" v2.x
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "Server Failed Requests"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/server/error_count\" AND resource.type=\"bigtable_table\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.bigtable_server_error_count}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["resource.labels.table"]
      }
    }
  },{
    display_name = "Server Request Latencies"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/server/latencies\" AND resource.type=\"bigtable_table\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.bigtable_server_latencies}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_PERCENTILE_95"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["resource.labels.table"]
      }
    }
  },{
    display_name = "Server Requests Count"
    condition_threshold {
      filter = "metric.type=\"bigtable.googleapis.com/server/request_count\" AND resource.type=\"bigtable_table\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.bigtable_server_request_count}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["resource.labels.table"]
      }
    }
  }]
}
