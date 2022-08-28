variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
  default     = "" # TODO: Edit here
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

variable "env" {
  type = list(object({
    name  = string
    value = string
  }))

  description = "Cloud Run app environment variables"

  default = [
    {
      name  = "SLACK_WEBHOOK_URL",
      value = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX", # TODO: Edit here
    },
  ]
}
