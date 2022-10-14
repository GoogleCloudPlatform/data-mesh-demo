output "event_generator_template" {
  value = "gs://${google_storage_bucket_object.event-generator-template.bucket}/${google_storage_bucket_object.event-generator-template.name}"
}

output "producer_dataflow_temp_bucket" {
  value = google_storage_bucket.dataflow-temp.id
}

output "producer_dataflow_sa" {
  value = google_service_account.dataflow_sa.email
}

output "producer_dataflow_region" {
  value = var.region
}

output "producer_input_topic" {
  value = google_pubsub_topic.events_input.id
}

output "producer_input_subscription" {
  value = google_pubsub_subscription.events_input_sub.id
}