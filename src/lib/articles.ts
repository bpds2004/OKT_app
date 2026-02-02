import "server-only";

import fs from "fs/promises";
import path from "path";
import matter from "gray-matter";
import { remark } from "remark";
import remarkHtml from "remark-html";

export interface ArticleMeta {
  slug: string;
  title: string;
  excerpt: string;
  date: string;
  cover?: string;
  tags?: string[];
  author?: string;
}

export interface Article extends ArticleMeta {
  content: string;
}

const articlesDirectory = path.join(process.cwd(), "content", "artigos");

async function getArticleFiles(): Promise<string[]> {
  try {
    const files = await fs.readdir(articlesDirectory);
    return files.filter((file) => file.endsWith(".md"));
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      return [];
    }
    throw error;
  }
}

function toArticleMeta(slug: string, data: Record<string, unknown>): ArticleMeta {
  return {
    slug,
    title: String(data.title ?? ""),
    excerpt: String(data.excerpt ?? ""),
    date: String(data.date ?? ""),
    cover: typeof data.cover === "string" ? data.cover : undefined,
    tags: Array.isArray(data.tags) ? data.tags.map((tag) => String(tag)) : undefined,
    author: typeof data.author === "string" ? data.author : undefined,
  };
}

function isPublished(data: Record<string, unknown>): boolean {
  return data.published === true;
}

function sortByDateDesc(a: ArticleMeta, b: ArticleMeta): number {
  const dateA = new Date(a.date).getTime();
  const dateB = new Date(b.date).getTime();
  return dateB - dateA;
}

export async function getAllArticles(): Promise<ArticleMeta[]> {
  const files = await getArticleFiles();
  const entries = await Promise.all(
    files.map(async (file) => {
      const filePath = path.join(articlesDirectory, file);
      const raw = await fs.readFile(filePath, "utf8");
      const { data } = matter(raw);
      const slug = path.basename(file, ".md");
      return isPublished(data) ? toArticleMeta(slug, data) : null;
    }),
  );

  return entries.filter((entry): entry is ArticleMeta => Boolean(entry)).sort(sortByDateDesc);
}

export async function getLatestArticles(limit = 3): Promise<ArticleMeta[]> {
  const articles = await getAllArticles();
  return articles.slice(0, limit);
}

export async function getArticleBySlug(slug: string): Promise<Article | null> {
  const filePath = path.join(articlesDirectory, `${slug}.md`);
  try {
    const raw = await fs.readFile(filePath, "utf8");
    const { data, content } = matter(raw);

    if (!isPublished(data)) {
      return null;
    }

    const processed = await remark().use(remarkHtml).process(content);
    return {
      ...toArticleMeta(slug, data),
      content: processed.toString(),
    };
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      return null;
    }
    throw error;
  }
}
