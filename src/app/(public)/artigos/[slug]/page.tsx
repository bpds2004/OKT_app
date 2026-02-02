import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { PageTransition } from "@/components/common/page-transition";
import { getArticleBySlug } from "@/lib/articles";

function formatDate(date: string) {
  const value = new Date(date);
  return Number.isNaN(value.getTime())
    ? date
    : new Intl.DateTimeFormat("pt-PT", {
        day: "2-digit",
        month: "long",
        year: "numeric",
      }).format(value);
}

interface ArticlePageProps {
  params: {
    slug: string;
  };
}

export default async function ArticlePage({ params }: ArticlePageProps) {
  const article = await getArticleBySlug(params.slug);

  if (!article) {
    notFound();
  }

  return (
    <PageTransition>
      <div className="min-h-screen bg-white px-6 pb-10 pt-6">
        <Link href="/artigos" className="text-xs font-semibold text-brand-600">
          ← Voltar
        </Link>

        <article className="mt-4">
          {article.cover ? (
            <div
              className="h-48 w-full rounded-2xl bg-brand-50 bg-cover bg-center"
              style={{ backgroundImage: `url(${article.cover})` }}
            />
          ) : null}
          <h1 className="mt-6 text-xl font-semibold text-brand-800">{article.title}</h1>
          <p className="mt-2 text-xs text-brand-400">{formatDate(article.date)}</p>

          {article.tags?.length ? (
            <div className="mt-3 flex flex-wrap gap-2">
              {article.tags.map((tag) => (
                <Badge key={tag} variant="neutral">
                  {tag}
                </Badge>
              ))}
            </div>
          ) : null}

          <div
            className="markdown mt-6"
            dangerouslySetInnerHTML={{ __html: article.content }}
          />
        </article>
      </div>
    </PageTransition>
  );
}
