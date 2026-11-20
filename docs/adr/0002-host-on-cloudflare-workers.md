# 0002. ポートフォリオを Cloudflare Workers でホストする

- 状態: Accepted
- 日付: 2026-11-20

## 背景

ポートフォリオ本体は静的ページが中心だが、問い合わせフォームや閲覧数、自宅ラボの状態表示など、少しだけサーバー処理が欲しい。費用は無料枠に収めたい。

## 決定

Astro で静的生成し、Cloudflare Workers（静的アセット機能）でホストする。動的な処理だけ Worker で返す。

## 検討した選択肢

| 選択肢 | 良い点 | 見送った理由 |
|---|---|---|
| GitHub Pages | 最も手軽 | サーバー処理ができず、後から機能を足すと移行が必要 |
| Vercel (Hobby) | Next.js との相性が最良 | 商用利用不可。DNS や Tunnel と管理画面が分かれる |
| Cloudflare Pages | 無料枠が広い | 新規開発は Workers 側に寄せる方針が示されている |
| **Cloudflare Workers** | 静的アセットは無制限、KV/D1/R2/Cron が使える、DNS・Tunnel と一元管理 | — |

## 結果・トレードオフ

- DNS・ホスティング・Tunnel を Cloudflare にまとめ、Terraform で一括管理できる
- Node.js 固有の API に依存するライブラリは使いにくい（`nodejs_compat` で大半は動く）
- Cloudflare への依存度が高くなる。静的出力なので、他のホスティングへの移行は比較的容易
