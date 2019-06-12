# Uptime Health-checks with individual Alert Policy

# Endpoints with simple OK-status with no auth required
module "OIDC" {
  source          = "modules/uptime_check"
  name            = "oidc.${var.domain}"
  host            = "oidc.${var.domain}"
  path            = "/status"
  match           = "${var.uptime_check_match_ok}"
  alerting        = true                              # If set, will create individual Alert Policy for this Uptime check
  policy_name     = "Uptime OIDC"                     # If set, will create individual Alert Policy with specific name
  timeout         = "10s"                             # Overwrite default Uptime check timeout
  period          = "60s"                             # Overwrite default Uptime check period
  alert_duration  = "120s"                            # Overwrite default Alert duration
  alert_threshold = "3"                               # 3 of 6 world-wide locations should fail to trigger an alert
  notifications   = "${local.notification_channels}"
}

# Login-proxy for JWT token authorization
module "Login-proxy" {
  source        = "modules/uptime_check"
  name          = "${var.api_gateway}/login"
  host          = "${var.uptime_check_proxy}"
  match         = "${var.uptime_check_match_ok}"
  path          = "/"
  auth_token    = "${var.uptime_check_proxy_token}"
  policy_name   = "Uptime Login"
  notifications = "${local.notification_channels}"
}
