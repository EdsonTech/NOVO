# MAJU — Setup do Ambiente

## Pré-requisitos
- **Flutter** ≥ 3.22 (Dart ≥ 3.4) — `flutter doctor` sem erros.
- Android Studio / Xcode para emuladores.
- (Opcional) **Supabase CLI** para o banco.

## 1. Clonar e instalar
```bash
git clone <repo>
cd NOVO/app
flutter pub get
```

## 2. Fontes
Coloque os `.ttf` em `app/assets/fonts/` (Montserrat-SemiBold/Bold/ExtraBold,
Inter-Regular/Medium/SemiBold/Bold) conforme `pubspec.yaml`. Em alternativa,
comente o bloco `fonts:` para usar as fontes do sistema.

## 3. Correr (modo offline / mock)
```bash
flutter run
```
Usa repositórios in-memory — não precisa de backend. Ideal para UI.

## 4. Correr com Supabase (live)
1. Crie um projeto em supabase.com.
2. Aplique [`/supabase/schema.sql`](../supabase/schema.sql) e (opcional)
   [`/supabase/seed.sql`](../supabase/seed.sql).
3. Corra com as chaves:
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://<project>.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<anon-key>
   ```

## 5. Qualidade
```bash
flutter analyze     # lints (ver app/analysis_options.yaml)
flutter test        # testes unitários
dart format .       # formatação
```

## 6. Build
```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
flutter build ipa --release   # iOS
```

## MAJU IA — permissões de plataforma (digitalizar comprovante)

A captura de comprovante usa `image_picker`. Quando os projetos nativos forem
gerados (`flutter create . --platforms=ios,android` dentro de `/app`), adicione:

- **iOS** — `ios/Runner/Info.plist`:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>A MAJU usa a câmara para digitalizar comprovantes.</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>A MAJU acede às fotos para importar comprovantes.</string>
  ```
- **Android** — sem permissões adicionais para galeria; `minSdk 21+` (image_picker 1.x).

A função `image_picker` é chamada com `imageQuality: 85`, que reencoda para **JPEG**,
em linha com o MIME `data:image/jpeg;base64,...` esperado pela Edge Function `maju-ai`.

### Edge Function MAJU IA
```bash
supabase functions deploy maju-ai
supabase secrets set AZURE_OPENAI_ENDPOINT=... AZURE_OPENAI_KEY=... AZURE_OPENAI_DEPLOYMENT=gpt-4o
```
`supabase/config.toml` força `verify_jwt = true` — só chamadas autenticadas.

## Protótipo web (referência de design)
O protótipo HTML/CSS/JS continua em [`/prototype`](../prototype) como referência visual:
```bash
cd prototype && python3 -m http.server 8000   # http://localhost:8000
```
