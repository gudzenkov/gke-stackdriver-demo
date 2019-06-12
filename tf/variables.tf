### Stackdriver project
variable "stackdriver_project" {
    description = "Stackdriver project where all the Policies will be bound"
}

# Environment params
variable env {
    description = "Environment name"
    default = "dev"
}

variable environment {
    description = "Environment description"
    default = "Development"
}

variable "admin_email" {
    description = "Infra admin email for Stackdriver email notifications"
    default = "admin@domain.com"
}

variable "pagerduty_service_key" {
    description = "PagerDuty service-key for Stackdriver email notifications"
    default = "SECRET"
}

variable "slack_auth_token" {
    description = "Slack auth token for Stackdriver email notifications"
    default = "SECRET"
}

variable "slack_channel" {
    description = "Slack Channel for Stackdriver email notifications"
    default = "monitoring"
}

variable "prefix" {
    description = "Prefix used to mark the resources"
    default = "gke-private"
}

variable "domain" {
    description = "Company Domain"
    default = "domain.com"
}

variable "api_gateway" {
    description = "API Gateway for Uptime checks"
    default = "gw.domain.com"
}

# Groups for Region/Zones and Projects
variable "region" {
    default = "us-east1"
}

variable "zone1" {
    default = "us-east1-b"
}
variable "zone2" {
    default = "us-east1-c"
}
variable "zone3" {
    default = "us-east1-d"
}

variable "core_project" {
    description = "Core project where all the base resources are allocated (SVPC/VMs/NAT/etc.)"
    default = ""
}
variable "data_project" {
    description = "Data project where all Databases and Storage buckets are allocated"
    default = ""
}
variable "kube_project" {
    description = "Kubernetes cluster project"
    default = ""
}

# Alert Policy defaults
variable "alert_duration" {
  default = "300s"
  description = "The time that a time series must fail to trigger an alert"
}

variable "alignment_period" {
    default = "60s"
    description = "After per-time series alignment, each time series will contain data points only on the period boundaries. Min 60s"
}

# Compute (VM) thresholds
variable "base_treshold_cpu" {
    default = "0.8"
    description = "CPU utilization (per core) threshold generating an Alert"
}

variable "base_treshold_memory" {
    default = "80"
    description = "Alert will be generated if Free Memory (%) drops lover than the threshold"
}

variable "base_treshold_swap" {
    default = "70"
    description = "Alert will be generated if Free Swap (%) drops lover than the threshold"
}

variable "base_treshold_disk" {
    default = "70"
    description = "Disk utilization (%) threshold generating an Alert"
}

variable "base_treshold_disk_io_time" {
    default = "1"
    description = "Disk I/O-operation time (avg) threshold generating an Alert"
}

variable "base_treshold_disk_io_weighted_time" {
    default = "60"
    description = "Disk I/O-operation time weighted threshold generating an Alert"
}

variable "base_treshold_disk_pending_operations" {
    default = "10"
    description = "Disk Pending Operations Count threshold generating an Alert. Linux only"
}
variable "base_treshold_disk_iops_throttled" {
    default = "0.05"
    description = "Disk IOPS percentage being throttled over the limit"
}

variable "base_threshold_firewall_dropped_packets" {
    default = "10"
    description = "Delta count of incoming packets dropped by the firewall generating an Alert. Sampled every 60 seconds"
}

# Memorystore (Redis) thresholds
variable "redis_clients_blocked" {
    default = "5"
    description = "Redis - number of blocked clients."
}

variable "redis_clients_connected" {
    default = "200"
    description = "Redis - number of connected clients."
}

variable "redis_connections_accepted" {
    default = "10"
    description = "Redis - trigger alert if total number of connections accepted by the server is less than the threshold"
}

variable "redis_connections_rejected" {
    default = "15"
    description = "Redis - number of connections rejected because of maxclients limit"
}


variable "redis_cpu_utilization" {
    default = "0.8"
    description = "Redis CPU utilization percentage, consumed by the Redis server broken down by System/User and Parent/Child relationship"
}

variable "redis_sys_mem_utilization" {
    default = "0.7"
    description = "Redis memory usage as a ratio of maximum system memory "
}

variable "redis_mem_utilization" {
    default = "0.7"
    description = "Redis memory usage as a ratio of maximum memory"
}

variable "redis_replication_lag" {
    default = "100000000"       # 100Mb
    description = "Redis - the number of bytes that replica is behind"
}


# API thresholds
variable "api_request_latencies" {
    default = "200"
    description = "Distribution of latencies in seconds for non-streaming requests"
}
variable "api_failed_request_pct" {
    default = "0.05"
    description = "Failed requests by API method, in percentage. Unit: percentage"
}

# Pub/Sub thresholds
variable "pubsub_num_retained_acked_messages" {
    default = "1000"
    description = "Number of acknowledged messages retained in a subscription. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_num_undelivered_messages" {
    default = "1000"
    description = "Number of unacknowledged messages (a.k.a. backlog messages) in a subscription. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_oldest_retained_acked_message_age" {
    default = "3600"
    description = "Age (in seconds) of the oldest acknowledged message retained in a subscription. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_oldest_unacked_message_age" {
    default = "3600"
    description = "Age (in seconds) of the oldest unacknowledged message (a.k.a. backlog message) in a subscription. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_pull_request_count" {
    default = "10000"
    description = "Cumulative count of pull requests, grouped by result. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_push_request_count" {
    default = "10000"
    description = "Cumulative count of push attempts, grouped by result. Unlike pulls, the push server implementation does not batch user messages. So each request only contains one user message. The push server retries on errors, so a given user message can appear multiple times. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_num_retained_acked_message_by_region" {
    default = "1000"
    description = "Number of acknowledged messages retained in a topic, broken down by Cloud region. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds. region: The Cloud region in which messages are persisted"
}
variable "pubsub_num_unacked_messages_by_region" {
    default = "1000"
    description = "Number of unacknowledged messages in a topic, broken down by Cloud region. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds. region: The Cloud region in which messages are persisted"
}
variable "pubsub_oldest_retained_acked_message_age_by_region" {
    default = "3600"
    description = "Age (in seconds) of the oldest acknowledged message retained in a topic, broken down by Cloud region. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_oldest_unacked_message_age_by_region" {
    default = "3600"
    description = "Age (in seconds) of the oldest unacknowledged message in a topic, broken down by Cloud region. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "pubsub_send_message_operation_count" {
    default = "10000"
    description = "Cumulative count of publish message operations, grouped by result. For a definition of message operations, see Cloud Pub/Sub metric subscription/mod_ack_deadline_message_operation_count. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds"
}
variable "pubsub_send_request_count" {
    default = "10000"
    description = "Cumulative count of publish requests, grouped by result. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}

# LoadBalancer thresholds
variable "lb_backend_latencies" {
    default = "5000"
    description = "A distribution of the latency calculated from when the request was sent by the proxy to the backend until the proxy received from the backend the last byte of response. Sampled every 60 seconds. After sampling, data is not visible for up to 210 seconds"
}
variable "lb_backend_request_count" {
    default = "300"
    description = "The number of requests served by backends of HTTP/S load balancer. Sampled every 60 seconds. After sampling, data is not visible for up to 210 seconds"
}
variable "lb_frontend_tcp_rtt" {
    default = "5000"
    description = "A distribution of the RTT measured for each connection between client and proxy. Sampled every 60 seconds. After sampling, data is not visible for up to 210 seconds"
}
variable "lb_total_latencies" {
    default = "5000"
    description = "A distribution of the latency calculated from when the request was received by the proxy until the proxy got ACK from client on last response byte. Sampled every 60 seconds. After sampling, data is not visible for up to 210 seconds"
}
variable "lb_l3_internal_backend_latencies" {
    default = "200"
    description = "A distribution of the latency calculated from when the request was sent by the proxy to the backend until the proxy received from the backend the last byte of response. Sampled every 60 seconds. After sampling, data is not visible for up to 210 seconds"
}

variable "lb_l3_tcp_backend_latencies" {
    default = "200"
    description = "A distribution of the latency calculated from when the request was sent by the proxy to the backend until the proxy received from the backend the last byte of response. Sampled every 60 seconds. After sampling, data is not visible for up to 210 seconds"
}

# Storage thresholds
variable "storage_requests_count" {
    default = "1000"
    description = "Delta count of API calls, grouped by the API method name and response code. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "storage_object_count" {
    default = "10000"
    description = "Total number of objects per bucket, grouped by storage class. Values are measured once per day. Sampled every 300 seconds. After sampling, data is not visible for up to 600 seconds"
}

# K8s thresholds
variable "gke_container_cpu" {
    default = "0.8"
    description = "The percentage of the allocated CPU that is currently in use on the container. If no core limit is set, then this metric is not set. Sampled every 60 seconds. After sampling, data is not visible for up to 360 seconds"
}
variable "gke_container_cpu_limit" {
    default = "0.8"
    description = "The fraction of the CPU limit that is currently in use on the instance. This value cannot exceed 1 as usage cannot exceed the limit. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds"
}
variable "gke_container_cpu_request" {
    default = "0"
    description = "The fraction of the requested CPU that is currently in use on the instance. This value can be greater than 1 as usage can exceed the request. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds"
}
variable "gke_container_memory_limit" {
    default = "0.8"
    description = "The fraction of the memory limit that is currently in use on the instance. This value cannot exceed 1 as usage cannot exceed the limit"
}
variable "gke_container_memory_request" {
    default = "0"
    description = "The fraction of the requested memory that is currently in use on the instance. This value can be greater than 1 as usage can exceed the request. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds. memory_type: Either `evictable` or `non-evictable`. Evictable memory is memory that can be easily reclaimed by the kernel, while non-evictable memory cannot"
}
variable "gke_container_restart_count" {
    default = "5"
    description = "Number of times the container has restarted"
}
variable "gke_pod_volume_utilization" {
    default = "0.8"
    description = "The fraction of the volume that is currently being used by the instance. This value cannot be greater than 1 as usage cannot exceed the total available volume space"
}
variable "gke_node_cpu" {
    default = "0.7"
    description = "The fraction of the allocatable CPU that is currently in use on the instance. This value cannot exceed 1 as usage cannot exceed allocatable CPU cores. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds"
}
variable "gke_node_storage_available_pct" {
    default = "0.3"
    description = "Percentage of free ephemeral storage available for allocation"
}
variable "gke_container_storage_utilization_pct" {
    default = "0.8"
    description = "Local ephemeral storage limit utilization percentage. Sampled every 60 seconds"
}
variable "gke_node_memory" {
    default = "0.7"
    description = "The fraction of the allocatable memory that is currently in use on the instance. This value cannot exceed 1 as usage cannot exceed allocatable memory bytes. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds. memory_type: Either `evictable` or `non-evictable`. Evictable memory is memory that can be easily reclaimed by the kernel, while non-evictable memory cannot"
}

# CloudSQL thresholds
variable "database_auto_failover_request_count" {
    default = "1"
    description = "Delta of number of instance auto-failover requests. Sampled every 60 seconds. After sampling, data is not visible for up to 150 seconds"
}
variable "database_instance_cpu" {
    default = "0.8"
    description = "The fraction of the reserved CPU that is currently in use. Sampled every 60 seconds. After sampling, data is not visible for up to 150 seconds"
}
variable "database_instance_disk" {
    default = "0.7"
    description = "The fraction of the disk quota that is currently in use. Sampled every 60 seconds. After sampling, data is not visible for up to 150 seconds"
}
variable "database_instance_memory" {
    default = "0.8"
    description = "The fraction of the memory quota that is currently in use. Sampled every 60 seconds. After sampling, data is not visible for up to 150 seconds"
}
variable "database_mysql_replication_seconds_behind_master" {
    default = "60"
    description = "Number of seconds the read replica is behind its master (approximation). Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds"
}
variable "database_mysql_connections_lower" {
    default = "0"
    description = "Number of connections to the Cloud SQL MySQL instance. Lower threshold. Sampled every 60 seconds. After sampling, data is not visible for up to 150 seconds"
}
variable "database_mysql_connections_upper" {
    default = "200"
    description = "Number of connections to the Cloud SQL MySQL instance. Upper threshold. Sampled every 60 seconds. After sampling, data is not visible for up to 150 seconds"
}
variable "database_pgsql_connections_lower" {
    default = "0"
    description = "Number of connections to the Cloud SQL PostgreSQL instance. Lower threshold. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds. database: Name of the database"
}
variable "database_pgsql_connections_upper" {
    default = "200"
    description = "Number of connections to the Cloud SQL PostgreSQL instance. Upper threshold. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds. database: Name of the database"
}
variable "database_pgsql_replica_byte_lag" {
    default = "100000000"
    description = "Replication lag in bytes. Reported from the master per replica. Sampled every 60 seconds. After sampling, data is not visible for up to 150 seconds"
}
variable "database_mysql_queries" {
    default = "400"
    description = "Delta count of statements executed by the server. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds"
}
variable "database_mysql_questions" {
    default = "150"
    description = "Delta count of statements executed by the server sent by the client. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds"
}
variable "database_pgsql_transaction_count" {
    default = "200"
    description = "Delta count of number of transactions. Sampled every 60 seconds. After sampling, data is not visible for up to 240 seconds. database: Name of the database. transaction_type: transaction_type can be commit or rollback"
}

# BigTable Thresholds
variable "bigtable_cluster_node_count" {
    default = "2"
    description = "Number of nodes in a cluster. Sampled every 60 seconds. After sampling, data is not visible for up to 180 seconds. storage_type: Storage type for the cluster"
}
variable "bigtable_cluster_total_cpu_load" {
    default = "0.8"
    description = "CPU load of a cluster. Sampled every 60 seconds. After sampling, data is not visible for up to 180 seconds"
}
variable "bigtable_cluster_hottest_cpu_load" {
    default = "0.9"
    description = "CPU load of the busiest node in a cluster. Sampled every 60 seconds. After sampling, data is not visible for up to 180 seconds"
}
variable "bigtable_cluster_disk_load" {
    default = "0.7"
    description = "Utilization of HDD disks in a cluster. Sampled every 60 seconds. After sampling, data is not visible for up to 180 seconds"
}
variable "bigtable_cluster_storage_utilization" {
    default = "0.7"
    description = "Storage used as a fraction of total storage capacity. Sampled every 60 seconds. After sampling, data is not visible for up to 180 seconds. storage_type: Storage type for the cluster"
}
variable "bigtable_server_error_count" {
    default = "50"
    description = "Number of server requests for a table that failed with an error. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds. error_code: gRPC Error Code"
}
variable "bigtable_server_latencies" {
    default = "150"
    description = "Distribution of server request latencies for a table. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}
variable "bigtable_server_request_count" {
    default = "500"
    description = "Number of server requests for a table. Sampled every 60 seconds. After sampling, data is not visible for up to 120 seconds"
}

# Uptime Check params
variable "uptime_check_threshold" {
  default = "3"
  description = "Amount of Uptime Check failures across all Regions causing an Alert. Default number of Regions - 6 (3 US, 1 EU, 1 APAC, 1 SA)"
}

variable "uptime_check_proxy" {
    default = "login-proxy.domain.com"
    description = "Uptime proxy-service to call backend health-check with JWT token authorization"
}

variable "uptime_check_proxy_token" {
    default = "SECRET_TOKEN"
    description = "Uptime proxy-service authorization token"
}

variable "uptime_check_match_ok" {
    default = "{\"status\":\"OK\"}"
    description = "Uptime check content matcher for simple OK-status"
}

variable "uptime_check_match_ping" {
    default = "Pong"
    description = "Uptime check content matcher for simple ping-status"
}

variable "uptime_check_match_app_health" {
    default = "\"app\":{\"success\":true,\"message\":\"Application is running\"}"
    description = "Uptime check content matcher for /health_check App status"
}

variable "uptime_check_match_db_health" {
    default = "\"database\":{\"success\":true,\"message\":\"Database is connected\"}"
    description = "Uptime check content matcher for /health_check DB status"
}
