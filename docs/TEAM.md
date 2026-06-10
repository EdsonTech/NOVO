# MAJU — Organização da Equipa

Estrutura para levar o MAJU de protótipo a produto nacional (Angola → PALOPs).
Modelo: **squads multidisciplinares** sob um núcleo de produto/plataforma.

## 1. Liderança & Núcleo (Core)

| Papel | Responsabilidade | Nº |
|---|---|---|
| **Product Owner (PO)** | Visão, backlog, prioridades, stakeholders | 1 |
| **Tech Lead / Arquiteto** | Arquitetura, decisões técnicas, code review final | 1 |
| **Engineering Manager / Scrum Master** | Processo ágil, remoção de impedimentos, cerimónias | 1 |
| **UX/UI Lead** | Design system MAJU, protótipos, pesquisa com utilizadoras | 1 |

## 2. Squads de produto

### 🟦 Squad A — Finanças & Família (core do app)
*Jornadas 1–5: Onboarding, Dashboard, Finanças, Família, Sonhos.*
- 1 Mobile Lead (Flutter) + 2 Mobile Devs (Flutter)
- 1 Backend Dev (Spring Boot / Supabase)
- 1 QA Engineer
- 1 UI Designer (partilhado com UX Lead)

### 🟧 Squad B — Crescimento & Empreendedorismo
*Jornadas 6–8: Desafio 1 Milhão, Centro de Negócios, Marketplace, Academia.*
- 1 Mobile Lead (Flutter) + 1 Mobile Dev
- 1 Backend Dev
- 1 Content/Education Specialist (Academia MAJU)
- 1 QA (partilhado)

### 🟩 Squad C — IA, Património & Crédito (Data/Platform)
*Jornadas 9–11: MAJU IA, Património, Score, Microcrédito + Configurações.*
- 1 Data/ML Engineer (Azure OpenAI, score, recomendações)
- 1 Backend Dev (WebFlux, integrações bancárias/crédito)
- 1 Mobile Dev (Flutter)
- 1 Security/Compliance Engineer (MFA, OTP, KYC, RLS)

## 3. Plataforma & Operações (transversal)
| Papel | Responsabilidade |
|---|---|
| **DevOps / SRE** | CI/CD, Azure, monitorização, IaC |
| **Cloud/Infra (Azure)** | AD B2C, Postgres, Redis, Edge |
| **Data Analyst (BI)** | Power BI, métricas de produto, KPIs comerciais |
| **Suporte & Sucesso** | Onboarding de utilizadoras, feedback, NPS |

## 4. RACI resumido

| Atividade | PO | Tech Lead | Squad Dev | QA | DevOps | UX |
|---|----|-----------|-----------|----|--------|----|
| Definir backlog | **A** | C | C | I | I | C |
| Arquitetura | C | **A** | C | I | C | I |
| Implementar feature | I | C | **R** | C | I | C |
| Testes & qualidade | I | C | C | **R** | I | I |
| Release & deploy | C | C | C | C | **R** | I |
| Design & usabilidade | C | I | C | I | I | **R** |

> R = Responsible · A = Accountable · C = Consulted · I = Informed

## 5. Cadência ágil (Scrum)
- **Sprint:** 2 semanas.
- **Cerimónias:** Planning (seg, início), Daily (15 min), Refinement (meio do sprint),
  Review/Demo + Retro (sex, fim).
- **Definition of Done:** código revisto (≥1 aprovação) · testes a passar · lints limpos
  (`flutter analyze`) · sem regressões na demo · atualizado em `/docs` quando aplicável.
- **Branching:** `main` (protegido) ← PRs de `feat/*`, `fix/*`, `chore/*`. Squad merge
  após review + CI verde.

Mapa de sprints e tarefas: ver [`SPRINTS.md`](./SPRINTS.md) e [`BACKLOG.md`](./BACKLOG.md).
