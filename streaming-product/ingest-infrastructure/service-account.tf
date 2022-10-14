resource "google_service_account" "dataflow_sa" {
  project = var.domain_data_project_id
  account_id = "dataflow-producer-sa"
}

resource "google_pubsub_subscription_iam_member" "dataflow_input_subscriber" {
  project = var.domain_data_project_id
  subscription = google_pubsub_subscription.events_input_sub.name
  role = "roles/pubsub.subscriber"
  member = "serviceAccount:${google_service_account.dataflow_sa.email}"
}

resource "google_pubsub_subscription_iam_member" "dataflow_input_viewer" {
  project = var.domain_data_project_id
  subscription = google_pubsub_subscription.events_input_sub.name
  role = "roles/pubsub.viewer"
  member = "serviceAccount:${google_service_account.dataflow_sa.email}"
}

resource "google_pubsub_topic_iam_member" "dataflow_product_topic_publisher" {
  project = var.domain_product_project_id
  topic = var.product_topic_web_traffic_stats_v1
  role = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.dataflow_sa.email}"
}

resource "google_bigquery_table_iam_member" "dataflow_bigquery_clicks_table_editor" {
  project = var.domain_data_project_id
  dataset_id = var.product_base_dataset
  table_id = var.product_base_table_clicks
  role = "roles/bigquery.dataOwner"
  member = "serviceAccount:${google_service_account.dataflow_sa.email}"
}

resource "google_project_iam_member" "dataflow_worker" {
  project = var.domain_data_project_id
  role = "roles/dataflow.worker"
  member = "serviceAccount:${google_service_account.dataflow_sa.email}"
}

resource "google_storage_bucket_iam_member" "data_admin" {
  bucket = google_storage_bucket.dataflow-temp.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataflow_sa.email}"
}