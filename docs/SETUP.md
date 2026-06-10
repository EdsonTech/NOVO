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

## Protótipo web (referência de design)
O protótipo HTML/CSS/JS continua em [`/prototype`](../prototype) como referência visual:
```bash
cd prototype && python3 -m http.server 8000   # http://localhost:8000
```
