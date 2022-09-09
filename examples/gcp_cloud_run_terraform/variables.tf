variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
}

variable "tag" {
  type        = string
  description = "docker image tag for emoy_webhook"
  default     = "latest"
}

variable "name" {
  type        = string
  description = "Cloud Run app name"
  default     = "emoy-webhook"
}

variable "location" {
  type        = string
  description = "Cloud Run app location"
  default     = "us-central1"
}

variable "slack_webhook_url" {
  type        = string
  description = "Incoming Webhook URL"
}

variable "firestore_collection" {
  type        = string
  description = "Firestore collection name for notification caching"
  default     = "emoy_webhook_cache"
}

variable "sentry_dsn" {
  type        = string
  description = "Sentry DSN"
  default     = ""
}

variable "extra_env" {
  type = list(object({
    name  = string
    value = string
  }))

  description = "Cloud Run app environment variables"
  default     = []
}
