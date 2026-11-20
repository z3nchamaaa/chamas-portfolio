terraform {
  required_version = ">= 1.10"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.29"
    }
  }

  # state は Cloudflare R2 (S3 互換) に置く。接続情報は backend.hcl で渡す
  #   terraform init -backend-config=../backend.hcl
  backend "s3" {
    key = "cloudflare/terraform.tfstate"
  }
}

provider "cloudflare" {
  # 認証は環境変数 CLOUDFLARE_API_TOKEN から読む
}
