variable "name" {
  default = ""
}

variable "host" {
  description = "Uptime check host"
}

variable "timeout" {
  default = "10s"
  description = "The maximum amount of time to wait for the request to complete (must be between 1 and 60 seconds)"
}

variable "period" {
  default = "60s"
  description = "How often, in seconds, the Uptime check is performed. Currently, the only supported values are N*60s"
}

variable "port" {
  default = 0
  description = "The port to the page to run the check against. Optional (defaults to 80 without SSL, or 443 with SSL)."
}

variable "use_ssl" {
  default = "true"
  description = "If true, use HTTPS instead of HTTP to run the check"
}

variable "path" {
  default = "/"
  description = "The path to the page to run the check against"
}

variable "match" {
  default = ""
  description = "The expected content on the page the check is run against."
}

variable "headers" {
  default = {
    cache-control = "no-cache"
  }
  description = "The list of headers to send as part of the uptime check request"
}

variable "content_type" {
  default = "application/json"
  description = "Default Content-Type for request"
}

variable "content_accept" {
  default = "application/json"
  description = "Default Content-Type for response"
}

variable "auth_token" {
  default = ""
  description = "Authorization token to be passed for upstream host"
}

variable "mask_headers" {
  default = false
  description = "Boolean specifiying whether to encrypt the header information. Encryption should be specified for any headers related to authentication that you do not wish to be seen"
}

variable "alerting" {
  default = false
  description = "Enables Alert Policy creation for this Uptime check"
}

variable "policy_name" {
  default = ""
  description = "Uptime Alert Policy name. Setting this variable allows creating multipple Uptime Checks but group them into single Alert Policy"
}

variable "notifications" {
  type = "list"
  default = []
  description = "Set NotificationChannel for Alert Policy. Channels include email, SMS, and third-party messaging applications."
}

variable "alert_duration" {
  default = "180s"
  description = "The time that a time series must fail to trigger an alert"
}

variable "alignment_period" {
    default = "60s"
    description = "After per-time series alignment, each time series will contain data points only on the period boundaries. Min 60s"
}

variable "alert_threshold" {
  default = "3"
  description = "Amount of Uptime Check failures across all Regions causing an Alert. Default number of Regions - 6 (3 US, 1 EU, 1 APAC, 1 SA)"
}
