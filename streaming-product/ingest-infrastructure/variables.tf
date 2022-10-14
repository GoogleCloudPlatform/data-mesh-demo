variable "domain_product_project_id" {
  type = string
}

variable "domain_data_project_id" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "product_base_dataset" {
  type = string
}

variable "product_base_table_clicks" {
  default = "clicks"
  type = string
}

variable "product_topic_web_traffic_stats_v1" {
 type = string
}