variable "ou1_name" {}

variable "ou1_1_name" {}

variable "ou1_1_account_name" {}

variable "ou1_1_account_email" {}

variable "ou1_2_name" {}

variable "ou1_2_account_name" {}

variable "ou1_2_account_email" {}

variable "restrict_regions" {
  type    = list(string)
  default = ["ap-northeast-1", "ap-northeast-3", ]
}

variable "restrict_source_ips" {}

# https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html
variable "allow_service_prefix_list" {
  type    = list(string)
  default = ["*"] # All Allow
}
