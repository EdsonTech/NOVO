# MAJU — Banco de Dados

## Decisão: Supabase (PostgreSQL gerido) como recurso próprio do MVP

Requisito: *"adotar banco e outro recurso próprio"*. Escolha: **Supabase**.

**Porquê:**
- **É PostgreSQL** — alinha 1:1 com o banco alvo de produção (Postgres), sem reescrever
  o modelo de dados quando entrar a API Spring Boot.
- **Recurso próprio e controlável** — projeto dedicado, com a equipa a gerir schema,
  RLS, backups e chaves.
- **Inclui o essencial do MVP**: Auth (email + **OTP SMS**, alinhado ao requisito),
  Storage (certificados, documentos), Realtime e **Edge Functions** (proxy seguro para
  Azure OpenAI da MAJU IA).
- **Row Level Security** garante isolamento por agregado familiar a nível de banco.

> Migração futura: a API **Spring Boot 3 / WebFlux** liga-se ao mesmo Postgres; a app
> Flutter só troca a implementação do repositório (a interface não muda).

## Modelo de dados
Ver [`/supabase/schema.sql`](../supabase/schema.sql). Tabelas:

| Tabela | Descrição |
|---|---|
| `households` | O agregado familiar (a "família"). |
| `profiles` | Perfil 1:1 com `auth.users`; persona, situação, papel, dependentes. |
| `transactions` | Receitas/Despesas (`tx_type`), categoria, valor, data. |
| `goals` | Sonhos/metas com `target_amount` e `saved_amount`. |
| `assets` | Activos e passivos (`is_liability`) para o património. |

Relações: `profiles.household_id → households`, e `transactions/goals/assets.household_id
→ households`. Índice `idx_tx_household_date` para listagens rápidas.

## Segurança (RLS)
Todas as tabelas têm RLS ativa. A função `current_household()` resolve o agregado da
utilizadora autenticada; as policies restringem `select/insert/update/delete` ao próprio
agregado. Nenhum dado cruza entre famílias.

## Como aplicar
```bash
# Opção A — SQL editor do Supabase: colar schema.sql e depois seed.sql.
# Opção B — Supabase CLI:
supabase db push          # aplica o schema
psql "$DATABASE_URL" -f supabase/seed.sql   # dados de demonstração
```

## Configurar a app
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key>
```
Sem estas variáveis a app corre em modo offline (repositórios in-memory).

## Outros recursos próprios (roadmap)
- **Redis** — cache de sessões/indicadores (produção).
- **Azure Blob Storage** — média da Academia e Marketplace (ou Supabase Storage no MVP).
- **Azure OpenAI** — MAJU IA, via Edge Function (a chave nunca chega ao cliente).
- **Power BI Embedded** — dashboards internos e KPIs comerciais.
