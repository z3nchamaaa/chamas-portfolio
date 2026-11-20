# 初期構築手順

一度だけ手で行う作業をまとめる。2 回目以降の変更はすべてコード経由で行う。

## 1. Cloudflare

1. 独自ドメインを取得し、Cloudflare にゾーンを追加する
2. R2 バケット `portfolio-tfstate` を作り、R2 の API トークン（Object Read & Write）を発行する
3. Terraform 用の API トークンを発行する（必要な権限: Workers Scripts / Workers Routes / DNS / Cloudflare Tunnel の編集）
4. `infra/terraform/backend.hcl.example` を `backend.hcl` にコピーして値を埋める

## 2. ポートフォリオの初回デプロイ

Workers のカスタムドメインは Worker が存在しないと作れないため、先に一度デプロイする。

```bash
npx wrangler login
npm run deploy
```

## 3. Terraform (Cloudflare)

```bash
cd infra/terraform/cloudflare
cp terraform.tfvars.example terraform.tfvars   # 値を埋める
export CLOUDFLARE_API_TOKEN=...
export AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=...   # R2 のキー
terraform init -backend-config=../backend.hcl
terraform apply
```

## 4. Oracle Cloud

1. API キーを作って `~/.oci/config` に設定する
2. `infra/terraform/oci/terraform.tfvars` を作り、`ssh_allowed_cidrs` に一時的に自宅 IP を入れて `terraform apply`
3. Ansible で Tailscale を入れたら `ssh_allowed_cidrs = []` に戻して再度 `apply`

A1 インスタンスは在庫切れで作れないことがある。その場合は時間をおいて再実行する。

## 5. Ansible

```bash
cd infra/ansible
cp inventory/hosts.yml.example inventory/hosts.yml   # 値を埋める
ansible-galaxy collection install -r requirements.yml
export TAILSCALE_AUTHKEY=...
export CLOUDFLARED_TOKEN=$(terraform -chdir=../terraform/cloudflare output -raw homelab_tunnel_token)
ansible-playbook playbooks/site.yml
```

## 6. GitHub Actions のシークレット

| 名前 | 用途 |
|---|---|
| `CLOUDFLARE_API_TOKEN` | wrangler deploy / terraform |
| `CLOUDFLARE_ACCOUNT_ID` | wrangler deploy |
