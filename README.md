# OKT Mobile (Flutter)

Aplicação mobile 100% Flutter para Android, com autenticação Supabase, BLE e duas áreas (Utente e Unidade de Saúde).

## ✅ Requisitos

- Flutter (stable)
- Conta Supabase
- Android Studio (ou outro ambiente para Android)

## 🧱 Configuração Supabase

1. Criar um projeto no Supabase.
2. Executar o schema:

```sql
-- no SQL Editor do Supabase
\i supabase/schema.sql
```

3. Executar as policies:

```sql
\i supabase/policies.sql
```

4. Criar um ficheiro `.env` na raiz do projeto:

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

> ⚠️ Nunca usar a `service_role key` no client.

## ▶️ Executar

```bash
flutter pub get
flutter run
```

## 📱 Build Play Store (AAB)

```bash
flutter build appbundle
```

## 📂 Estrutura

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
      profile_repo.dart
      tests_repo.dart
      results_repo.dart
      notifications_repo.dart
  features/
    auth/
      screens/
      controllers/
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
```
