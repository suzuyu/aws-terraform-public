# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
## リージョン制限
### https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_examples_aws_deny-requested-region.html
data "aws_iam_policy_document" "restrict_regions" {
  statement {
    sid       = "RegionRestriction" # https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_sid.html
    effect    = "Deny"              # https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_effect.html
    resources = ["*"]               # https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_resource.html
    not_actions = [                 # https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_notaction.html
      "cloudfront:*",               # https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazoncloudfront.html
      "iam:*",
      "route53:*",
      "support:*",
      "directconnect:*",
    ]

    # https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_condition.html
    # https://docs.aws.amazon.com/ja_jp/ja_jp/IAM/latest/UserGuide/reference_policies_condition-keys.html
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"

      values = var.restrict_regions
    }
  }
}

## 送信元制限
### https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_examples_aws_deny-ip.html
data "aws_iam_policy_document" "restrict_source_ips" {
  statement {
    sid       = "SourceIpRestriction"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"

      values = var.restrict_source_ips
    }

    condition {
      test     = "Bool"
      variable = "aws:ViaAWSService"

      values = ["false"]
    }
  }
}

## 利用サービス制限
### https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/access_policies_boundaries.html
data "aws_iam_policy_document" "restrict_aws_services" {
  statement {
    sid       = "AwsServiceRestriction"
    effect    = "Deny"
    resources = ["*"]
    not_actions = concat([
      "iam:*",     # Default Allow
      "support:*", # Default Allow
      ],
      var.allow_service_prefix_list
    )
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy
## リージョン制限
resource "aws_organizations_policy" "restrict_regions" {
  name        = "restrict_regions"
  description = "Restrict regions"
  content     = data.aws_iam_policy_document.restrict_regions.json
}

## 送信元制限
resource "aws_organizations_policy" "restrict_source_ips" {
  name        = "restrict_source_ips"
  description = "Restrict Source IPs"
  content     = data.aws_iam_policy_document.restrict_source_ips.json
}

## 利用サービス制限
resource "aws_organizations_policy" "restrict_aws_services" {
  name        = "restrict_aws_services"
  description = "Restrict AWS Services"
  content     = data.aws_iam_policy_document.restrict_aws_services.json
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment

# # root
# resource "aws_organizations_policy_attachment" "restrict_regions_root" {
#   policy_id = aws_organizations_policy.restrict_regions.id
#   target_id = aws_organizations_organization.org.roots[0].id
# }

# ou1
## リージョン制限 ou1
resource "aws_organizations_policy_attachment" "restrict_regions_ou1" {
  policy_id = aws_organizations_policy.restrict_regions.id
  target_id = aws_organizations_organizational_unit.ou1.id
}

## 送信元制限 ou1
resource "aws_organizations_policy_attachment" "restrict_source_ips_ou1" {
  policy_id = aws_organizations_policy.restrict_source_ips.id
  target_id = aws_organizations_organizational_unit.ou1.id
}

# ## 利用サービス制限 ou1
# resource "aws_organizations_policy_attachment" "restrict_aws_services_ou1" {
#   policy_id = aws_organizations_policy.restrict_aws_services.id
#   target_id = aws_organizations_organizational_unit.ou1.id
# }


# # ou1-1
# resource "aws_organizations_policy_attachment" "restrict_regions_ou1-1" {
#   policy_id = aws_organizations_policy.restrict_regions.id
#   target_id = aws_organizations_organizational_unit.ou1-1.id
# }

# # ou1-1 account
# resource "aws_organizations_policy_attachment" "restrict_regions_ou1-1" {
#   policy_id = aws_organizations_policy.restrict_regions.id
#   target_id = aws_organizations_account.ou1-1-account1.id
# }

# # ou1-2
# resource "aws_organizations_policy_attachment" "restrict_regions_ou1-2" {
#   policy_id = aws_organizations_policy.restrict_regions.id
#   target_id = aws_organizations_organizational_unit.ou1-2.id
# }

# # ou1-2 account
# resource "aws_organizations_policy_attachment" "restrict_regions_ou1-2" {
#   policy_id = aws_organizations_policy.restrict_regions.id
#   target_id = aws_organizations_account.ou1-2-account1.id
# }

## 利用サービス制限 ou1-2
resource "aws_organizations_policy_attachment" "restrict_aws_services_ou1-2" {
  policy_id = aws_organizations_policy.restrict_aws_services.id
  target_id = aws_organizations_account.ou1-2-account1.id
}
