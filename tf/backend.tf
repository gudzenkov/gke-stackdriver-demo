  terraform {
    backend "gcs" {
      prefix  = "terraform/state/stackdriver"
      project = "tf-admin-104569"
      bucket  = "tf-state-104569"
    }
  }
