AWS Cost Budget 管理
====
総額予算から下記基準でアラートをメールに送信する

一括請求を実施している場合は、管理アカウントで実施する

パラメータは`./terraform.tfvars` 内の `total_cost_usd` に予算総額(ドル)、
`total_cost_alert_destination_email_list` にアラート先メールのリストを記載する

- 実測
  - 50%
  - 90%
  - 100%
  - 150%
  - 200%
- 予測
  - 75%
  - 100%
  - 150%
  - 200%
