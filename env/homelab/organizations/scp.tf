# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
## リージョン制限
### https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_examples_aws_deny-requested-region.html
data "aws_iam_policy_document" "restrict_regions" {
  statement {
    sid       = "RegionRestriction"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment

# # root
# resource "aws_organizations_policy_attachment" "restrict_regions_root" {
#   policy_id = aws_organizations_policy.restrict_regions.id
#   target_id = aws_organizations_organization.org.roots[0].id
# }

# ou1
resource "aws_organizations_policy_attachment" "restrict_regions_ou1" {
  policy_id = aws_organizations_policy.restrict_regions.id
  target_id = aws_organizations_organizational_unit.ou1.id
}

resource "aws_organizations_policy_attachment" "restrict_source_ips_ou1" {
  policy_id = aws_organizations_policy.restrict_source_ips.id
  target_id = aws_organizations_organizational_unit.ou1.id
}


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
