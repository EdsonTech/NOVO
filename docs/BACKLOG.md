# MAJU — Backlog (Épicos → User Stories → Tasks)

Formato: cada épico mapeia uma jornada. Stories no formato
*"Como [persona], quero [objetivo], para [benefício]"*. Tasks são acionáveis e
estimadas em **story points (SP)**. Estado: ⬜ a fazer · 🟨 em curso · ✅ feito.

---

## ÉPICO 1 — Onboarding Inteligente  *(Squad A · S1)*
**US1.1** Como nova utilizadora, quero escolher quem sou e a minha situação familiar,
para receber metas personalizadas.
- ✅ T1.1.1 Splash com branding e CTA (1 SP)
- ✅ T1.1.2 Tela "Quem é você?" (multi-persona, seleção) (2 SP)
- ✅ T1.1.3 Tela "Situação Familiar" + dependentes (2 SP)
- ✅ T1.1.4 Tela "Diagnóstico Financeiro" (receitas/despesas) (3 SP)
- ⬜ T1.1.5 Persistir perfil em `profiles` (Supabase) (2 SP)

## ÉPICO 2 — Autenticação & Conta  *(Squad C · S2)*
**US2.1** Como utilizadora, quero entrar com email + OTP, para proteger os meus dados.
- ⬜ T2.1.1 Supabase Auth (email/OTP SMS) (3 SP)
- ⬜ T2.1.2 Guarda de rotas (redirect se não autenticada) (2 SP)
- ⬜ T2.1.3 Tela Configurações (perfil, notificações, idioma, segurança) (3 SP)
- ⬜ T2.1.4 MFA / OTP (Azure AD B2C na produção) (5 SP)

## ÉPICO 3 — Dashboard  *(Squad A · S3)*
**US3.1** Como administradora, quero ver o saldo familiar e indicadores num ecrã.
- ✅ T3.1.1 Hero card saldo + receitas/despesas (2 SP)
- ✅ T3.1.2 Grelha de indicadores (crescimento, poupança, sonhos, património) (2 SP)
- ✅ T3.1.3 Atalhos rápidos (receita/despesa/meta/negócio) (1 SP)
- ⬜ T3.1.4 Cartão de recomendação IA ligado ao serviço (3 SP)

## ÉPICO 4 — Finanças  *(Squad A · S4–S5)*
**US4.1** Como utilizadora, quero registar e categorizar receitas e despesas.
- ✅ T4.1.1 Modelo `Transaction` + repositório (interface) (2 SP)
- ✅ T4.1.2 Impl. in-memory (mock) + impl. Supabase (3 SP)
- ✅ T4.1.3 Lista de movimentos + totais live (Riverpod) (3 SP)
- ✅ T4.1.4 Formulário "Nova Receita/Despesa" com validação (3 SP)
- ✅ T4.1.5 Fluxo de Caixa (gráfico entrada vs saída, `fl_chart`) (3 SP)
- ✅ T4.1.6 Dívidas + plano de liquidação (avalanche) (5 SP)

## ÉPICO 5 — Família  *(Squad A · S6)*
**US5.1** Como administradora, quero convidar o cônjuge e gerir permissões.
- ✅ T5.1.1 Lista de membros do agregado (2 SP)
- ⬜ T5.1.2 Convite (WhatsApp/SMS/Email) por deep link (3 SP)
- ⬜ T5.1.3 Permissões (ver/aprovar/definir metas) (3 SP)
- ⬜ T5.1.4 Conselho Familiar (resumo mensal + recomendações) (3 SP)

## ÉPICO 6 — Sonhos & Metas  *(Squad A · S6)*
- ✅ T6.1 Lista de sonhos com progresso (repositório live/mock) (2 SP)
- ✅ T6.2 Criar meta (valor, prazo, contribuição) (3 SP)
- ✅ T6.3 Simulador "quanto preciso poupar?" (2 SP)

## ÉPICO 7 — Desafio 1 Milhão  *(Squad B · S7)*
- ✅ T7.1 Objetivo + progresso (2 SP)
- ✅ T7.2 Plano Inteligente (gap atual vs desejado) (3 SP)
- ✅ T7.3 Plano de Crescimento (sugestões de receita) (3 SP)

## ÉPICO 8 — Empreendedorismo  *(Squad B · S8)*
- ⬜ T8.1 Centro de Negócios (ideias) (2 SP)
- ⬜ T8.2 Plano de Negócio simplificado (investimento/lucro/retorno) (3 SP)
- ⬜ T8.3 Marketplace MVP (produtos/serviços/parcerias) (5 SP)

## ÉPICO 9 — Academia MAJU  *(Squad B · S9)*
- ⬜ T9.1 Níveis 1–4 com bloqueio progressivo (3 SP)
- ⬜ T9.2 Curso (vídeo, PDF, quiz, certificado) (5 SP)

## ÉPICO 10 — MAJU IA  *(Squad C · S10)*
- ✅ T10.1 Edge Function `maju-ai` → Azure OpenAI (proxy seguro, chave server-side) (5 SP)
- ✅ T10.2 Chat financeiro (`AiChatScreen`, repo live/mock) (5 SP)
- ✅ T10.4 **Digitalizar comprovante** → extração (visão) → classificação → lançamento automático (8 SP)
  - ✅ `image_picker` (câmara/galeria), `ReceiptScan` (domínio), `AiRepository` (mock + Edge Function)
  - ✅ `CategoryClassifier` local (normaliza/valida a categoria do modelo)
  - ✅ Ecrã de revisão editável + criação da `Transaction` via `addTransactionProvider`
- 🟨 T10.3 Assistente Familiar (análise, alertas, sugestões) — chat base feito; alertas pendentes (3 SP)

## ÉPICO 11 — Património  *(Squad C · S11)*
- ✅ T11.1 Activos/passivos (repo live/mock) + lista (3 SP)
- ✅ T11.2 Património líquido + evolução anual (`fl_chart` BarChart) (3 SP)

## ÉPICO 12 — Microcrédito  *(Squad C · S12)*
- ✅ T12.1 Cálculo do Score MAJU (0–1000, derivado de finanças/dívidas/metas) (5 SP)
- ✅ T12.2 Elegibilidade (microcrédito/seguro/investimento) (3 SP)
- 🟨 T12.3 Pedido de microcrédito — CTA + confirmação feita; workflow/back-office pendente (5 SP)

---

### Dívida técnica / transversal
- ✅ CI: `flutter analyze` + `flutter test` no PR (`.github/workflows/flutter.yml`).
- ⬜ Fontes Montserrat/Inter empacotadas em `app/assets/fonts/`.
- ⬜ i18n (pt-AO base, en) com `flutter_localizations`.
- ⬜ Observabilidade (Sentry/Crashlytics) + analytics de produto.
- ⬜ Migrar repositórios para a API Spring Boot quando disponível.
