
resource "google_project" "central_catalog" {
  project_id      = local.catalog_project_id
  folder_id       = var.folder_id
  billing_account = var.billing_id
  name            = "Data Mesh Central Catalog"
}

resource "google_service_account" "central_catalog_admin_sa" {
  account_id = "admin-sa"
  project    = google_project.central_catalog.project_id
}

resource "google_project_iam_member" "admin_sa_catalog_admin" {
  project  = google_project.central_catalog.project_id
  role     = "roles/datacatalog.admin"
  member   = "serviceAccount:${google_service_account.central_catalog_admin_sa.email}"
}

resource "google_project_service" "serviceusage-api" {
  project  = google_project.central_catalog.project_id
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "datacatalog-api" {
  project  = google_project.central_catalog.project_id
  service = "datacatalog.googleapis.com"
  #  disable_dependent_services = false
  #  disable_on_destroy = true
  depends_on = [google_project_service.serviceusage-api]
}