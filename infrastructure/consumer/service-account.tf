resource "google_service_account" "product_reader" {
  account_id = "product-reader"
}

resource "google_project_iam_member" "product_reader_bq_job_user" {
  project = var.consumer_project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.product_reader.email}"
}