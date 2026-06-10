# MAJU — Arquitetura

## Visão geral

```
┌─────────────────────────────────────────────────────────────┐
│                     App Flutter (Material 3)                 │
│  presentation (widgets + Riverpod) → domain (entidades)      │
│                         ↓ depende de interfaces ↓            │
│                    data (repositórios)                       │
│        ┌───────────────────────┬───────────────────────┐    │
│        │ InMemory (offline/mock)│ Supabase (live)       │    │
│        └───────────────────────┴───────────┬───────────┘    │
└────────────────────────────────────────────┼───────────────┘
                                              │ HTTPS / Realtime
                          ┌───────────────────▼─────────────────┐
                          │ Supabase (MVP)                       │
                          │  PostgreSQL · Auth/OTP · Storage     │
                          │  Edge Functions → Azure OpenAI       │
                          └───────────────────┬──────────────────┘
                                              │ (migração futura)
                          ┌───────────────────▼──────────────────┐
                          │ Produção alvo                         │
                          │ Spring Boot 3 / Java 21 / WebFlux     │
                          │ PostgreSQL · Redis · Azure · Power BI │
                          │ Azure AD B2C · MFA · OTP SMS          │
                          └──────────────────────────────────────┘
```

## Princípios
1. **Feature-first.** Cada jornada é uma pasta em `lib/src/features/<feature>` com
   `domain/`, `data/`, `presentation/`. O `core/` guarda tema, router, widgets e utils.
2. **A UI depende de abstrações.** Os ecrãs falam com *interfaces* de repositório
   (`FinancesRepository`), nunca com o cliente HTTP/Supabase diretamente. Trocar o
   backend (Supabase → Spring Boot) não toca na camada de apresentação.
3. **Offline-first no desenvolvimento.** Sem chaves Supabase, a app usa repositórios
   in-memory — a equipa desenvolve e demonstra UI sem backend.
4. **Estado com Riverpod.** Providers expõem `AsyncValue` (loading/error/data);
   nada de `setState` para dados de domínio.
5. **Segurança por defeito.** RLS no Postgres garante que cada utilizadora só vê o
   seu agregado familiar; segredos via `--dart-define`, nunca no repo.

## Camadas
| Camada | Pasta | Conteúdo |
|---|---|---|
| Presentation | `features/*/presentation` | Ecrãs (`*_screen.dart`) + providers Riverpod |
| Domain | `features/*/domain` | Entidades puras (sem Flutter), regras |
| Data | `features/*/data` | Repositórios: interface + impl (Supabase / in-memory) |
| Core | `core/` | `theme`, `router`, `widgets`, `utils`, `config` |

## Decisões (ADR resumido)
- **Riverpod** (vs Bloc): menos boilerplate, providers compostos, testável sem widgets.
- **go_router** (`StatefulShellRoute`): tabs com estado preservado por branch.
- **Supabase como banco/recurso próprio do MVP:** *é* PostgreSQL gerido (alinha com o
  alvo de produção), traz Auth+OTP, Storage, RLS e Edge Functions — entrega valor já,
  com caminho de migração limpo para a API Spring Boot. Ver [`DATABASE.md`](./DATABASE.md).
- **fl_chart** para gráficos (fluxo de caixa, evolução patrimonial).
- **intl** para Kwanza (`Money.kz`), única moeda.

## Fluxo de uma feature (ex.: adicionar despesa)
1. `AddTransactionScreen` valida o form e chama `addTransactionProvider`.
2. O provider chama `FinancesRepository.add(tx)` (impl selecionada por config).
3. Invalida `transactionsProvider`; a Home e Finanças recompõem com novos totais.
