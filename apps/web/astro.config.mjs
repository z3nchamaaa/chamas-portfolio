// @ts-check
import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  // 独自ドメインが決まったら SITE_URL を設定する（sitemap / OGP の絶対 URL に使う）
  site: process.env.SITE_URL || 'https://example.com',
  // ページは基本すべて静的生成。API など動的にしたいものだけ `export const prerender = false`
  output: 'static',
  // 画像はビルド時に最適化する（Cloudflare Images の利用枠に依存しない）
  adapter: cloudflare({ imageService: 'compile' }),
  // セッションは使わないので KV の自動プロビジョニングを止める
  session: false,
  integrations: [mdx(), sitemap()],
});
