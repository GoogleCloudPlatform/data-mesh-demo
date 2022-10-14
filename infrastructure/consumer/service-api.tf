resource "google_project_service" "bigquery-api" {
  service = "bigquery.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "datacatalog-api" {
  service = "datacatalog.googleapis.com"
}

