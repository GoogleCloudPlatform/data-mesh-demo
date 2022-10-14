output "consumer_sa" {
  value = google_service_account.product_reader.email
}