# Stackdriver Alert Policies for Cloud Pub/Sub resources

resource "google_monitoring_alert_policy" "pubsub_subscription" {
  provider = "google-beta"
  project = "${var.stackdriver_project}"
  display_name = "PubSub Subscription"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Number of acknowledged messages retained in a subscription"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/subscription/num_retained_acked_messages\" resource.type=\"pubsub_subscription\" resource.labels.subscription_id!=\"logs-subscription\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_num_retained_acked_messages}"
      aggregations {
        group_by_fields = ["resource.labels.subscription_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Number of unacknowledged (backlog) messages"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.labels.subscription_id!=\"logs-subscription\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_num_undelivered_messages}"
      aggregations {
        group_by_fields = ["resource.labels.subscription_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Age (in seconds) of the oldest retained acknowledged message"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/subscription/oldest_retained_acked_message_age\" resource.type=\"pubsub_subscription\" resource.labels.subscription_id!=\"logs-subscription\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_oldest_retained_acked_message_age}"
      aggregations {
        group_by_fields = ["resource.labels.subscription_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Age (in seconds) of the oldest unacknowledged (backlog) message"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/subscription/oldest_unacked_message_age\" resource.type=\"pubsub_subscription\" resource.labels.subscription_id!=\"logs-subscription\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_oldest_unacked_message_age}"
      aggregations {
        group_by_fields = ["resource.labels.subscription_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Cumulative count of pull requests"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/subscription/pull_request_count\" resource.type=\"pubsub_subscription\" resource.labels.subscription_id!=\"logs-subscription\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_pull_request_count}"
      aggregations {
        group_by_fields = ["resource.labels.subscription_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  },
  {
    display_name = "Cumulative count of push attempts"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/subscription/push_request_count\" resource.type=\"pubsub_subscription\" resource.labels.subscription_id!=\"logs-subscription\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_push_request_count}"
      aggregations {
        group_by_fields = ["resource.labels.subscription_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  }]
}
resource "google_monitoring_alert_policy" "pubsub_topic" {
  provider = "google-beta"
  project = "${var.stackdriver_project}"
  display_name = "PubSub Topic"
  enabled = "true"
  combiner = "OR"
  notification_channels = ["${local.notification_channels}"]
  conditions = [{
    display_name = "Number of acknowledged messages retained in a topic"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/topic/num_retained_acked_messages_by_region\" resource.type=\"pubsub_topic\" resource.labels.topic_id!=\"service-projects-logs-topic\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_num_retained_acked_message_by_region}"
      aggregations {
        group_by_fields = ["resource.labels.topic_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Number of unacknowledged messages in a topic"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/topic/num_unacked_messages_by_region\" resource.type=\"pubsub_topic\" resource.labels.topic_id!=\"service-projects-logs-topic\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_num_unacked_messages_by_region}"
      aggregations {
        group_by_fields = ["resource.labels.topic_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Age (in seconds) of the oldest acknowledged message retained in a topic"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/topic/oldest_retained_acked_message_age_by_region\" resource.type=\"pubsub_topic\" resource.labels.topic_id!=\"service-projects-logs-topic\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_oldest_retained_acked_message_age_by_region}"
      aggregations {
        group_by_fields = ["resource.labels.topic_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Age (in seconds) of the oldest unacknowledged message in a topic"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/topic/oldest_unacked_message_age_by_region\" resource.type=\"pubsub_topic\" resource.labels.topic_id!=\"service-projects-logs-topic\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_oldest_unacked_message_age_by_region}"
      aggregations {
        group_by_fields = ["resource.labels.topic_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  },
  {
    display_name = "Cumulative count of publish message operations"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_send_message_operation_count}"
      aggregations {
        group_by_fields = ["resource.labels.topic_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  },
  {
    display_name = "Cumulative count of publish requests"
    condition_threshold {
      filter = "metric.type=\"pubsub.googleapis.com/topic/send_request_count\" resource.type=\"pubsub_topic\""
      duration = "${var.alert_duration}"
      comparison = "COMPARISON_GT"
      threshold_value = "${var.pubsub_send_request_count}"
      aggregations {
        group_by_fields = ["resource.labels.topic_id"]
        alignment_period = "${var.alignment_period}"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  }]
}
