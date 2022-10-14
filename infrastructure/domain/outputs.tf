output "tagger_sa" {
  value = google_service_account.tagger.email
}

output "product_events_v1_dataset" {
  value = google_bigquery_dataset.product_v1.dataset_id
}

output "product_base_dataset" {
  value = google_bigquery_dataset.base.dataset_id
}

output "product_base_table_event0" {
  value = google_bigquery_table.events[0].table_id
}

output "product_events_v1_event0" {
  value = google_bigquery_table.v1_event0.table_id
}

output "pubsub_schema_web_traffic_stats_v1" {
  value = google_pubsub_schema.web_traffic_stats_v1.name
}

output "product_topic_web_traffic_stats_v1_name" {
  value = google_pubsub_topic.web_traffic_stats_v1.name
}

output "product_topic_web_traffic_stats_v1_id" {
  value = google_pubsub_topic.web_traffic_stats_v1.id
}