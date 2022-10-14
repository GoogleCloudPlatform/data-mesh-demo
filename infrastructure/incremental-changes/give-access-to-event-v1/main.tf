terraform {
  required_providers {
    google = {
      source  = "google"
      version = "~> 4.21.0"
    }
  }
}

provider "google" {
}

resource "google_bigquery_dataset_iam_member" "product_reader_bq_reader_user" {
  dataset_id = "events_v1"
  project = var.domain_product_project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${var.consumer_sa}"
}