resource "google_bigquery_dataset_iam_member" "product_v1_data_catalog_reader_all_domain" {
  project = var.domain_product_project_id
  dataset_id = var.product_events_v1_dataset
  role = "roles/datacatalog.viewer"
  member = "domain:${var.org_domain}"
}
