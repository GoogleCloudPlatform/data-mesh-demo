resource "google_bigquery_dataset" "base" {
  project = var.domain_data_project_id
  dataset_id = "base"
  friendly_name = "All the data for the domain. Complex domains will have multiple base datasets"
  location = var.bq_region
  depends_on = [google_project_service.bigquery_api_data]
}

resource "google_bigquery_table" "events" {
  project = var.domain_data_project_id
  count = var.number_of_tables
  deletion_protection = false
  dataset_id = google_bigquery_dataset.base.dataset_id
  table_id = "events${count.index}"
  description = "All events"
  time_partitioning {
    type = "DAY"
    field = "request_ts"
  }
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "request_ts",
    "type": "TIMESTAMP"
  },
  {
    "mode": "REQUIRED",
    "name": "bytes_sent",
    "type": "INTEGER"
  },
  {
    "mode": "NULLABLE",
    "name": "random_id",
    "type": "BIGNUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "bytes_received",
    "type": "INTEGER"
  },
  {
    "mode": "NULLABLE",
    "name": "dst_hostname",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "dst_ip",
    "type": "STRING",
    "maxLength": "15"
  },
  {
    "mode": "REQUIRED",
    "name": "dst_port",
    "type": "INTEGER"
  },
  {
    "mode": "NULLABLE",
    "name": "src_ip",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "user_id",
    "type": "STRING",
    "policyTags": {
     "names": ["${google_data_catalog_policy_tag.customer_id.id}"]
   }
  },
  {
    "mode": "NULLABLE",
    "name": "process_name",
    "type": "STRING"
  }
]
EOF
}


resource "google_bigquery_table" "clicks" {
  project = var.domain_data_project_id
  deletion_protection = false
  dataset_id = google_bigquery_dataset.base.dataset_id
  table_id = "clicks"
  description = "Web site clicks"
  time_partitioning {
    type = "DAY"
    field = "request_time"
  }
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "request_time",
    "type": "TIMESTAMP"
  },
  {
    "mode": "REQUIRED",
    "name": "url",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "ip_addr",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "source_country",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "source_region",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "customer_id",
    "type": "STRING",
    "policyTags": {
     "names": ["${google_data_catalog_policy_tag.customer_id.id}"]
   }
  }
]
EOF
}
