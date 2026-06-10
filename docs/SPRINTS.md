# MAJU — Plano de Sprints (Release 1.0)

Sprints de **2 semanas**. Objetivo do R1.0: app funcional ponta-a-ponta com as 12
jornadas, backend Supabase em produção e onboarding de utilizadoras (Fase 1 = 10.000).

| Sprint | Tema | Squad | Entregável (incremento demonstrável) |
|---|---|---|---|
| **S0** | Fundações | Core + DevOps | Repo, CI/CD, projeto Flutter, design system, tema MAJU, Supabase provisionado, RLS base. ✅ *scaffold neste repo* |
| **S1** | Onboarding | A | Splash + 3 passos (persona, situação, diagnóstico) ligados ao perfil. ✅ |
| **S2** | Auth & Conta | C + A | Registo/login (email+OTP via Supabase), perfil, Configurações, segurança (MFA). |
| **S3** | Dashboard | A | Home com saldo, indicadores, atalhos, dados reais do agregado familiar. ✅ *(mock→live)* |
| **S4** | Finanças I | A | Receitas/Despesas: lista, criar, categorizar, totais live. ✅ |
| **S5** | Finanças II | A | Fluxo de caixa (gráficos `fl_chart`), Dívidas + plano de liquidação. |
| **S6** | Família & Sonhos | A | Convite ao cônjuge (deep link), permissões, Conselho Familiar; Sonhos/Metas/Simulador. ✅ *(Sonhos base)* |
| **S7** | Desafio 1 Milhão | B | Objetivo, Plano Inteligente (gap), Plano de Crescimento. |
| **S8** | Empreendedorismo | B | Centro de Negócios, Plano de Negócio simplificado, Marketplace MVP. |
| **S9** | Academia | B | Níveis 1–4, cursos (vídeo/PDF/quiz), certificados. |
| **S10** | MAJU IA | C | Chat IA (Azure OpenAI via Edge Function), Assistente Familiar, alertas. |
| **S11** | Património | C | Activos, evolução patrimonial, património líquido. |
| **S12** | Microcrédito | C | Score MAJU (0–1000), elegibilidade, pedido de microcrédito. |
| **S13** | Hardening | Todas | Performance, acessibilidade, i18n, testes E2E, beta fechado. |
| **S14** | Lançamento | Todas + Ops | Stores (Play/App Store), monitorização, suporte, campanha Fase 1. |

> ✅ = já presente no scaffold/protótipo deste repositório.

## Roadmap comercial (paralelo ao técnico)
- **Fase 1** — 10.000 utilizadoras (R1.0)
- **Fase 2** — 100.000 famílias (R1.x: parcerias, marketplace ativo)
- **Fase 3** — 1.000.000 utilizadores (R2.0: escala regional PALOPs)
- **Fase 4** — Banco Digital MAJU (licenciamento, integrações bancárias)
- **Fase 5** — MAJU Invest Angola (investimentos, produtos financeiros)

## Métricas de sucesso por sprint
- Velocity estável por squad · burndown sem dívida acumulada.
- DoD cumprida em 100% das stories entregues.
- Cobertura de testes nos repositórios/domínio ≥ 70%.
- KPIs de produto: ativação (onboarding completo), retenção D7/D30, famílias com 2+ membros.
