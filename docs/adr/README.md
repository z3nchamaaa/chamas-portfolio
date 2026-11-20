# Architecture Decision Records

構成上の判断とその理由を残す。判断を変えるときは既存の ADR を書き換えず、新しい ADR を追加して古いものを `Superseded` にする。

| # | タイトル | 状態 |
|---|---|---|
| [0001](0001-record-architecture-decisions.md) | 設計判断を ADR で記録する | Accepted |
| [0002](0002-host-on-cloudflare-workers.md) | ポートフォリオを Cloudflare Workers でホストする | Accepted |
| [0003](0003-separate-public-site-from-homelab.md) | 公開サイトを自宅ラボに依存させない | Accepted |
| [0004](0004-no-inbound-ports.md) | インバウンドのポートを開けない | Accepted |
| [0005](0005-terraform-state-on-r2.md) | Terraform の state を Cloudflare R2 に置く | Accepted |

新しい ADR は [template.md](template.md) をコピーして作る。
