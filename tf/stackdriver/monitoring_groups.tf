# Stackdriver Resource Groups

# Common labels
resource "google_monitoring_group" "environment" {
  project = "${var.stackdriver_project}"
  display_name = "${var.environment}"
  filter = "resource.metadata.tag.env=\"${var.env}\""
}

# Projects
resource "google_monitoring_group" "projects" {
  project = "${var.stackdriver_project}"
  display_name = "Projects"
  filter = "resource.metadata.cloud_account=starts_with(\"${var.prefix}\")"
}
resource "google_monitoring_group" "core" {
  project = "${var.stackdriver_project}"
  display_name = "Project Core"
  filter = "resource.metadata.cloud_account=\"${var.core_project}\""
  parent_name =  "${google_monitoring_group.projects.name}"
}
resource "google_monitoring_group" "data" {
  project = "${var.stackdriver_project}"
  display_name = "Project Data"
  filter = "resource.metadata.cloud_account=\"${var.data_project}\""
  parent_name =  "${google_monitoring_group.projects.name}"
}
resource "google_monitoring_group" "kube" {
  project = "${var.stackdriver_project}"
  display_name = "Project Kube"
  filter = "resource.metadata.cloud_account=\"${var.kube_project}\""
  parent_name =  "${google_monitoring_group.projects.name}"
}

# Region-Zone
resource "google_monitoring_group" "region" {
  project = "${var.stackdriver_project}"
  display_name = "${title(var.region)}"
  filter = "resource.metadata.region=\"${var.region}\""
}

resource "google_monitoring_group" "zone1" {
  project = "${var.stackdriver_project}"
  display_name = "${title(var.zone1)}"
  filter = "resource.labels.zone=\"${var.zone1}\""
  parent_name =  "${google_monitoring_group.region.name}"
}
resource "google_monitoring_group" "zone2" {
  project = "${var.stackdriver_project}"
  display_name = "${title(var.zone2)}"
  filter = "resource.labels.zone=\"${var.zone2}\""
  parent_name =  "${google_monitoring_group.region.name}"
}
resource "google_monitoring_group" "zone3" {
  project = "${var.stackdriver_project}"
  display_name = "${title(var.zone3)}"
  filter = "resource.labels.zone=\"${var.zone3}\""
  parent_name =  "${google_monitoring_group.region.name}"
}

# VMs
resource "google_monitoring_group" "gce" {
  project = "${var.stackdriver_project}"
  display_name = "VMs"
  filter = "resource.type=\"gce_instance\""
}

resource "google_monitoring_group" "nat" {
  project = "${var.stackdriver_project}"
  display_name = "NAT"
  filter = "resource.metadata.tag.component=\"nat\""
  parent_name = "${google_monitoring_group.gce.name}"
}
resource "google_monitoring_group" "bastion" {
  project = "${var.stackdriver_project}"
  display_name = "Bastion"
  filter = "resource.metadata.tag.component=\"bastion\""
  parent_name = "${google_monitoring_group.gce.name}"
}

# Kubernetes
resource "google_monitoring_group" "k8s_beta" {
  project = "${var.stackdriver_project}"
  display_name = "Kubernetes (beta)"
  filter = "resource.type=starts_with(\"k8s\")"
}
resource "google_monitoring_group" "gke" {
  project = "${var.stackdriver_project}"
  display_name = "Kubernetes"
  filter = "resource.type=\"gke_container\""
}
resource "google_monitoring_group" "kube_nodes" {
  project = "${var.stackdriver_project}"
  display_name = "Kube Nodes"
  filter = "resource.metadata.tag:goog-gke-node"
  parent_name = "${google_monitoring_group.gce.name}"
}

# Databases
resource "google_monitoring_group" "postgres" {
  project = "${var.stackdriver_project}"
  display_name = "PostgreSQL"
  filter = "metadata.user_labels.component=\"postgres\""
}
resource "google_monitoring_group" "mysql" {
  project = "${var.stackdriver_project}"
  display_name = "MySQL"
  filter = "metadata.user_labels.component=\"mysql\""
}
resource "google_monitoring_group" "mysql_master" {
  project = "${var.stackdriver_project}"
  display_name = "MySQL Master"
  filter = "metadata.user_labels.role=\"master\""
  parent_name = "${google_monitoring_group.mysql.name}"
}
resource "google_monitoring_group" "mysql_slave" {
  project = "${var.stackdriver_project}"
  display_name = "MySQL Slave"
  filter = "metadata.user_labels.role=\"slave\""
  parent_name = "${google_monitoring_group.mysql.name}"
}
resource "google_monitoring_group" "mysql_failover" {
  project = "${var.stackdriver_project}"
  display_name = "MySQL Failover"
  filter = "metadata.user_labels.role=\"failover\""
  parent_name = "${google_monitoring_group.mysql.name}"
}

resource "google_monitoring_group" "pubsub" {
  project = "${var.stackdriver_project}"
  display_name = "Pub-Sub"
  filter = "resource.type=\"pubsub_topic\""
}

resource "google_monitoring_group" "bigtable" {
  project = "${var.stackdriver_project}"
  display_name = "BigTable"
  filter = "resource.type=\"bigtable_cluster\""
}
