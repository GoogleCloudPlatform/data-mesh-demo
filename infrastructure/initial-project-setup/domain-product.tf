
resource "google_project" "domain_product" {
  project_id      = local.domain_product_project_id
  folder_id       = var.folder_id
  billing_account = var.billing_id
  name            = "Domain Product"
}