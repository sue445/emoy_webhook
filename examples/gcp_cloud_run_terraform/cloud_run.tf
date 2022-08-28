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
    }
    spec {
      container_concurrency = 1

      containers {
        image = "asia-docker.pkg.dev/emoy-webhook/emoy-webhook/app:latest"

        resources {
          limits = {
            cpu    = "1",
            memory = "128Mi",
          }
        }

        dynamic "env" {
          for_each = var.env

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
