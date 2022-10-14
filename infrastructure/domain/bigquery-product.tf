resource "google_bigquery_dataset" "product_v1" {
  project       = var.domain_product_project_id
  dataset_id    = "events_v1"
  friendly_name = "Network events by customers (v1)"
  location      = var.bq_region
  depends_on    = [google_project_service.bigquery_api_product]
}

resource "google_bigquery_dataset_access" "v1_access" {
  project = var.domain_data_project_id
  dataset_id = google_bigquery_dataset.base.dataset_id
  dataset {
    dataset {
      project_id = google_bigquery_dataset.product_v1.project
      dataset_id = google_bigquery_dataset.product_v1.dataset_id
    }
    target_types = ["VIEWS"]
  }
}

resource "google_bigquery_table" "v1_event0" {
  project = var.domain_product_project_id
  dataset_id = google_bigquery_dataset.product_v1.dataset_id
  table_id   = "event0"
  description = "Network events by the customer"
  deletion_protection = false
  view {
    query          = "SELECT request_ts, bytes_sent, bytes_received, src_ip, user_id as customer_id FROM `${google_bigquery_table.events[0].project}.${google_bigquery_table.events[0].dataset_id}.${google_bigquery_table.events[0].table_id}`"
    use_legacy_sql = false
  }
  schema     = <<EOF
[
  {
    "mode": "NULLABLE",
    "name": "request_ts",
    "type": "TIMESTAMP",
    "description": "Event timestamp"
  },
  {
    "mode": "NULLABLE",
    "name": "bytes_sent",
    "type": "INTEGER",
    "description": "Number of bytes sent"
  },
  {
    "mode": "NULLABLE",
    "name": "bytes_received",
    "type": "INTEGER",
    "description": "Number of bytes received"
  },
  {
    "mode": "NULLABLE",
    "name": "src_ip",
    "type": "STRING",
    "description": "IP Address of the sender"
  },
  {
    "mode": "NULLABLE",
    "name": "customer_id",
    "type": "STRING",
    "description": "Customer id"
  }
]
EOF
}

resource "google_bigquery_table" "v1_event0_agg" {
  project = var.domain_product_project_id
  dataset_id = google_bigquery_dataset.product_v1.dataset_id
  table_id   = "event0_distinct_src_ip"
  description = "Distinct IP addresses of the senders"
  deletion_protection = false
  view {
    query          = "SELECT DISTINCT(src_ip) src_ip FROM `${google_bigquery_table.events[0].project}.${google_bigquery_table.events[0].dataset_id}.${google_bigquery_table.events[0].table_id}`"
    use_legacy_sql = false
  }
  schema     = <<EOF
[
  {
    "mode": "NULLABLE",
    "name": "src_ip",
    "type": "STRING",
    "description": "IP Address of the sender"
  }
]
EOF
}