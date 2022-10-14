resource "google_pubsub_topic" "events_input" {
  name = "events-input"
  project = var.domain_data_project_id
}

resource "google_pubsub_subscription" "events_input_sub" {
  project = var.domain_data_project_id
  name  = "events-input-sub"
  topic = google_pubsub_topic.events_input.name

  ack_deadline_seconds = 60
}
