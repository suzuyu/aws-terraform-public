module "total_cost" {
  source                     = "../../../modules/cost_alert"
  limit_amount               = var.total_cost_usd
  subscriber_email_addresses = var.total_cost_alert_destination_email_list
}
