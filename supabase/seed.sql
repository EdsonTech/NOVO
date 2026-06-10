-- =============================================================================
-- MAJU — demo seed data (matches the prototype's mock figures).
-- Run AFTER schema.sql. Replace the auth user id with a real one from
-- auth.users when testing RLS end-to-end.
-- =============================================================================

insert into households (id, name)
values ('11111111-1111-1111-1111-111111111111', 'Família Silva')
on conflict do nothing;

-- Receitas
insert into transactions (household_id, type, title, category, amount, date) values
('11111111-1111-1111-1111-111111111111','income','Salário','Salário',350000,'2026-06-01'),
('11111111-1111-1111-1111-111111111111','income','Negócio','Negócio',120000,'2026-06-03'),
('11111111-1111-1111-1111-111111111111','income','Freelance','Freelance',45000,'2026-06-05'),
('11111111-1111-1111-1111-111111111111','income','Comissões','Comissões',30000,'2026-06-08');

-- Despesas
insert into transactions (household_id, type, title, category, amount, date) values
('11111111-1111-1111-1111-111111111111','expense','Alimentação','Alimentação',95000,'2026-06-02'),
('11111111-1111-1111-1111-111111111111','expense','Transporte','Transporte',40000,'2026-06-04'),
('11111111-1111-1111-1111-111111111111','expense','Habitação','Habitação',80000,'2026-06-05'),
('11111111-1111-1111-1111-111111111111','expense','Educação','Educação',60000,'2026-06-06'),
('11111111-1111-1111-1111-111111111111','expense','Saúde','Saúde',25000,'2026-06-07');

-- Sonhos
insert into goals (household_id, title, icon, target_amount, saved_amount) values
('11111111-1111-1111-1111-111111111111','Casa Própria','home',8000000,2600000),
('11111111-1111-1111-1111-111111111111','Viatura','car',4500000,1800000),
('11111111-1111-1111-1111-111111111111','Universidade','school',3000000,900000),
('11111111-1111-1111-1111-111111111111','Viagem','globe',1200000,350000);

-- Património
insert into assets (household_id, title, category, value, is_liability) values
('11111111-1111-1111-1111-111111111111','Casa','imovel',12000000,false),
('11111111-1111-1111-1111-111111111111','Terreno','imovel',4500000,false),
('11111111-1111-1111-1111-111111111111','Viatura','veiculo',3200000,false),
('11111111-1111-1111-1111-111111111111','Empréstimo BAI','divida',1200000,true);
