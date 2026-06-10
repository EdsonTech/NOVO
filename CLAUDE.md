# CLAUDE.md

Guidance for AI assistants (Claude Code and others) working in this repository.

## Project overview

**MAJU Finanças** — *"Organize Hoje. Prospere Amanhã."* — is a financial wellbeing
platform for Angolan families and women entrepreneurs (target market: Angola + PALOPs).
The product vision goes beyond expense tracking: it's an ecosystem of family financial
prosperity and female entrepreneurship, structured around four journeys — **Financeira,
Familiar, Empreendedora, Patrimonial**.

This repository currently contains the **functional front-end prototype (MAJU 1.0)** — a
clickable, mobile-first single-page web app that implements all **30 screens across 12
journeys** with MAJU branding, navigation, mock data, and simple charts. It exists to
validate the UX and demo the product before the native build.

> The previous contents of this repo (a W3Layouts "Freightage" static template) were
> removed and replaced by this app.

## Tech stack (current prototype)

- **Plain HTML + CSS + vanilla JavaScript** — no framework, no build step, no backend.
- A small hand-written **JS router** drives a screen registry (one function per screen).
- **Google Fonts**: Montserrat (headings) + Inter (body). Charts are inline **SVG**.
- Mobile-first; renders inside a centered phone-width "device" frame on desktop.

## Production target (roadmap, NOT yet built)

The intended production architecture — document/respect when planning the real build:

- **Frontend:** Flutter + Material 3, responsive
- **Backend:** Spring Boot 3 / Java 21 / WebFlux
- **Data:** PostgreSQL · **Cache:** Redis
- **Cloud:** Azure · **IA:** Azure OpenAI · **BI:** Power BI Embedded
- **Auth/Security:** Azure AD B2C, MFA, OTP via SMS

Commercial roadmap: Fase 1 (10k utilizadoras) → Fase 5 (MAJU Invest Angola / Banco Digital).

## Repository structure

```
/
├── index.html          # App shell: device frame, header, screen <main>, bottom tab bar
├── css/
│   └── maju.css        # Full design system (tokens, components, onboarding, charts)
├── js/
│   └── maju.js         # State, mock data, helpers, all 30 screens, router
├── assets/
│   ├── maju-logo.png            # Brand logo (blue "Maju" + orange "FINANÇAS" + bulb/$)
│   └── maju-design-reference.png# Original design mockup + colour palette (reference only)
└── CLAUDE.md
```

There is **no `package.json`** and nothing to install.

## How `js/maju.js` is organised

Read it top-to-bottom; it is intentionally a single file with clear sections:

1. **`state`** — in-memory mock data (`profile`, `receitas`, `despesas`, `sonhos`,
   `activos`). This is the single source of truth; screens render from it.
2. **Helpers** — `kz()` (Kwanza formatter, `pt-PT` grouping + " Kz"), `sum()`, `pct()`,
   `toast()`, and SVG chart builders `barChart()` / `lineChart()`.
3. **Reusable blocks** — `stat()`, `listItem()`, `goalCard()`, etc. Compose screens from
   these instead of writing bespoke markup.
4. **`S` (screens registry)** — `S["screen-id"] = () => ({ html, title?, root?, chrome? })`.
   - `chrome:false` → onboarding screen: hides the header and tab bar (full-bleed).
   - `root:true` → a bottom-tab root: hides the back button.
   - `title` → text shown in the app header.
5. **Router** — `navigate(id)` / `goBack()` over a `history` stack; `render(id)` toggles
   header/tab-bar chrome and highlights the active tab via the `TAB_OF` map.
6. **Event delegation** — one global `click` listener handles `data-*` hooks (below).

### `data-*` interaction hooks (used in screen HTML)

| Attribute | Effect |
|---|---|
| `data-nav="screen-id"` | Navigate to a screen (pushes history) |
| `data-pick="field" data-val="x"` | Single-select chip; writes to `state.profile[field]` |
| `data-toggle` | Toggle a chip/category on/off |
| `data-cat` | Toggle a diagnostic category row |
| `data-add="receita\|despesa"` | Read the form inputs, push to `state`, toast, go back |
| `data-toast="message"` | Show a transient toast |

## Screen map (30 screens / 12 journeys)

`splash → quem-e-voce → situacao → diagnostico` (onboarding) → `home`. Bottom tabs:
**home · financas · familia · sonhos · mais**. Sub-screens hang off these:

- **Finanças:** receitas, despesas, fluxo, dividas, nova-receita, nova-despesa
- **Família:** familia, convite, conselho
- **Sonhos:** sonhos, meta, simulador, desafio, plano-inteligente, plano-crescimento
- **Mais:** negocios, plano-negocio, marketplace, academia, cursos, chat-ia, assistente,
  patrimonio, evolucao, score, elegibilidade, config

## Local development

Static site — no install, no build.

```bash
python3 -m http.server 8000   # then open http://localhost:8000
# or just open index.html in a browser
```

There are no tests or linters. "Verify" = open it and click through the flow you changed.

## Conventions

- **Add a screen:** register `S["new-id"] = () => ({...})`, add it to `TAB_OF` so the
  correct bottom tab highlights, and link to it with `data-nav="new-id"`.
- **Build UI from the existing component helpers and CSS classes** (`.card`, `.hero`,
  `.stat`, `.li`, `.btn--primary/--blue/--ghost`, `.chip`, `.prog`). Don't hand-roll new
  styles when a token/component exists. Brand tokens live in `:root` in `maju.css`
  (`--blue-800`, `--orange-500`, `--green-500`, …).
- **Money is always Kwanza** — format with `kz()`, never hardcode currency strings.
- **Content language is Portuguese (pt-AO).** Keep copy in Portuguese.
- **Keep it dependency-free.** No npm packages, CDNs (besides the Google Fonts link), or
  frameworks in the prototype. Charts stay as inline SVG.
- **Mock data only** — there is no backend. New "saved" data lives in `state` for the
  session. Don't add real network calls without discussing the production plan first.

## Git workflow

- Active branch: **`claude/claude-md-documentation-bfd1lu`**. Develop, commit, push here;
  do not push to `master` without explicit permission.
- Commit messages are short, often Portuguese (e.g. "atualização 2.1"). Keep them concise.
- Push with `git push -u origin <branch>`; retry transient network errors with backoff.
- **Do not open a pull request unless explicitly asked.**

## Working notes for AI assistants

- The design mockup in `assets/maju-design-reference.png` is the visual source of truth —
  match its blue/orange/green palette and card-based layout when adding screens.
- This is a **prototype**: prioritise a convincing, navigable demo over real persistence,
  auth, or data integrity. Flag clearly when something is mocked.
- When asked to "develop per the prototypes," map the request to the 30-screen / 12-journey
  spec above and reuse existing screen patterns.
- Keep edits surgical and section-scoped; `js/maju.js` is one file — match its style and
  the existing component helpers.
```
