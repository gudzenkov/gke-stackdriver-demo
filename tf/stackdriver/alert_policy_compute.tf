# Stackdriver Alert Policies for Compute resources (VMs)

resource "google_monitoring_alert_policy" "base_cpu" {
  project = "${var.stackdriver_project}"
  provider = "google-beta"
  display_name = "VM CPU"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta" v2.x
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "CPU Utilization"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_cpu}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  },
  {
    display_name = "CPU Load 5m"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/cpu/load_5m\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "2"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["metadata.system_labels.name"]
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  },
  {
    display_name = "CPU Load 15m"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/cpu/load_15m\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "1.5"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["metadata.system_labels.name"]
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "base_disk_space" {
  project = "${var.stackdriver_project}"
  display_name = "VM Disk"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Disk Utilization"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/disk/percent_used\" resource.type=\"gce_instance\" metric.label.\"device\"=monitoring.regex.full_match(\"sd\\\\w+\\\\d+.*\") metric.label.\"state\"=\"used\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_disk}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name","metric.label.device"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "base_memory" {
  project = "${var.stackdriver_project}"
  display_name = "VM Memory"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Memory Utilization"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\" metric.label.\"state\"=\"used\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_memory}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },{
    display_name = "Swap Utilization"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/swap/percent_used\" resource.type=\"gce_instance\" metric.label.\"state\"=\"used\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_swap}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "base_disk_io" {
  project = "${var.stackdriver_project}"
  display_name = "VM Disk IO time"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Disk IO time (ms/sec)"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/disk/io_time\" resource.type=\"gce_instance\" metric.label.\"device\"=monitoring.regex.full_match(\"sd\\\\w+\\\\d+.*\")"
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_disk_io_time}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  },{
    display_name = "Disk weighted I/O time (sec/sec)"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/disk/weighted_io_time\" resource.type=\"gce_instance\" metric.label.\"device\"=monitoring.regex.full_match(\"sd\\\\w+\\\\d+.*\")"
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_disk_io_weighted_time}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  },{
    display_name = "Disk pending operations"
    condition_threshold {
      filter = "metric.type=\"agent.googleapis.com/disk/pending_operations\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_disk_pending_operations}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "disk_throttle" {
  provider = "google-beta"
  project = "${var.stackdriver_project}"
  display_name = "VM Disk IOPS"
  enabled = "true"
  combiner = "OR"
  notification_channels = [
    "${google_monitoring_notification_channel.admin.name}",
    #"${google_monitoring_notification_channel.slack.name}"
  ]
  conditions = [{
    display_name = "Disk read IO operations"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/read_ops_count\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "0"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  },
  {
    display_name = "Throttled read operations"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/throttled_read_ops_count\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "0"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  },
  {
    display_name = "Percentage of disk read IOPS throttled over the limit"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/throttled_read_ops_count\" resource.type=\"gce_instance\""
      denominator_filter = "metric.type=\"compute.googleapis.com/instance/disk/read_ops_count\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_disk_iops_throttled}"
      denominator_aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  },
  {
    display_name = "Disk write IO operations"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/write_ops_count\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "0"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  },
{
    display_name = "Throttled write operations"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/throttled_write_ops_count\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "0"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  },
  {
    display_name = "Percentage of disk write IOPS throttled over the limit"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/throttled_write_ops_count\" resource.type=\"gce_instance\""
      denominator_filter = "metric.type=\"compute.googleapis.com/instance/disk/write_ops_count\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_treshold_disk_iops_throttled}"
      denominator_aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  }
   ]
}

resource "google_monitoring_alert_policy" "firewall_dropped_packets" {
  project = "${var.stackdriver_project}"
  display_name = "VM Firewall dropped packets"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Firewall dropped packets during last 60s"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/firewall/dropped_packets_count\" resource.type=\"gce_instance\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.base_threshold_firewall_dropped_packets}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.label.instance_name"]
      }
    }
  }]
}
