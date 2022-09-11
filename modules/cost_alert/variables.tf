# USD
variable "limit_amount" {
  type    = string
  default = "20" #default 20 USD
}

variable "subscriber_email_addresses" {
  type = list(string) # [xxx@gmail.com, yyy@gmail.com]
}
