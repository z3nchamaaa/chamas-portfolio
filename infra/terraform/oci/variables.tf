variable "region" {
  description = "OCI のホームリージョン (Always Free の A1 はホームリージョンでのみ作れる)"
  type        = string
  default     = "ap-tokyo-1"
}

variable "oci_profile" {
  type    = string
  default = "DEFAULT"
}

variable "compartment_id" {
  description = "リソースを置くコンパートメントの OCID"
  type        = string
}

variable "ssh_public_key" {
  description = "初期セットアップ用の SSH 公開鍵"
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = <<-EOT
    SSH を許可する接続元。普段は空にして Tailscale 経由で入る。
    Tailscale を入れる前の初回だけ自宅の IP を入れる。
  EOT
  type        = list(string)
  default     = []
}

# Always Free の範囲: A1 は合計 4 OCPU / 24 GB、ブートボリュームは合計 200 GB まで
variable "ocpus" {
  type    = number
  default = 4
}

variable "memory_gb" {
  type    = number
  default = 24
}

variable "boot_volume_gb" {
  type    = number
  default = 100
}
