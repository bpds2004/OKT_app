import { getLatestArticles } from "@/lib/articles";
import PaginaPrincipalClient from "./pagina-principal-client";

export default async function PaginaPrincipalPage() {
  const articles = await getLatestArticles(3);

  return <PaginaPrincipalClient articles={articles} />;
}
