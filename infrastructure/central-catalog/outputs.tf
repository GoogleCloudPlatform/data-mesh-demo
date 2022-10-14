output "tag_template_id_product" {
  value = google_data_catalog_tag_template.product.id
}

output "tag_template_name_product" {
  value = google_data_catalog_tag_template.product.tag_template_id
}

output "tag_template_id_freshness" {
  value = google_data_catalog_tag_template.freshness.id
}

output "tag_template_name_freshness" {
  value = google_data_catalog_tag_template.freshness.tag_template_id
}

output "tag_template_id_well_known_id" {
  value = google_data_catalog_tag_template.well_known_id.id
}

output "tag_template_name_well_known_id" {
  value = google_data_catalog_tag_template.well_known_id.tag_template_id
}

output "tag_template_id_pubsub_topic_product" {
  value = google_data_catalog_tag_template.pubsub_topic_product.id
}

output "tag_template_name_pubsub_topic_product" {
  value = google_data_catalog_tag_template.pubsub_topic_product.tag_template_id
}