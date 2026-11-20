# ---------------------------------------------------------------------------
# ポートフォリオ本体 (Worker) を独自ドメインの apex と www に割り当てる
# Worker 自体のデプロイは GitHub Actions の wrangler deploy が担当する
# ---------------------------------------------------------------------------
resource "cloudflare_workers_custom_domain" "portfolio" {
  for_each = toset([var.zone_name, "www.${var.zone_name}"])

  account_id = var.account_id
  zone_id    = var.zone_id
  hostname   = each.value
  service    = var.worker_name
}

# ---------------------------------------------------------------------------
# 自宅ラボ用の Cloudflare Tunnel
# ルーターのポートを開けずに、cloudflared からの外向き接続だけで公開する
# ---------------------------------------------------------------------------
resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id = var.account_id
  name       = "homelab"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "homelab" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id

  config = {
    ingress = concat(
      [for sub, svc in var.homelab_services : {
        hostname = "${sub}.${var.zone_name}"
        service  = svc
      }],
      # どのルールにも当たらないリクエストは 404 を返す（必須の最終ルール）
      [{ service = "http_status:404" }],
    )
  }
}

resource "cloudflare_dns_record" "homelab" {
  for_each = var.homelab_services

  zone_id = var.zone_id
  name    = "${each.key}.${var.zone_name}"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
  comment = "Managed by Terraform: homelab tunnel"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "homelab" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}
