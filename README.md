# OKT App

## Requisitos
- Node.js 18+

## Configuração
1. Instalar dependências:
   ```bash
   npm install
   ```

2. Criar ficheiro `.env`:
   ```bash
   DATABASE_URL="file:./dev.db"
   NEXTAUTH_SECRET="okt-dev-secret"
   ```

3. Migrar a base de dados:
   ```bash
   npm run db:migrate
   ```

4. Iniciar a aplicação:
   ```bash
   npm run dev
   ```

## Seed (opcional)
Para inserir dados genéricos de exemplo:
```bash
npm run db:seed
```

## Prisma Studio
```bash
npm run db:studio
```

## Artigos
Para adicionar um artigo, cria um ficheiro `.md` em `content/artigos/` com o frontmatter necessário e faz deploy. Os artigos publicados (`published: true`) aparecem automaticamente na homepage e em `/artigos`.
