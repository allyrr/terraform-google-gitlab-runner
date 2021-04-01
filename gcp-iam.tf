# Google SA with:
# - objectAdmin access to the GCS bucket where GitLab's cache reside;
# - objectViewer access to the GCR;
resource "google_service_account" "sa_gitlab" {
  account_id = "sa-${var.gcp_gitlab_resource_prefix}"
  display_name = "sa-${var.gcp_gitlab_resource_prefix}"
  description = "SA for Gitlab Runner cache and GCR ReadOnly access (Pull Container Images)"
}

resource "google_service_account_key" "sa_gitlab" {
  service_account_id = google_service_account.sa_gitlab.name
}

resource "google_storage_bucket_iam_binding" "gitlab_runner" {
  bucket = google_storage_bucket.bucket_cache.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab.email}",
  ]
}

resource "google_project_iam_member" "sa_gitlab" {
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.sa_gitlab.email}"

  condition {
    title       = "GCR Only Access"
    description = "Limits access to Cloud Container Registry only. Managed by Terraform."
    expression  = join( " || ",
      [
      "resource.name.startsWith(\"projects/_/buckets/artifacts.${var.gcp_project_id}.appspot.com\")", 
      "resource.name.startsWith(\"projects/_/buckets/us.artifacts.${var.gcp_project_id}.appspot.com\")",
      "resource.name.startsWith(\"projects/_/buckets/eu.artifacts.${var.gcp_project_id}.appspot.com\")",
      "resource.name.startsWith(\"projects/_/buckets/asia.artifacts.${var.gcp_project_id}.appspot.com\")"
      ]
    )
  }
}
