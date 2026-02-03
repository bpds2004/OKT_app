# OKT App (OncoKit Test)

Aplicação Flutter para o projeto OKT com dois perfis: **Utente** e **Unidade de Saúde**. A app usa Firebase para autenticação e dados persistentes multi-dispositivo, garantindo sincronização e segurança de acesso por role.

## Requisitos
- Flutter 3.10+
- Conta Firebase
- Android Studio/Xcode (para builds nativos)

## Configuração do Firebase
1. Crie um projeto no Firebase.
2. Ative **Authentication** (Email/Password).
3. Crie o Firestore e o Storage.
4. Configure as aplicações Android/iOS:
   - **Android**: adicione `google-services.json` em `android/app/`.
   - **iOS**: adicione `GoogleService-Info.plist` em `ios/Runner/`.
5. Atualize `lib/core/firebase_options.dart` com as credenciais reais do projeto.
6. Publique as regras do Firestore:
   ```
   firebase deploy --only firestore:rules
   ```
7. Confirme no Firebase Console o **package name** (`com.example.okt_app` no `AndroidManifest.xml`) e o **bundle id** do iOS antes de gerar os ficheiros.

> **Nota**: Não incluímos ficheiros `google-services.json` ou `GoogleService-Info.plist` no repositório por segurança. Adicione-os localmente.

## Dependências
Este projeto usa:
- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
- `flutter_riverpod`
- `go_router`

Instale com:
```
flutter pub get
```

## Executar
```
flutter run
```

## Build Release (Play Store)
```
flutter build appbundle
```

## Android (Google Services)
- Plugin `com.google.gms.google-services` já aplicado em `android/app/build.gradle.kts`.
- Compile/Target SDK definidos para 34 e minSdk 21 (compatível com Firebase).
- Se alterar o `applicationId`, atualize também no Firebase Console.

## iOS (CocoaPods)
- `ios/Podfile` definido com deployment target 13.0.
- Após adicionar `GoogleService-Info.plist`, execute:
  ```
  cd ios && pod install
  ```

## Estrutura
```
lib/
  core/
    animations/
    models/
    routes/
    theme/
    widgets/
  features/
    auth/
    utente/
    unidade_saude/
```

## Segurança e privacidade
- Regras Firestore em `firebase/firestore.rules`.
- Utente lê/escreve apenas os próprios dados.
- Unidade de saúde lê dados atribuídos conforme `unidadeId` nos documentos.
