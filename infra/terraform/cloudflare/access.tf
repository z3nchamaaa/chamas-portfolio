# ---------------------------------------------------------------------------
# 公開前はサイト全体を Cloudflare Access で保護し、許可したメールアドレスだけが見られるようにする
# 公開するときは access_enabled = false にして apply する
# ---------------------------------------------------------------------------

locals {
  portfolio_hostnames = [var.zone_name, "www.${var.zone_name}"]
}

# メールに届くワンタイム PIN でログインする。既に Zero Trust 側で有効化済みなら
# manage_otp_identity_provider = false にする（同じ種類の IdP は 1 つしか作れない）
resource "cloudflare_zero_trust_access_identity_provider" "otp" {
  count = var.access_enabled && var.manage_otp_identity_provider ? 1 : 0

  account_id = var.account_id
  name       = "One-time PIN"
  type       = "onetimepin"
  config     = {}
}

resource "cloudflare_zero_trust_access_policy" "owner_only" {
  count = var.access_enabled ? 1 : 0

  account_id       = var.account_id
  name             = "Portfolio: owner only"
  decision         = "allow"
  session_duration = "24h"
  include          = [for e in var.access_allowed_emails : { email = { email = e } }]
}

resource "cloudflare_zero_trust_access_application" "portfolio" {
  count = var.access_enabled ? 1 : 0

  account_id       = var.account_id
  name             = "Portfolio (pre-release)"
  type             = "self_hosted"
  domain           = var.zone_name
  destinations     = [for h in local.portfolio_hostnames : { type = "public", uri = h }]
  session_duration = "24h"

  policies = [{
    id         = cloudflare_zero_trust_access_policy.owner_only[0].id
    precedence = 1
  }]
}

# 外形監視 (Uptime Kuma) から叩くヘルスチェックだけは認証なしで通す。
# パスがより具体的なアプリケーションが優先される
resource "cloudflare_zero_trust_access_policy" "bypass_everyone" {
  count = var.access_enabled ? 1 : 0

  account_id = var.account_id
  name       = "Portfolio: health check bypass"
  decision   = "bypass"
  include    = [{ everyone = {} }]
}

resource "cloudflare_zero_trust_access_application" "health" {
  count = var.access_enabled ? 1 : 0

  account_id   = var.account_id
  name         = "Portfolio health check"
  type         = "self_hosted"
  domain       = "${var.zone_name}/api/health"
  destinations = [{ type = "public", uri = "${var.zone_name}/api/health" }]

  policies = [{
    id         = cloudflare_zero_trust_access_policy.bypass_everyone[0].id
    precedence = 1
  }]
}
