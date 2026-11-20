# chama's portfolio

ポートフォリオサイトと、それを支えるインフラをまとめて管理しているリポジトリです。
サイトの中身だけでなく、DNS・ホスティング・自宅ラボ・監視までをコードで管理しています。

- サイト: https://example.com <!-- TODO: 独自ドメインに置き換える -->
- 構成の解説: [/architecture](https://example.com/architecture/)

## 構成

```
              [ Cloudflare ]
  DNS / Workers (this site) / Tunnel / Access
        |                          |
        | Tunnel                   |
        v                          v
 [ Proxmox (home) ] <-Tailscale-> [ Oracle Cloud ]
  k3s / monitoring / demos         Uptime Kuma / hub

 [ GitHub ] code / IaC / CI / ADR --> every layer
```

| レイヤー | 役割 | 管理しているコード |
|---|---|---|
| Cloudflare | DNS、Workers（このサイト）、Tunnel | [`apps/web`](apps/web), [`infra/terraform/cloudflare`](infra/terraform/cloudflare) |
| Oracle Cloud (Always Free) | 外形監視、Tailscale ハブ | [`infra/terraform/oci`](infra/terraform/oci), [`infra/ansible`](infra/ansible) |
| Proxmox VE（自宅） | k3s、監視基盤、デモアプリ | [`infra/ansible`](infra/ansible) |
| GitHub | CI/CD、設計記録 | [`.github/workflows`](.github/workflows), [`docs/adr`](docs/adr) |

設計方針は次の 2 点です。

1. **公開サイトを自宅ラボに依存させない** — 自宅が止まってもサイトは表示される（[ADR 0003](docs/adr/0003-separate-public-site-from-homelab.md)）
2. **インバウンドのポートを開けない** — 公開は Cloudflare Tunnel、管理は Tailscale（[ADR 0004](docs/adr/0004-no-inbound-ports.md)）

判断の経緯はすべて [docs/adr](docs/adr) に残しています。

## ディレクトリ

```
apps/web/                 Astro で作ったサイト本体（Cloudflare Workers にデプロイ）
infra/terraform/
  cloudflare/             Workers のカスタムドメイン、Tunnel、DNS
  oci/                    Oracle Cloud の VCN と ARM インスタンス
infra/ansible/            VM の構成管理（Tailscale、cloudflared、Uptime Kuma など）
docs/adr/                 設計判断の記録
docs/runbooks/            手作業が必要な手順
.github/workflows/        CI/CD
```

## 技術スタック

- **Web**: Astro 7, MDX, TypeScript, Cloudflare Workers
- **IaC**: Terraform (Cloudflare / OCI provider), Ansible
- **Network**: Cloudflare Tunnel, Tailscale
- **CI/CD**: GitHub Actions
- **State**: Cloudflare R2（Terraform backend）

## 開発

```bash
npm install
npm run dev       # http://localhost:4321
npm run check     # 型チェック
npm run build
```

プロジェクトの紹介ページは `apps/web/src/content/projects/` に MDX で追加します。

## CI/CD

| ワークフロー | 内容 |
|---|---|
| [`web`](.github/workflows/web.yml) | PR で型チェックとビルド、`main` へのマージで Cloudflare Workers にデプロイ |
| [`infra`](.github/workflows/infra.yml) | Terraform の fmt / validate、ansible-lint |

## 初期構築

最初の一度だけ必要な手作業は [docs/runbooks/bootstrap.md](docs/runbooks/bootstrap.md) にまとめています。
