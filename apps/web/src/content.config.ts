import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const projects = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects' }),
  schema: z.object({
    title: z.string(),
    summary: z.string(),
    tags: z.array(z.string()).default([]),
    // どこで動いているか。構成図と対応させる
    runsOn: z.array(z.enum(['cloudflare', 'oracle', 'gcp', 'proxmox', 'github'])).default([]),
    repo: z.url().optional(),
    demo: z.url().optional(),
    order: z.number().default(100),
    draft: z.boolean().default(false),
  }),
});

export const collections = { projects };
