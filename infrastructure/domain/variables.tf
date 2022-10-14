variable "bq_region" {
  type = string
  default = "us"
}
variable "number_of_tables" {
  type = number
  default = 3
}
variable "domain_data_project_id" {
  type = string
}
variable "domain_product_project_id" {
  type = string
}
variable "org_domain" {
  type = string
}