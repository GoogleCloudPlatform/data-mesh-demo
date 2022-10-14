resource "google_pubsub_schema" "web_traffic_stats_v1" {
  name = "web_traffic_stats_v1"
  project = var.domain_product_project_id
  type = "PROTOCOL_BUFFER"
  definition = <<EOF
syntax = "proto3";
message Event {
  string country = 1;
  string region = 2;
  string start_ts = 3;
  string end_ts = 4;
  int64 count =5;
}
EOF
}

resource "google_pubsub_topic" "web_traffic_stats_v1" {
  name = "web-traffic-stats-v1"
  project = var.domain_product_project_id

  depends_on = [google_pubsub_schema.web_traffic_stats_v1]
  schema_settings {
    schema = google_pubsub_schema.web_traffic_stats_v1.id
    encoding = "JSON"
  }
}