module "vnet" {
  source     = "../../../../modules/vpc/"
  name       = "homelab-apne1-vpc"
  cidr_block = "172.26.0.0/16"
}
