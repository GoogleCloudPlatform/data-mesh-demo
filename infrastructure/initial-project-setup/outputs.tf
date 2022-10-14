output "consumer_project_id" {
  value = google_project.consumer.project_id
}
output "domain_data_project_id" {
  value = google_project.domain_data.project_id
}
output "domain_product_project_id" {
  value = google_project.domain_product.project_id
}
output "central_catalog_project_id" {
  value = google_project.central_catalog.project_id
}
output "central_catalog_admin_sa" {
  value = google_service_account.central_catalog_admin_sa.email
}