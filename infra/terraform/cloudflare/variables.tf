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
