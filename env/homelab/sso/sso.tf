locals {
  # https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/access_policies_job-functions.html
  permission = {
    AdministratorAccess  = "AdministratorAccess"
    NetworkAdministrator = "job-function/NetworkAdministrator"
    SystemAdministrator  = "job-function/SystemAdministrator"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment
data "aws_ssoadmin_instances" "main" {}

resource "aws_ssoadmin_permission_set" "main" {
  for_each     = local.permission
  name         = each.key
  instance_arn = tolist(data.aws_ssoadmin_instances.main.arns)[0]
}

resource "aws_ssoadmin_managed_policy_attachment" "AdministratorAccess" {
  for_each           = aws_ssoadmin_permission_set.main
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/${local.permission[each.key]}"
  permission_set_arn = each.value.arn
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment
## admins
data "aws_identitystore_group" "admins" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "admins"
  }
}

locals {
  all_account_ids = concat(var.infra_account_ids, var.service_account_ids)
}

resource "aws_ssoadmin_account_assignment" "admins" {
  count              = length(local.all_account_ids)
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.main["AdministratorAccess"].arn

  principal_id   = data.aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = local.all_account_ids[count.index]
  target_type = "AWS_ACCOUNT"
}

## infra
data "aws_identitystore_group" "infra" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "infra-admins"
  }
}

resource "aws_ssoadmin_account_assignment" "infra-admins" {
  # count              = length(local.infra_account_ids)
  count              = length(local.all_account_ids)
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.main["NetworkAdministrator"].arn

  principal_id   = data.aws_identitystore_group.infra.group_id
  principal_type = "GROUP"

  # target_id   = local.infra_account_ids[count.index]
  target_id   = local.all_account_ids[count.index]
  target_type = "AWS_ACCOUNT"
}


## developers
data "aws_identitystore_group" "developers" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "developers"
  }
}

resource "aws_ssoadmin_account_assignment" "developers" {
  count              = length(var.service_account_ids)
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.main["SystemAdministrator"].arn

  principal_id   = data.aws_identitystore_group.developers.group_id
  principal_type = "GROUP"

  target_id   = var.service_account_ids[count.index]
  target_type = "AWS_ACCOUNT"
}

