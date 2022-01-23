# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization
# aws organization enable
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"

  enabled_policy_types = [
    "TAG_POLICY",
    "SERVICE_CONTROL_POLICY",
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit
# create ou
## root -> ou1
resource "aws_organizations_organizational_unit" "ou1" {
  name      = var.ou1_name
  parent_id = aws_organizations_organization.org.roots[0].id
}

## root -> ou1 -> ou1-1
resource "aws_organizations_organizational_unit" "ou1-1" {
  name      = var.ou1_1_name
  parent_id = aws_organizations_organizational_unit.ou1.id
}

## root -> ou1 -> ou1-2
resource "aws_organizations_organizational_unit" "ou1-2" {
  name      = var.ou1_2_name
  parent_id = aws_organizations_organizational_unit.ou1.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account
## create ou1-1 account
resource "aws_organizations_account" "ou1-1-account1" {
  name      = var.ou1_1_account_name
  email     = var.ou1_1_account_email
  parent_id = aws_organizations_organizational_unit.ou1-1.id
  # role_name                  = "OrganizationAccountAccessRole"
  # iam_user_access_to_billing = "ALLOW"
}

## create ou1-2 account
resource "aws_organizations_account" "ou1-2-account1" {
  name      = var.ou1_2_account_name
  email     = var.ou1_2_account_email
  parent_id = aws_organizations_organizational_unit.ou1-2.id
  # role_name                  = "OrganizationAccountAccessRole"
  # iam_user_access_to_billing = "ALLOW"
}
