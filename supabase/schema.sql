-- =============================================================================
-- MAJU Finanças — PostgreSQL schema (Supabase)
-- Managed Postgres + Row Level Security. Mirrors the domain in /app and the
-- future Spring Boot API. Run in the Supabase SQL editor or via `supabase db push`.
-- =============================================================================

create extension if not exists "uuid-ossp";

-- ---- Households (a família) -------------------------------------------------
create table if not exists households (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null,
  created_at  timestamptz not null default now()
);

-- ---- Profiles (1:1 with auth.users) ----------------------------------------
create type member_role as enum ('admin', 'spouse', 'child', 'dependent');
create type persona_type as enum (
  'mulher','homem','casal','mae_solteira',
  'empreendedora','funcionaria_publica','trabalhadora_independente'
);

create table if not exists profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  household_id  uuid references households(id) on delete set null,
  full_name     text not null,
  persona       persona_type,
  civil_status  text,
  dependents    int default 0,
  role          member_role not null default 'admin',
  created_at    timestamptz not null default now()
);

-- ---- Transactions (receitas / despesas) ------------------------------------
create type tx_type as enum ('income', 'expense');

create table if not exists transactions (
  id            uuid primary key default uuid_generate_v4(),
  household_id  uuid not null references households(id) on delete cascade,
  created_by    uuid references profiles(id) on delete set null,
  type          tx_type not null,
  title         text not null,
  category      text not null,
  amount        numeric(14,2) not null check (amount > 0),
  date          date not null default current_date,
  created_at    timestamptz not null default now()
);
create index if not exists idx_tx_household_date on transactions(household_id, date desc);

-- ---- Goals / Sonhos ---------------------------------------------------------
create table if not exists goals (
  id            uuid primary key default uuid_generate_v4(),
  household_id  uuid not null references households(id) on delete cascade,
  title         text not null,
  icon          text,
  target_amount numeric(14,2) not null check (target_amount > 0),
  saved_amount  numeric(14,2) not null default 0,
  deadline      date,
  created_at    timestamptz not null default now()
);

-- ---- Assets / Património ----------------------------------------------------
create table if not exists assets (
  id            uuid primary key default uuid_generate_v4(),
  household_id  uuid not null references households(id) on delete cascade,
  title         text not null,
  category      text,
  value         numeric(14,2) not null default 0,
  is_liability  boolean not null default false,
  created_at    timestamptz not null default now()
);

-- =============================================================================
-- Row Level Security: a user only ever sees their own household's data.
-- =============================================================================
alter table households   enable row level security;
alter table profiles     enable row level security;
alter table transactions enable row level security;
alter table goals        enable row level security;
alter table assets       enable row level security;

-- Helper: the caller's household id
create or replace function current_household() returns uuid
language sql stable security definer as $$
  select household_id from profiles where id = auth.uid()
$$;

create policy "own profile" on profiles
  for all using (id = auth.uid()) with check (id = auth.uid());

create policy "household read" on households
  for select using (id = current_household());

create policy "tx by household" on transactions
  for all using (household_id = current_household())
  with check (household_id = current_household());

create policy "goals by household" on goals
  for all using (household_id = current_household())
  with check (household_id = current_household());

create policy "assets by household" on assets
  for all using (household_id = current_household())
  with check (household_id = current_household());
