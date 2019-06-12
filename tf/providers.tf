# Project should be set either for Provider or via GOOGLE_PROJECT env variable
provider "google"       {
  version = "~> 1.20",
  project = "${var.stackdriver_project}"
}
provider "google-beta"  {version = "~> 2.2"}

provider "null"         {version = "~> 2.1"}
provider "random"       {version = "~> 2.1"}
provider "template"     {version = "~> 2.1"}
