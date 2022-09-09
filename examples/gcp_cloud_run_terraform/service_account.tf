resource "google_service_account" "app" {
  account_id   = var.name
  display_name = var.name
}

resource "google_project_iam_member" "app" {
  for_each = toset([
    "roles/datastore.user",
    "roles/secretmanager.secretAccessor",
  ])

  project = var.gcp_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.app.email}"
}
