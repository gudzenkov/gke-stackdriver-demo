# Stackdriver Alert Policies for CloudSQL resources (DBs)

resource "google_monitoring_alert_policy" "auto_failover_request_count" {
  provider = "google"
  project = "${var.stackdriver_project}"
  display_name = "CloudSQL Failover Requests"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  # documentation {
  #  content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "Delta of number of instance auto-failover requests. Sampled every 60 seconds"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/auto_failover_request_count\" resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_auto_failover_request_count}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "cloudsql_instance_cpu" {
  provider = "google"
  project = "${var.stackdriver_project}"
  display_name = "CloudSQL CPU"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "CloudSQL CPU Utilization"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_instance_cpu}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "cloudsql_instance_disk" {
  provider = "google"
  project = "${var.stackdriver_project}"
  display_name = "CloudSQL Disk"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "CloudSQL Disk Utilization"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/disk/utilization\" resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_instance_disk}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "cloudsql_instance_memory" {
  provider = "google"
  project = "${var.stackdriver_project}"
  display_name = "CloudSQL Memory"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "CloudSQL Memory Utilization"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_instance_memory}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "database_mysql_network_connections" {
  provider = "google"
  project = "${var.stackdriver_project}"
  display_name = "CloudSQL Connections"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "MySQL too low active connections"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/network/connections\" AND resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "${var.database_mysql_connections_lower}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  },{
    display_name = "MySQL max connections reached"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/network/connections\" AND resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_mysql_connections_upper}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  },{
    display_name = "PostgreSQL too low active connections"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" AND resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_LT"
      threshold_value = "${var.database_pgsql_connections_lower}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.labels.database"]
      }
    }
  },{
    display_name = "PostgreSQL max connections reached"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" AND resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_pgsql_connections_upper}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.labels.database"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "cloudsql_queries" {
  provider = "google"
  project = "${var.stackdriver_project}"
  display_name = "CloudSQL Queries"
  enabled = "true"
  combiner = "OR"
  notification_channels = [
    "${google_monitoring_notification_channel.admin.name}",
    #"${google_monitoring_notification_channel.slack.name}"
  ]
  # Documentation section requires provider "google-beta"
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "MySQL Queries count"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/mysql/queries\" resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_mysql_queries}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  },{
    display_name = "MySQL Questions count"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/mysql/questions\" resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_mysql_questions}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  },{
    display_name = "PostgreSQL transaction count"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/postgresql/transaction_count\" AND resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_pgsql_transaction_count}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metric.labels.database"]
      }
    }
  }]
}

resource "google_monitoring_alert_policy" "database_replication_lag" {
  provider = "google"
  project = "${var.stackdriver_project}"
  display_name = "CloudSQL Replication Lag"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  # Documentation section requires provider "google-beta"
  # documentation {
  #   content = "Base policy '$${condition.display_name}' generated alert for $${metric.type} metric."
  # }
  conditions = [{
    display_name = "MySQL replication lag (sec behind master)"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/mysql/replication/seconds_behind_master\" AND resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_mysql_replication_seconds_behind_master}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = ["metadata.system_labels.name"]
      }
    }
  },{
    display_name = "PostgreSQL replication lag (bytes)"
    condition_threshold {
      filter = "metric.type=\"cloudsql.googleapis.com/database/postgresql/replication/replica_byte_lag\" AND resource.type=\"cloudsql_database\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.database_pgsql_replica_byte_lag}"
      aggregations {
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }]
}
