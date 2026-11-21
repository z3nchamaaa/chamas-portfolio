variable "account_id" {
  description = "Cloudflare のアカウント ID"
  type        = string
}

variable "zone_id" {
  description = "独自ドメインのゾーン ID"
  type        = string
}

variable "zone_name" {
  description = "独自ドメイン (例: example.com)"
  type        = string
}

variable "worker_name" {
  description = "ポートフォリオの Worker 名。apps/web/wrangler.jsonc の name と合わせる"
  type        = string
  default     = "portfolio-web"
}

variable "homelab_services" {
  description = <<-EOT
    Cloudflare Tunnel で公開する自宅ラボのサービス。
    キーはサブドメイン、値は cloudflared から見た接続先。
  EOT
  type        = map(string)
  default = {
    # "demo"   = "http://demo.homelab.internal:8080"
    # "status" = "http://uptime-kuma:3001"
  }
}

variable "access_enabled" {
  description = "公開前は true にしてサイト全体を Cloudflare Access で保護する。公開時に false"
  type        = bool
  default     = true
}

variable "access_allowed_emails" {
  description = "Access でサイトを閲覧できるメールアドレス。terraform.tfvars に書く（コミットしない）"
  type        = list(string)
  default     = []

  validation {
    condition     = !var.access_enabled || length(var.access_allowed_emails) > 0
    error_message = "access_enabled = true のときは access_allowed_emails を 1 つ以上指定してください。"
  }
}

variable "manage_otp_identity_provider" {
  description = "ワンタイム PIN のログイン方法を Terraform で作るか。既に有効なら false"
  type        = bool
  default     = true
}
