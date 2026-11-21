# 0006. 公開前は Cloudflare Access でサイトを保護する

- 状態: Accepted
- 日付: 2026-11-21

## 背景

作りかけのポートフォリオを本番環境と同じ構成で確認したいが、完成前のページは他人に見せたくない。

## 決定

- 公開前は独自ドメイン全体を Cloudflare Access で保護し、許可したメールアドレスだけがワンタイム PIN でログインできるようにする
- `/api/health` だけは外形監視のために Bypass する
- `workers.dev` とプレビュー URL は Access を通らないため、`wrangler.jsonc` で無効化する
- 公開時は Terraform の `access_enabled = false` を apply するだけで外せるようにする

## 検討した選択肢

- Basic 認証を Worker に実装する: アプリ側に認証コードが残り、公開時にコード変更が必要
- `noindex` だけ付ける: URL を知っていれば誰でも見られる

## 結果・トレードオフ

- 本番と同じドメイン・構成のまま非公開で確認できる
- Zero Trust の無料プラン（50 ユーザーまで）で収まる
- 許可するメールアドレスは `terraform.tfvars`（コミットしない）にだけ書く
