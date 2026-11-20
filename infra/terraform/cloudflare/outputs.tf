output "portfolio_hostnames" {
  value = [for d in cloudflare_workers_custom_domain.portfolio : d.hostname]
}

output "homelab_tunnel_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}

# cloudflared の起動に使う。Ansible から `terraform output -raw` で取得する
output "homelab_tunnel_token" {
  value     = data.cloudflare_zero_trust_tunnel_cloudflared_token.homelab.token
  sensitive = true
}
