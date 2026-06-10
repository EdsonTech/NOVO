# MAJU Finanças — Flutter App

Real mobile app for MAJU (Android/iOS), Flutter + Material 3 + Riverpod + Supabase.

## Quick start

```bash
cd app
flutter pub get

# Offline/mock mode (no backend needed — uses in-memory repositories):
flutter run

# With a live Supabase backend:
flutter run \
  --dart-define=SUPABASE_URL=https://<project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key>
```

> Fonts: drop the Montserrat/Inter `.ttf` files into `assets/fonts/` (see
> `pubspec.yaml`) or remove the `fonts:` block to fall back to system fonts.

## Architecture

Feature-first + light Clean Architecture. See [`/docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md).

```
lib/src/
  core/        config · theme · router · widgets · utils
  features/<feature>/
    domain/        entities (pure Dart)
    data/          repositories (Supabase impl + in-memory impl)
    presentation/  screens + Riverpod providers
```

- **State:** Riverpod  ·  **Routing:** go_router (StatefulShellRoute bottom tabs)
- **Backend:** Supabase (managed PostgreSQL). Schema in [`/supabase`](../supabase).
- **Swappable backend:** the UI depends on repository *interfaces*; the Spring Boot
  API can replace Supabase later with no presentation-layer changes.

## Tests

```bash
flutter test
```

## Implemented vs scaffolded

Fully wired end-to-end: onboarding (4 screens), Dashboard, Finanças (list + add,
live totals), Família, Sonhos. Other journeys (Desafio, Academia, IA, Património,
Score, Configurações) are routed to placeholders — see `/docs/BACKLOG.md` and
`/docs/SPRINTS.md` for ownership and sequencing.
