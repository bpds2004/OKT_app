import Link from "next/link";
import { PageTransition } from "@/components/common/page-transition";
import { Badge } from "@/components/ui/badge";
import { getAllArticles } from "@/lib/articles";

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

export default async function ArtigosPage() {
  const articles = await getAllArticles();

  return (
    <PageTransition>
      <div className="min-h-screen bg-white px-6 pb-10 pt-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-xl font-semibold text-brand-800">Artigos</h1>
            <p className="mt-1 text-xs text-brand-500">
              Informação simples e útil para acompanhar a tua saúde.
            </p>
          </div>
          <Link href="/" className="text-xs font-semibold text-brand-600">
            Voltar
          </Link>
        </div>

        <div className="mt-6 space-y-4">
          {articles.length === 0 ? (
            <div className="rounded-2xl border border-dashed border-brand-100 bg-brand-50 px-4 py-6 text-sm text-brand-500">
              Ainda não existem artigos publicados.
            </div>
          ) : (
            articles.map((article) => (
              <Link key={article.slug} href={`/artigos/${article.slug}`} className="block">
                <article className="rounded-2xl border border-brand-50 bg-white p-4 shadow-sm transition hover:shadow-soft">
                  <div
                    className="h-40 w-full rounded-xl bg-brand-50 bg-cover bg-center"
                    style={article.cover ? { backgroundImage: `url(${article.cover})` } : undefined}
                  />
                  <div className="mt-4 flex flex-wrap items-center gap-2">
                    {article.tags?.map((tag) => (
                      <Badge key={tag} variant="neutral">
                        {tag}
                      </Badge>
                    ))}
                  </div>
                  <h2 className="mt-3 text-base font-semibold text-brand-800">
                    {article.title}
                  </h2>
                  <p className="mt-2 text-sm text-brand-600">{article.excerpt}</p>
                  <p className="mt-3 text-xs text-brand-400">{formatDate(article.date)}</p>
                </article>
              </Link>
            ))
          )}
        </div>
      </div>
    </PageTransition>
  );
}
