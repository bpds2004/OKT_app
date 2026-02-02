# OKT App

## Requisitos
- Node.js 18+

## Configuração
1. Instalar dependências:
   ```bash
   npm install
   ```

2. Criar um projeto no Supabase:
   - Copiar o Project URL e a Anon Key (Settings → API).
   - Copiar a Service Role Key (apenas server-side).

3. Executar o schema e as policies:
   - Abrir o SQL Editor do Supabase.
   - Correr o ficheiro `supabase/schema.sql`.
   - Correr o ficheiro `supabase/policies.sql`.

4. Criar ficheiro `.env.local`:
   ```bash
   NEXT_PUBLIC_SUPABASE_URL=
   NEXT_PUBLIC_SUPABASE_ANON_KEY=
   SUPABASE_SERVICE_ROLE_KEY=
   ```

5. Iniciar a aplicação:
   ```bash
   npm run dev
   ```

## Deploy
- Configura as variáveis de ambiente no provider (Vercel/Render/etc).
- Garante que as policies RLS estão ativas no Supabase.

## Artigos
Para adicionar um artigo, cria um ficheiro `.md` em `content/artigos/` com o frontmatter necessário e faz deploy. Os artigos publicados (`published: true`) aparecem automaticamente na homepage e em `/artigos`.
