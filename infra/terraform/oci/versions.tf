terraform {
  required_version = ">= 1.10"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.14"
    }
  }

  backend "s3" {
    key = "oci/terraform.tfstate"
  }
}

provider "oci" {
  # 認証は ~/.oci/config (API キー) を使う。CI では TF_VAR_* と環境変数で渡す
  region              = var.region
  config_file_profile = var.oci_profile
}
