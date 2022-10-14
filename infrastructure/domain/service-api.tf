resource "google_project_service" "bigquery_api_data" {
  project = var.domain_data_project_id
  service = "bigquery.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "bigquery_api_product" {
  project = var.domain_product_project_id
  service = "bigquery.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "datacatalog_api_data" {
  project = var.domain_data_project_id
  service = "datacatalog.googleapis.com"
  depends_on = [
    google_project_service.bigquery_api_data]
}

resource "google_project_service" "datacatalog_api_product" {
  project = var.domain_product_project_id
  service = "datacatalog.googleapis.com"
}
