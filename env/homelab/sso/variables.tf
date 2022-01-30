# variable "management_account_id" {
#   type = string
# }

variable "infra_account_ids" {
  type = list(string)
}

variable "service_account_ids" {
  type = list(string)
}
