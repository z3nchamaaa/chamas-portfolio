# 0005. Terraform の state を Cloudflare R2 に置く

- 状態: Accepted
- 日付: 2026-11-20

## 背景

Terraform の state には機密情報が含まれるのでリポジトリには置けない。ローカルだけに置くと CI から plan できず、紛失のリスクもある。

## 決定

S3 互換の Cloudflare R2 を backend にし、`use_lockfile` でロックする。接続情報は `backend.hcl`（コミットしない）と環境変数で渡す。

## 検討した選択肢

- HCP Terraform（無料枠あり）: 手軽だが、Cloudflare に寄せている構成から外れる
- OCI Object Storage: 使えるが、Cloudflare 側の構成を管理する state を別クラウドに置くことになる

## 結果・トレードオフ

- 無料枠（10 GB）で十分収まる
- R2 バケット自体は Terraform 管理外（鶏と卵問題）。手動で作り、手順を runbook に残す
