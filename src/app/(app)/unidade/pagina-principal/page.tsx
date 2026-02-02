import { getLatestArticles } from "@/lib/articles";
import UnidadePaginaPrincipalClient from "./pagina-principal-client";

export default async function UnidadePaginaPrincipal() {
  const articles = await getLatestArticles(3);

  return <UnidadePaginaPrincipalClient articles={articles} />;
}
