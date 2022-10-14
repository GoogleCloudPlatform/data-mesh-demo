resource "google_pubsub_subscription" "web_traffic_stats_v1_sub" {
  project = var.consumer_project_id
  name  = "web-traffic-stats-v1-sub"
  topic = var.product_topic_web_traffic_stats_v1_id

  ack_deadline_seconds = 60
}
