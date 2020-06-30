# Stackdriver Alert Policies for Kubernetes resources

resource "google_monitoring_alert_policy" "k8s_container_cpu_limit_utilization" {
  project = "${var.stackdriver_project}"
  display_name = "GKE CPU request/limit"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Container CPU limit utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.gke_container_cpu_limit}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["metadata.user_labels.name"]
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  },{
    display_name = "Container CPU request utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/cpu/request_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"!=\"kube-system\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "${var.gke_container_cpu_request}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["metadata.user_labels.name"]
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "k8s_memory_limit_utilization" {
  project = "${var.stackdriver_project}"
  display_name = "GKE Memory request/limit"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Container memory limit utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.gke_container_memory_limit}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["metadata.user_labels.name"]
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  },{
    display_name = "Container memory request utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/memory/request_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"!=\"kube-system\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "${var.gke_container_memory_request}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields = ["metadata.user_labels.name"]
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "k8s_container_restart_count" {
  project = "${var.stackdriver_project}"
  display_name = "GKE container restart"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Container restart count"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.gke_container_restart_count}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "k8s_pod_volume_utilization" {
  project = "${var.stackdriver_project}"
  display_name = "GKE POD Volume"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "POD volume utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/pod/volume/utilization\" resource.type=\"k8s_pod\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.gke_pod_volume_utilization}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.user_labels.k8s-app"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "k8s_node_cpu_utilization" {
  project = "${var.stackdriver_project}"
  display_name = "GKE Node CPU"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Node CPU utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/cpu/allocatable_utilization\" resource.type=\"k8s_node\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.gke_node_cpu}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "k8s_node_storage_utilization" {
  project = "${var.stackdriver_project}"
  display_name = "GKE Node Storage Available"
  enabled = "true"
  combiner = "OR"
  notification_channels = [
    "${google_monitoring_notification_channel.admin.name}",
    #"${google_monitoring_notification_channel.slack.name}"
  ]
  conditions = [{
    display_name = "Node ephemeral storage bytes allocatable"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/ephemeral_storage/allocatable_bytes\" resource.type=\"k8s_node\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Total ephemeral storage bytes on the node"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/ephemeral_storage/total_bytes\" resource.type=\"k8s_node\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Percentage of free ephemeral storage available for allocation"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/ephemeral_storage/allocatable_bytes\" resource.type=\"k8s_node\""
      denominator_filter = "metric.type=\"kubernetes.io/node/ephemeral_storage/total_bytes\" resource.type=\"k8s_node\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "${var.gke_node_storage_available_pct}"
      denominator_aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
]
}

resource "google_monitoring_alert_policy" "k8s_container_storage_limit" {
  project = "${var.stackdriver_project}"
  display_name = "GKE Storage limit"
  enabled = "true"
  combiner = "OR"
  notification_channels = [
    "${google_monitoring_notification_channel.admin.name}",
    #"${google_monitoring_notification_channel.slack.name}"
  ]
  conditions = [{
    display_name = "Container ephemeral storage limit"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/ephemeral_storage/limit_bytes\" resource.type=\"k8s_container\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Container ephemeral storage usage"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/ephemeral_storage/used_bytes\" resource.type=\"k8s_container\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Container ephemeral storage limit utilization percentage"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/ephemeral_storage/limit_bytes\" resource.type=\"k8s_container\""
      denominator_filter = "metric.type=\"kubernetes.io/container/ephemeral_storage/used_bytes\" resource.type=\"k8s_container\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.gke_container_storage_utilization_pct}"
      denominator_aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
]
}

resource "google_monitoring_alert_policy" "k8s_node_memory_utilization" {
  project = "${var.stackdriver_project}"
  display_name = "GKE Node Memory"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Node Memory utilization"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/node/memory/allocatable_utilization\" resource.type=\"k8s_node\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.gke_node_memory}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}
