# Dataset tagging
resource "google_data_catalog_tag" "dataset_event_v1_product_tag" {
  parent   = var.catalog_entry_id_dataset
  template = var.tag_template_id_product
  fields {
    field_name = "data_domain"
    enum_value = "Operations"
  }

  fields {
    field_name = "data_subdomain"
    enum_value = "Product_Events"
  }

  fields {
    field_name   = "data_product_name"
    string_value = "Customer Network Events v1"
  }

  fields {
    field_name   = "data_product_description"
    string_value = "Customer network events, including process names, source and destination IP addresses"
  }

  fields {
    field_name   = "business_owner"
    string_value = "network-events-product-owner@example.com"
  }

  fields {
    field_name   = "technical_owner"
    string_value = "network-events-product-tech@example.com"
  }

  fields {
    field_name   = "number_data_resources"
    double_value = 2
  }


  fields {
    field_name   = "documentation_link"
    string_value = "https://network-events.wiki.corp/v1/overview"
  }

  fields {
    field_name   = "access_request_link"
    string_value = "https://network-events.wiki.corp/v1/access"
  }

  fields {
    field_name = "data_product_status"
    enum_value = "RELEASED"
  }

  fields {
    field_name     = "last_modified_date"
    timestamp_value = "2022-07-05T07:44:12Z"
  }

}

# Table tagging
#resource "google_data_catalog_tag" "table_event_v1_event0_product_tag" {
#  parent = var.catalog_entry_id_table
#  template = var.tag_template_id_product
#  fields {
#    field_name   = "name"
#    string_value = "Customer network events"
#  }
#
#  fields {
#    field_name   = "description"
#    string_value = "Customer network events captured by the appliance. Version 1"
#  }
#
#  fields {
#    field_name   = "documentation_url"
#    string_value = "https://wiki.example.com/network-events-product"
#  }
#
#  fields {
#    field_name   = "business_owner"
#    string_value = "events-product-owners@example.com"
#  }
#
#  fields {
#    field_name   = "technical_contact"
#    string_value = "events-tech@example.com"
#  }
#
#  fields {
#    field_name = "domain"
#    enum_value = "ONLINE_SALES"
#  }
#
#  fields {
#    field_name = "status"
#    enum_value = "PRODUCTION"
#  }
#}

resource "google_data_catalog_tag" "dataset_event_v1_freshness_tag" {
  parent   = var.catalog_entry_id_table
  template = var.tag_template_id_freshness
  fields {
    field_name   = "expected_freshness"
    string_value = "Typically 2 minutes"
  }
  fields {
    field_name   = "freshness_endpoint"
    string_value = "https://events-product.corp/freshness/events_v1/events0"
  }

  fields {
    field_name   = "sla_max_delay_sec"
    double_value = "300"
  }

  fields {
    field_name   = "sla_percentage"
    double_value = "95"
  }

  fields {
    field_name = "sla_period"
    enum_value = "MONTH"
  }
}

# Table column tagging
resource "google_data_catalog_tag" "dataset_event_v1_well_known_id_tag" {
  parent   = var.catalog_entry_id_table
  template = var.tag_template_id_well_known_id
  column   = "customer_id"

  fields {
    field_name = "id"
    enum_value = "CUSTOMER_ID"
  }
  fields {
    field_name   = "notes"
    string_value = "Only the customer ids in X200* to Y300* range can appear in this column."
  }
}

# Topic tagging
resource "google_data_catalog_tag" "events_v1_product" {
  parent = var.catalog_entry_id_web_traffic_stats_v1_topic
  template = var.tag_template_id_pubsub_topic_product

  fields {
    field_name = "description"
    string_value = "Web traffic by location statistics v1"
  }

  fields {
    field_name = "schema_ref"
    string_value = "https://console.cloud.google.com/cloudpubsub/schema/detail/${var.pubsub_schema_web_traffic_stats_v1}?project=${var.domain_product_project_id}"
  }
}

resource "google_data_catalog_tag" "topic_event_v1_product_tag" {
  parent   = var.catalog_entry_id_web_traffic_stats_v1_topic
  template = var.tag_template_id_product
  fields {
    field_name = "data_domain"
    enum_value = "Operations"
  }

  fields {
    field_name = "data_subdomain"
    enum_value = "Product_Events"
  }

  fields {
    field_name   = "data_product_name"
    string_value = "Web traffic statistics v1"
  }

  fields {
    field_name   = "data_product_description"
    string_value = "15 minute web click counts per region generated every 5 minutes"
  }

  fields {
    field_name   = "business_owner"
    string_value = "network-events-product-owner@example.com"
  }

  fields {
    field_name   = "technical_owner"
    string_value = "network-events-product-tech@example.com"
  }


  fields {
    field_name   = "documentation_link"
    string_value = "https://streaming-network-events.wiki.corp/v1/overview"
  }

  fields {
    field_name   = "access_request_link"
    string_value = "https://streaming-network-events.wiki.corp/v1/access"
  }

  fields {
    field_name = "data_product_status"
    enum_value = "RELEASED"
  }

  fields {
    field_name     = "last_modified_date"
    timestamp_value = "2022-07-06T07:55:12Z"
  }

}