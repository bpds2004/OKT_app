# OKT Mobile (Flutter)

Aplicação mobile 100% Flutter para Android (Play Store), com Supabase Auth, BLE e duas áreas: Utente e Unidade de Saúde.

## ✅ Stack

- Flutter (stable)
- Supabase (Auth + Postgres)
- Packages: supabase_flutter, flutter_blue_plus, go_router, flutter_riverpod, flutter_dotenv, intl

## 🧱 Configuração Supabase

1. Criar um projeto no Supabase.
2. Executar o schema no SQL Editor:

```sql
\i supabase/schema.sql
```

3. Executar as policies:

```sql
\i supabase/policies.sql
```

4. (Opcional) Inserir os 5 artigos obrigatórios:

```sql
\i supabase/seed_articles.sql
```

5. Criar um ficheiro `.env` na raiz do projeto (não commitar):

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

> ⚠️ Nunca usar a `service_role key` no client.

## ▶️ Executar localmente

```bash
flutter pub get
flutter run
```

Abra o projeto no Android Studio e selecione um dispositivo físico/emulador Android.

## 📱 Build Play Store (AAB)

```bash
flutter build appbundle
```

## 📂 Estrutura do projeto

```
lib/
  main.dart
  app.dart
  router/
    app_router.dart
  core/
    env.dart
    theme/
      okt_theme.dart
    widgets/
  data/
    supabase/
      supabase_client.dart
    repositories/
      auth_repo.dart
      articles_repo.dart
      profile_repo.dart
      tests_repo.dart
      results_repo.dart
      notifications_repo.dart
  features/
    auth/
      screens/
      controllers/
    articles/
      screens/
    ble/
      screens/
      controllers/
      ble_service.dart
    utente/
      screens/
      controllers/
    unidade/
      screens/
      controllers/

supabase/
  schema.sql
  policies.sql
  seed_articles.sql
```
