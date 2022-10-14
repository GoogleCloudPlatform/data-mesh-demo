resource "google_project_service" "dataflow-api" {
  project = var.domain_data_project_id
  service = "dataflow.googleapis.com"
}