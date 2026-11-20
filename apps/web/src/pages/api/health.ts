import type { APIRoute } from 'astro';

// Worker として動的に応答するエンドポイント。外形監視 (Uptime Kuma) から叩く想定。
export const prerender = false;

export const GET: APIRoute = () =>
  Response.json(
    { status: 'ok', time: new Date().toISOString() },
    { headers: { 'cache-control': 'no-store' } },
  );
