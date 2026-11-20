// サイト全体で使うプロフィール情報。公開して問題ない情報だけを書く。
export const site = {
  name: 'chama',
  title: 'chama — Portfolio',
  description: 'インフラとWebを手を動かして学んでいるエンジニアのポートフォリオ。',
  role: 'Infrastructure / Web Engineer',
  links: {
    github: 'https://github.com/', // TODO: 自分のアカウント URL
    repo: 'https://github.com/', // TODO: このリポジトリの URL
  },
} as const;

export const nav = [
  { href: '/', label: 'Home' },
  { href: '/projects/', label: 'Projects' },
  { href: '/architecture/', label: 'Architecture' },
] as const;
