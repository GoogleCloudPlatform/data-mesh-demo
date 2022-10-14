resource "google_storage_bucket" "data-generator-template" {
  project = var.domain_data_project_id
  name = "${var.domain_product_project_id}-dataflow-event-generator-template"
  uniform_bucket_level_access = true
  location = var.region
}

resource "google_storage_bucket_object" "event-generator-template" {
  name = "event-generator-template.json"
  bucket = google_storage_bucket.data-generator-template.name
  source = "../event-generator-template.json"
}

resource "google_storage_bucket" "dataflow-temp" {
  project = var.domain_data_project_id
  name = "${var.domain_product_project_id}-dataflow-temp"
  uniform_bucket_level_access = true
  location = var.region
}