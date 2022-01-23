# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy
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

resource "aws_organizations_policy" "restrict_regions" {
  name        = "restrict_regions"
  description = "Restrict regions"
  content     = data.aws_iam_policy_document.restrict_regions.json
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
