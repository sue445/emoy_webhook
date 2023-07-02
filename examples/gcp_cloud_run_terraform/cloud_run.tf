resource "google_cloud_run_service" "app" {
  name     = var.name
  location = var.location

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = 0
        "autoscaling.knative.dev/maxScale" = 1
        "run.googleapis.com/client-name"   = "cloud-console"
      }

      labels = {
        "run.googleapis.com/startupProbeType" = "Default"
      }
    }
    spec {
      container_concurrency = 1
      service_account_name  = google_service_account.app.email

      containers {
        image = "asia-docker.pkg.dev/emoy-webhook/emoy-webhook/app:${var.tag}"

        resources {
          limits = {
            cpu    = "1",
            memory = "128Mi",
          }
        }

        env {
          name  = "SLACK_WEBHOOK_URL"
          value = var.slack_webhook_url
        }

        env {
          name  = "FIRESTORE_COLLECTION"
          value = var.firestore_collection
        }

        dynamic "env" {
          for_each = length(var.sentry_dsn) > 0 ? [var.sentry_dsn] : []

          content {
            name  = "SENTRY_DSN"
            value = var.sentry_dsn
          }
        }

        dynamic "env" {
          for_each = var.extra_env

          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "all_users" {
  for_each = toset([
    "roles/run.invoker",
  ])

  location = google_cloud_run_service.app.location
  project  = google_cloud_run_service.app.project
  service  = google_cloud_run_service.app.name
  role     = each.key
  member   = "allUsers"
}
