resource "google_service_account" "tagger" {
  account_id = "tagger"
  project    = var.domain_product_project_id
}

resource "google_project_iam_member" "tagger-datacatalog-tagEditor" {
  project = var.domain_product_project_id
  member  = "serviceAccount:${google_service_account.tagger.email}"
  role    = "roles/datacatalog.tagEditor"
}

# Need to give set permissions related to the data catalog on the dataset
resource "google_project_iam_member" "tagger-data-owner" {
  project = var.domain_product_project_id
  member  = "serviceAccount:${google_service_account.tagger.email}"
  role    = "roles/bigquery.dataOwner"
}

resource "google_project_iam_member" "tagger-datacatalog-viewer" {
project = var.domain_product_project_id
member = "serviceAccount:${google_service_account.tagger.email}"
role = "roles/datacatalog.viewer"
}
