resource "google_firestore_field" "cache_expires_at" {
  collection = var.firestore_collection
  field      = "expires_at"

  # Enable TTL
  ttl_config {
  }
}
