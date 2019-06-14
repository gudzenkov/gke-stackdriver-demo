# Stackdriver Alert Policies for Memorystore resources (Redis)

resource "google_monitoring_alert_policy" "redis_clients" {
  project = "${var.stackdriver_project}"
  display_name = "Redis clients"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Redis clients blocked"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/clients/blocked\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.redis_clients_blocked}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },{
    display_name = "Redis clients connected"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/clients/connected\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.redis_clients_connected}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },{
   display_name = "Redis too low active connections"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/stats/connections/total\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "${var.redis_connections_accepted}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },{
    display_name = "Redis total connections rejected"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/stats/reject_connections_count\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.redis_connections_rejected}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "redis_utilization" {
  project = "${var.stackdriver_project}"
  display_name = "Redis utilization"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Redis CPU utilization"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/stats/cpu_utilization\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.redis_cpu_utilization}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },{
    display_name = "Redis system memory utilization"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/stats/memory/system_memory_usage_ratio\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.redis_sys_mem_utilization}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },{
    display_name = "Redis memory utilization"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/stats/memory/usage_ratio\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.redis_mem_utilization}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "redis_replication" {
  project = "${var.stackdriver_project}"
  display_name = "Redis replication"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Redis CPU utilization"
    condition_threshold {
      filter = "metric.type=\"redis.googleapis.com/replication/master/slaves/lag\" AND resource.type=\"redis_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.redis_replication_lag}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}
