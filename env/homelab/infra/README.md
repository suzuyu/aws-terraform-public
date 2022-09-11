[作成中] AWS Network / VPC, VPN, Transit Gateway
===

AWS 上で 1つの VPC を作成して オンプレとの VPN を実施し、他の AWS Accout からもその VPN に重畳してオンプレと通信できる環境を作成する

また、複数ある AWS Account の VPC 間を疎通できるネットワークも作成する

## AWS Account
`../organizations/` で作成した `infra` を使用する

## Terraform アカウント
`infra` の AWS Account の IAM で Terraform アカウントを作成する(作成方法は `~/aws-terraform-public/README.md` を参照)

アクセスキーの ID と Secret は `~/.aws/credentials` に追加する

```~/.aws/credentials
[infra]
aws_access_key_id=1111111111YYYYYYYYYY
aws_secret_access_key=11111111111111111111111111111111111/BBBB
```

## Terraform Backend S3
top の README.md 記載があるものに `--profile infra` をつけたもの

```sh:create-bucket.sh
AWS_BUCKET_NAME="tfstate-bucket"$RANDOM
AWS_LOCATION="ap-northeast-1"
aws s3api create-bucket \
--region $AWS_LOCATION \
--create-bucket-configuration LocationConstraint=$AWS_LOCATION \
--bucket $AWS_BUCKET_NAME \
--profile infra
```

S3 のバージョニング設定を有効化する

```sh:set-bucket-versioning.sh
aws s3api put-bucket-versioning \
--bucket $AWS_BUCKET_NAME \
--versioning-configuration Status=Enabled \
--profile infra
```

S3 の暗号化を設定する

```sh:set-bucket-encryption.sh
aws s3api put-bucket-encryption \
--bucket $AWS_BUCKET_NAME \
--profile infra \
--server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'
```

S3 の公開アクセスを禁止する

```sh:set-bucket-block-publicaccess.sh
aws s3api put-public-access-block \
--profile infra \
--bucket $AWS_BUCKET_NAME \
--public-access-block-configuration '{
  "BlockPublicAcls": true,
  "IgnorePublicAcls": true,
  "BlockPublicPolicy": true,
  "RestrictPublicBuckets": true
}'
```


## 概要図
T.B.D.



## 参考

https://docs.aws.amazon.com/ja_jp/vpc/latest/tgw/what-is-transit-gateway.html

https://aws.amazon.com/jp/transit-gateway/pricing/

https://aws.amazon.com/jp/blogs/news/aws-transit-gateway-with-shared-directconnect/

## 注意
terraform 実行前に環境変数があると profile より優先されてしまうので、環境変数を消しておく

```sh
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
```

上記をやらないと `terraform init` 実施時にエラーが出る (TF_LOG=DEBUGでデバッグすると環境変数側が優先されていることが見える)

```txt:エラーログ
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Error refreshing state: AccessDenied: Access Denied
        status code: 403, request id: xxxxxxxxxxx, host id: xxxxxxxxxxxxxxxxxxx...
```
