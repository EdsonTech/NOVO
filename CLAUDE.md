# CLAUDE.md

Guidance for AI assistants (Claude Code and others) working in this repository.

## Project overview

**MAJU Finanças** — *"Organize Hoje. Prospere Amanhã."* — is a financial wellbeing
platform for Angolan families and women entrepreneurs (Angola + PALOPs). It's an
ecosystem of family financial prosperity and female entrepreneurship, structured around
4 journeys (Financeira, Familiar, Empreendedora, Patrimonial) and **30 screens / 12
journeys** total.

This repo is a **monorepo** with two implementations plus full project docs:

- **`/app`** — the **real Flutter app** (Material 3 · Riverpod · go_router · Supabase).
  This is the product being built.
- **`/prototype`** — the original **clickable web prototype** (HTML/CSS/JS), kept as the
  visual/UX reference for all 30 screens.
- **`/supabase`** — PostgreSQL schema + seed (the app's backend/database).
- **`/docs`** — team org, sprint plan, backlog, architecture, database, setup.

## Repository structure

```
/
├── app/                      # Flutter app (the real product)
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   ├── lib/
│   │   ├── main.dart         # Boots Supabase (if configured) + ProviderScope
│   │   └── src/
│   │       ├── app.dart      # MaterialApp.router + theme + l10n
│   │       ├── core/         # config · theme · router · widgets · utils
│   │       └── features/<feature>/{domain,data,presentation}
│   ├── test/
│   └── assets/images/maju-logo.png
├── prototype/                # Web prototype (HTML/CSS/JS) — design reference
│   ├── index.html · css/maju.css · js/maju.js
├── supabase/                 # schema.sql + seed.sql (managed PostgreSQL)
├── assets/                   # brand source (logo, design reference mockup)
├── docs/                     # TEAM · SPRINTS · BACKLOG · ARCHITECTURE · DATABASE · SETUP
└── CLAUDE.md
```

## The Flutter app (`/app`)

### Stack & decisions
- **State:** Riverpod (`AsyncValue`, no `setState` for domain data).
- **Routing:** go_router with `StatefulShellRoute.indexedStack` (5 bottom tabs:
  Início · Finanças · Família · Sonhos · Mais). Paths live in `core/router/routes.dart`.
- **Theme:** Material 3, brand tokens in `core/theme/maju_colors.dart` + `maju_theme.dart`
  (blue `#15396B`, orange `#E8742C`, green `#27A567`). Currency via `core/utils/currency.dart`
  (`Money.kz`) — **Kwanza only**.
- **Backend:** **Supabase** (managed PostgreSQL). The UI depends on **repository
  interfaces**; implementations are chosen at runtime by `Env.hasBackend`:
  - `SupabaseFinancesRepository` (live) or `InMemoryFinancesRepository` (offline/mock).
  - This makes the future Spring Boot API a drop-in swap. See `docs/ARCHITECTURE.md`.

### Architecture (feature-first + light Clean Architecture)
Each journey is `lib/src/features/<feature>/` with:
- `domain/` — pure-Dart entities (e.g. `Transaction`), no Flutter imports.
- `data/` — repository interface + Supabase impl + in-memory impl.
- `presentation/` — screens (`*_screen.dart`) + Riverpod providers.

Shared building blocks in `core/widgets/maju_widgets.dart` (`MajuCard`, `HeroBalanceCard`,
`StatTile`, `MajuList`, `MajuListRow`, `SectionTitle`). **Reuse these**; don't hand-roll
styles when a component/token exists.

### Implemented vs scaffolded
- **Fully wired:** onboarding (splash + 3 steps); Dashboard; Finanças (movements list +
  add with live totals, Fluxo de Caixa via `fl_chart`, Dívidas + plano); Família; Sonhos
  (live goals repo, criar meta, simulador); **Desafio 1 Milhão**; **MAJU IA** (chat +
  digitalizar comprovante → extração → classificação → lançamento automático);
  **Património** (activos live + evolução `fl_chart`); **Score MAJU + Microcrédito**
  (score 0–1000 derivado das finanças + elegibilidade).
- **Placeholders** (routed to `JourneyPlaceholderScreen`, owned by later sprints):
  Academia, Configurações, Centro de Negócios/Marketplace.

### MAJU IA (receipt → auto-entry)
`features/ai/` follows the same swap pattern: `AiRepository` interface with
`MockAiRepository` (offline) and `SupabaseAiRepository` (calls the `maju-ai` Edge
Function → Azure OpenAI). The API key stays **server-side** in
`supabase/functions/maju-ai/index.ts`. `CategoryClassifier` (pure Dart) normalises/
validates the model's category against MAJU's canonical list. The scan flow pre-fills an
editable review screen, then creates a `Transaction` via `addTransactionProvider`.
- The web prototype in `/prototype` already models the UI for **all** 30 screens — use it
  as the spec when implementing a placeholder.

### Run / test
```bash
cd app
flutter pub get
flutter run                                  # offline/mock mode (no backend)
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
flutter analyze && flutter test
```
> Note: the Flutter SDK is **not installed in this container** — author valid Dart and
> verify via `flutter analyze`/`flutter test` on a machine with Flutter. Target floor:
> Flutter 3.22 / Dart 3.4 (see `pubspec.yaml`).

## The web prototype (`/prototype`)

Static SPA, no build. A JS router (`js/maju.js`) toggles screens from a `state` object;
`data-nav` / `data-pick` / `data-toggle` / `data-add` hooks drive interactions. Serve with
`cd prototype && python3 -m http.server 8000`. Edit `css/maju.css` for styling. Keep it as
the design source of truth; brand palette matches `assets/maju-design-reference.png`.

## Database (`/supabase`)

`schema.sql` defines `households`, `profiles`, `transactions`, `goals`, `assets` with
**Row Level Security** (each user sees only their household via `current_household()`).
`seed.sql` loads demo data matching the prototype. Apply via the Supabase SQL editor or
`supabase db push`. Details in `docs/DATABASE.md`.

## Project management (`/docs`)
- `TEAM.md` — squads, roles, RACI, Scrum cadence (2-week sprints, DoD, branching).
- `SPRINTS.md` — S0→S14 plan mapping journeys to sprints + commercial roadmap.
- `BACKLOG.md` — epics → user stories → tasks (SP estimates, ✅/🟨/⬜ status).
- `ARCHITECTURE.md`, `DATABASE.md`, `SETUP.md`.

When asked to "develop per the prototypes," map the request to a journey/screen in
`BACKLOG.md`, follow the sprint ownership in `SPRINTS.md`, and implement using the
existing feature pattern + `core/widgets`.

## Conventions
- **Dart:** single quotes, trailing commas, lints in `app/analysis_options.yaml`. Use
  relative imports inside `lib/`, `package:` imports in `test/`.
- **Money is always Kwanza** — format with `Money.kz`, never hardcode currency strings.
- **Content language is Portuguese (pt-AO).**
- **Secrets** via `--dart-define` only — never commit keys. `.env`/keystores are gitignored.
- **Keep the backend swappable** — add new data access behind a repository interface with
  both a Supabase and an in-memory implementation.

## Git workflow
- Active branch: **`claude/claude-md-documentation-bfd1lu`**. Develop, commit, push here;
  do not push to `master` without explicit permission.
- Commit messages are short, often Portuguese. **Do not open a PR unless asked.**
- Push with `git push -u origin <branch>`; retry transient network errors with backoff.

## Working notes for AI assistants
- Two codebases coexist: `/app` (real, in progress) and `/prototype` (reference, complete
  UI). Don't confuse them — feature work goes in `/app`.
- The Flutter app can't compile in this container; reason carefully about Dart/Flutter
  3.22 APIs and keep edits surgical and consistent with the existing files.
- Prefer extending the established patterns (repository + provider + screen + `core/widgets`)
  over introducing new dependencies or architectures.
