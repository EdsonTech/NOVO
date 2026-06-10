/* =============================================================================
   MAJU Finanças — Functional Prototype (MAJU 1.0)
   Single-page app. No framework. Hash-less JS router over a screens registry.
   30 screens across 12 journeys, mock data, onboarding flow, bottom-tab nav.
   ============================================================================= */
(function () {
  "use strict";

  /* ---------------------------------------------------------------- State --- */
  const state = {
    profile: { persona: "Empreendedora", civil: "Casada", deps: "2", name: "Maria Silva" },
    receitas: [
      { t: "Salário", s: "Mensal · Função Pública", v: 350000, i: "💼", c: "bg-blue fg-blue" },
      { t: "Negócio", s: "Catering MAJU", v: 120000, i: "🏪", c: "bg-orange fg-orange" },
      { t: "Freelance", s: "Design gráfico", v: 45000, i: "💻", c: "bg-green fg-green" },
      { t: "Comissões", s: "Vendas", v: 30000, i: "📈", c: "bg-blue fg-blue" },
    ],
    despesas: [
      { t: "Alimentação", v: 95000, i: "🍚", c: "bg-orange fg-orange" },
      { t: "Transporte", v: 40000, i: "🚕", c: "bg-blue fg-blue" },
      { t: "Habitação", v: 80000, i: "🏠", c: "bg-green fg-green" },
      { t: "Educação", v: 60000, i: "🎓", c: "bg-blue fg-blue" },
      { t: "Saúde", v: 25000, i: "🏥", c: "bg-red fg-red" },
      { t: "Telecomunicações", v: 18000, i: "📱", c: "bg-orange fg-orange" },
    ],
    sonhos: [
      { t: "Casa Própria", i: "🏠", goal: 8000000, saved: 2600000 },
      { t: "Viatura", i: "🚗", goal: 4500000, saved: 1800000 },
      { t: "Universidade", i: "🎓", goal: 3000000, saved: 900000 },
      { t: "Viagem", i: "🌍", goal: 1200000, saved: 350000 },
    ],
    activos: [
      { t: "Casa", v: 12000000, i: "🏠" },
      { t: "Terreno", v: 4500000, i: "🌳" },
      { t: "Viatura", v: 3200000, i: "🚗" },
      { t: "Negócio", v: 2800000, i: "🏪" },
      { t: "Poupanças", v: 1650000, i: "🏦" },
    ],
  };

  /* --------------------------------------------------------------- Helpers --- */
  const $ = (s, r = document) => r.querySelector(s);
  const kz = (n) => n.toLocaleString("pt-PT") + " Kz";
  const sum = (a, k = "v") => a.reduce((t, x) => t + x[k], 0);
  const pct = (a, b) => Math.min(100, Math.round((a / b) * 100));

  function toast(msg) {
    const t = document.createElement("div");
    t.className = "toast";
    t.textContent = msg;
    document.body.appendChild(t);
    setTimeout(() => t.remove(), 2200);
  }

  // Simple responsive bar chart
  function barChart(vals, labels, color) {
    const w = 320, h = 130, max = Math.max(...vals), bw = w / vals.length;
    let bars = "";
    vals.forEach((v, i) => {
      const bh = (v / max) * (h - 24), x = i * bw + bw * 0.18, y = h - bh - 18;
      bars += `<rect x="${x}" y="${y}" width="${bw * 0.64}" height="${bh}" rx="5" fill="${color}"/>`;
      bars += `<text x="${i * bw + bw / 2}" y="${h - 4}" text-anchor="middle" font-size="10" fill="#9AA4B2">${labels[i]}</text>`;
    });
    return `<svg viewBox="0 0 ${w} ${h}" class="chart">${bars}</svg>`;
  }

  // Dual-line area chart (entrada vs saída)
  function lineChart(serieA, serieB, labels) {
    const w = 320, h = 150, pad = 18, max = Math.max(...serieA, ...serieB) * 1.1;
    const X = (i) => pad + (i * (w - pad * 2)) / (labels.length - 1);
    const Y = (v) => h - pad - (v / max) * (h - pad * 2);
    const path = (s) => s.map((v, i) => `${i ? "L" : "M"}${X(i)},${Y(v)}`).join(" ");
    const area = (s, col) =>
      `<path d="${path(s)} L${X(s.length - 1)},${h - pad} L${X(0)},${h - pad} Z" fill="${col}" opacity=".12"/>` +
      `<path d="${path(s)}" fill="none" stroke="${col}" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>`;
    const lab = labels.map((l, i) => `<text x="${X(i)}" y="${h - 4}" text-anchor="middle" font-size="10" fill="#9AA4B2">${l}</text>`).join("");
    return `<svg viewBox="0 0 ${w} ${h}" class="chart">${area(serieA, "#27A567")}${area(serieB, "#E0533D")}${lab}</svg>`;
  }

  /* ------------------------------------------------------- Reusable blocks --- */
  const stat = (ico, cls, label, value) =>
    `<div class="stat"><div class="stat__ico ${cls}">${ico}</div><div class="stat__label">${label}</div><div class="stat__value">${value}</div></div>`;

  const listItem = (o) =>
    `<div class="li"><div class="li__ico ${o.c || "bg-blue fg-blue"}">${o.i}</div>` +
    `<div class="li__body"><div class="li__title">${o.t}</div>${o.s ? `<div class="li__sub">${o.s}</div>` : ""}</div>` +
    `<div class="li__amt ${o.amtClass || ""}">${o.amt}</div>${o.chev ? '<div class="li__chev">›</div>' : ""}</div>`;

  const goalCard = (g) => {
    const p = pct(g.saved, g.goal);
    return `<div class="card" data-nav="meta"><div class="li" style="padding:0">
      <div class="li__ico bg-orange fg-orange">${g.i}</div>
      <div class="li__body"><div class="li__title">${g.t}</div>
      <div class="li__sub">${kz(g.saved)} de ${kz(g.goal)}</div></div>
      <div class="li__amt fg-orange">${p}%</div></div>
      <div class="prog"><div class="prog__fill" style="width:${p}%"></div></div></div>`;
  };

  /* ============================================================== SCREENS === */
  const S = {};

  /* --- Jornada 1 · Onboarding ------------------------------------------- */
  S.splash = () => ({
    chrome: false,
    html: `<div class="ob ob--splash">
      <img class="ob__logo ob__logo--white" src="assets/maju-logo.png" alt="MAJU" />
      <div class="splash-tag">Organize Hoje.<br/>Prospere Amanhã.</div>
      <div class="splash-sub">Prosperidade financeira familiar · Angola</div>
      <button class="btn btn--primary" data-nav="quem-e-voce" style="max-width:280px">Começar</button>
    </div>`,
  });

  S["quem-e-voce"] = () => ({
    chrome: false,
    html: obShell(1, "Passo 1 de 3", "Quem é você?", "Vamos personalizar a sua jornada financeira.",
      `<div class="chips">${["Mulher", "Homem", "Casal", "Mãe Solteira", "Empreendedora", "Funcionária Pública", "Trabalhadora Independente"]
        .map((o) => `<button class="chip${o === state.profile.persona ? " is-on" : ""}" data-pick="persona" data-val="${o}">${o}</button>`).join("")}</div>`,
      "situacao"),
  });

  S.situacao = () => ({
    chrome: false,
    html: obShell(2, "Passo 2 de 3", "Situação Familiar", "Para adaptarmos metas e recomendações.",
      `<div class="chips">${["Solteira", "Casada", "União de Facto", "Divorciada"]
        .map((o) => `<button class="chip chip--lg${o === state.profile.civil ? " is-on" : ""}" data-pick="civil" data-val="${o}">${o}</button>`).join("")}</div>
       <div class="sec-title">Dependentes</div>
       <div class="chips">${["0", "1", "2", "3+", "Personalizado"]
        .map((o) => `<button class="chip${o === state.profile.deps ? " is-on" : ""}" data-pick="deps" data-val="${o}">${o}</button>`).join("")}</div>`,
      "diagnostico"),
  });

  S.diagnostico = () => ({
    chrome: false,
    html: obShell(3, "Passo 3 de 3", "Diagnóstico Financeiro", "Receitas e despesas para começar.",
      `<div class="sec-title" style="margin-top:0">Receita mensal</div>
       <div class="chips">${["Salário", "Negócio", "Outros"].map((o) => `<button class="chip is-on" data-toggle>${o}</button>`).join("")}</div>
       <div class="field" style="margin-top:14px"><label>Valor estimado</label><div class="input-kz"><input type="tel" inputmode="numeric" placeholder="450.000" value="545.000"/></div></div>
       <div class="sec-title">Despesas principais</div>
       ${["🍚 Alimentação", "🎓 Escola", "🚕 Transporte", "⚡ Energia", "💧 Água", "🌐 Internet", "🏥 Saúde"]
        .map((o) => { const [ic, ...n] = o.split(" "); return `<div class="cat is-on" data-cat><span class="cat__ico">${ic}</span><span class="cat__name">${n.join(" ")}</span><span class="cat__check">✓</span></div>`; }).join("")}`,
      "home", "Concluir"),
  });

  function obShell(step, kicker, h, p, body, next, cta) {
    return `<div class="ob">
      <div class="ob__top"><span class="ob__step">${kicker}</span>
        <h2 class="ob__h">${h}</h2><p class="ob__p">${p}</p></div>
      <div class="ob__body">${body}</div>
      <div class="ob__foot">
        <div class="dots">${[0, 1, 2].map((i) => `<span class="dot${i === step - 1 ? " is-on" : ""}"></span>`).join("")}</div>
        <button class="btn btn--primary" data-nav="${next}">${cta || "Continuar"}</button>
      </div></div>`;
  }

  /* --- Jornada 2 · Dashboard -------------------------------------------- */
  S.home = () => {
    const rec = sum(state.receitas), desp = sum(state.despesas), saldo = rec - desp, pat = sum(state.activos);
    return {
      title: "MAJU", root: true,
      html: `<div class="pad">
        <p style="color:var(--ink-2);font-size:14px;margin:0 0 14px">Olá, <b style="color:var(--blue-800)">${state.profile.name.split(" ")[0]}</b> 👋</p>
        <div class="hero">
          <div class="hero__label">Saldo Familiar</div>
          <div class="hero__value">${kz(saldo)}</div>
          <div class="hero__row">
            <div class="hero__pill"><small>Receitas</small><b>${kz(rec)}</b></div>
            <div class="hero__pill"><small>Despesas</small><b>${kz(desp)}</b></div>
          </div>
        </div>
        <div class="actions">
          <div class="action" data-nav="nova-receita"><div class="action__circle">➕</div><span>Receita</span></div>
          <div class="action" data-nav="nova-despesa"><div class="action__circle">➖</div><span>Despesa</span></div>
          <div class="action" data-nav="meta"><div class="action__circle">🎯</div><span>Meta</span></div>
          <div class="action" data-nav="negocios"><div class="action__circle">🏪</div><span>Negócio</span></div>
        </div>
        <div class="sec-title">Indicadores</div>
        <div class="grid-2">
          ${stat("📈", "bg-green fg-green", "Crescimento Mensal", "+12%")}
          ${stat("💰", "bg-orange fg-orange", "Poupança", kz(saldo))}
          ${stat("🎯", "bg-blue fg-blue", "Sonhos Ativos", state.sonhos.length)}
          ${stat("🏠", "bg-green fg-green", "Património", kz(pat))}
        </div>
        <div class="row-between sec-title"><span>Sonhos da família</span><a class="link" data-nav="sonhos">Ver todos</a></div>
        ${goalCard(state.sonhos[0])}
        <div class="card" data-nav="conselho" style="margin-top:12px">
          <div class="li" style="padding:0"><div class="li__ico bg-blue fg-blue">🤖</div>
          <div class="li__body"><div class="li__title">Recomendação da IA</div>
          <div class="li__sub">Reduza 8% em transporte e atinja a meta da Viatura 2 meses antes.</div></div>
          <div class="li__chev">›</div></div>
        </div>
      </div>`,
    };
  };

  /* --- Jornada 3 · Finanças --------------------------------------------- */
  S.financas = () => ({
    title: "Finanças", root: true,
    html: `<div class="pad">
      <div class="hero" style="background:linear-gradient(150deg,#15396B,#1F5AA8)">
        <div class="hero__label">Resultado do mês</div>
        <div class="hero__value">${kz(sum(state.receitas) - sum(state.despesas))}</div>
        <div class="hero__row"><div class="hero__pill"><small>Entradas</small><b>${kz(sum(state.receitas))}</b></div>
        <div class="hero__pill"><small>Saídas</small><b>${kz(sum(state.despesas))}</b></div></div>
      </div>
      <div class="grid-2" style="margin-top:14px">
        <div class="stat" data-nav="receitas"><div class="stat__ico bg-green fg-green">📥</div><div class="stat__label">Receitas</div><div class="stat__value">${kz(sum(state.receitas))}</div></div>
        <div class="stat" data-nav="despesas"><div class="stat__ico bg-red fg-red">📤</div><div class="stat__label">Despesas</div><div class="stat__value">${kz(sum(state.despesas))}</div></div>
        <div class="stat" data-nav="fluxo"><div class="stat__ico bg-blue fg-blue">📊</div><div class="stat__label">Fluxo de Caixa</div><div class="stat__value">Ver</div></div>
        <div class="stat" data-nav="dividas"><div class="stat__ico bg-orange fg-orange">💳</div><div class="stat__label">Dívidas</div><div class="stat__value">3 ativas</div></div>
      </div></div>`,
  });

  S.receitas = () => ({
    title: "Receitas",
    html: `<div class="pad">
      <div class="sec-title" style="margin-top:0">Total ${kz(sum(state.receitas))}</div>
      <div class="list">${state.receitas.map((r) => listItem({ ...r, amt: kz(r.v), amtClass: "amt-pos" })).join("")}</div>
      <button class="btn btn--primary" style="margin-top:18px" data-nav="nova-receita">+ Nova Receita</button>
    </div>`,
  });

  S.despesas = () => ({
    title: "Despesas",
    html: `<div class="pad">
      <div class="sec-title" style="margin-top:0">Total ${kz(sum(state.despesas))}</div>
      <div class="list">${state.despesas.map((d) => listItem({ ...d, s: "Categoria", amt: kz(d.v), amtClass: "amt-neg" })).join("")}</div>
      <button class="btn btn--primary" style="margin-top:18px" data-nav="nova-despesa">+ Nova Despesa</button>
    </div>`,
  });

  S.fluxo = () => ({
    title: "Fluxo de Caixa",
    html: `<div class="pad">
      <div class="card">
        <div class="row-between"><b style="font-family:Montserrat">Entrada vs Saída</b><span class="badge badge--green">+12%</span></div>
        ${lineChart([420, 480, 510, 540, 500, 545], [380, 410, 430, 460, 440, 410], ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun"])}
        <div class="legend"><span><i style="background:#27A567"></i>Entradas</span><span><i style="background:#E0533D"></i>Saídas</span></div>
      </div>
      <div class="grid-2" style="margin-top:12px">
        ${stat("📥", "bg-green fg-green", "Média entradas", "499.000 Kz")}
        ${stat("📤", "bg-red fg-red", "Média saídas", "421.000 Kz")}
      </div></div>`,
  });

  S.dividas = () => ({
    title: "Dívidas",
    html: `<div class="pad">
      <div class="list">
        ${listItem({ i: "🏦", c: "bg-blue fg-blue", t: "Empréstimo BAI", s: "Saldo 1.200.000 Kz", amt: "24x", amtClass: "amt-neg" })}
        ${listItem({ i: "💳", c: "bg-orange fg-orange", t: "Cartão de Crédito", s: "Saldo 180.000 Kz", amt: "rotativo", amtClass: "amt-neg" })}
        ${listItem({ i: "🤝", c: "bg-red fg-red", t: "Crédito Informal (Kixikila)", s: "Saldo 90.000 Kz", amt: "3x", amtClass: "amt-neg" })}
      </div>
      <div class="card" style="margin-top:14px"><b style="font-family:Montserrat">Plano de Liquidação</b>
        <p style="font-size:13px;color:var(--ink-2);margin:8px 0 0">Pagando 150.000 Kz/mês pelo método avalanche, fica livre de dívidas em <b>11 meses</b> e poupa 240.000 Kz em juros.</p>
        <div class="prog prog--green"><div class="prog__fill" style="width:38%"></div></div>
      </div></div>`,
  });

  /* --- Jornada 4 · Família ---------------------------------------------- */
  S.familia = () => ({
    title: "Família", root: true,
    html: `<div class="pad">
      <div class="list">
        ${famRow("MS", "#1F5AA8", "Maria Silva", "Administradora")}
        ${famRow("JS", "#E8742C", "João Silva", "Cônjuge")}
        ${famRow("AS", "#27A567", "Ana Silva", "Filha · 12 anos")}
        ${famRow("PS", "#E9A93C", "Pedro Silva", "Filho · 8 anos")}
      </div>
      <button class="btn btn--blue" style="margin-top:16px" data-nav="convite">＋ Convidar membro</button>
      <button class="btn btn--ghost" style="margin-top:10px" data-nav="conselho">📋 Conselho Familiar</button>
    </div>`,
  });
  const famRow = (ini, col, name, role) =>
    `<div class="li"><div class="avatar" style="background:${col}">${ini}</div>
     <div class="li__body"><div class="li__title">${name}</div><div class="li__sub">${role}</div></div></div>`;

  S.convite = () => ({
    title: "Convidar Marido",
    html: `<div class="pad">
      <div class="card" style="text-align:center">
        <div class="avatar" style="background:#E8742C;width:64px;height:64px;font-size:24px;margin:6px auto 12px">＋</div>
        <b style="font-family:Montserrat">Convide o seu cônjuge</b>
        <p style="font-size:13px;color:var(--ink-2);margin:6px 0 0">Gerir as finanças em conjunto fortalece a família.</p>
      </div>
      <div class="sec-title">Enviar convite por</div>
      <div class="list">
        ${listItem({ i: "🟢", c: "bg-green fg-green", t: "WhatsApp", amt: "›", chev: false })}
        ${listItem({ i: "💬", c: "bg-blue fg-blue", t: "SMS", amt: "›", chev: false })}
        ${listItem({ i: "✉️", c: "bg-orange fg-orange", t: "Email", amt: "›", chev: false })}
      </div>
      <div class="sec-title">Permissões</div>
      <div class="list">
        ${permRow("Visualizar finanças", true)}
        ${permRow("Aprovar despesas", true)}
        ${permRow("Definir metas", false)}
      </div>
      <button class="btn btn--primary" style="margin-top:18px" data-toast="Convite enviado!">Enviar Convite</button>
    </div>`,
  });
  const permRow = (t, on) =>
    `<div class="li"><div class="li__body"><div class="li__title">${t}</div></div>
     <div class="li__amt" style="color:${on ? "var(--green-500)" : "var(--ink-3)"}">${on ? "✓ Ativo" : "Inativo"}</div></div>`;

  S.conselho = () => ({
    title: "Conselho Familiar",
    html: `<div class="pad">
      <div class="sec-title" style="margin-top:0">Resumo de Junho</div>
      <div class="grid-2">
        ${stat("📥", "bg-green fg-green", "Receitas", kz(sum(state.receitas)))}
        ${stat("📤", "bg-red fg-red", "Despesas", kz(sum(state.despesas)))}
        ${stat("💰", "bg-orange fg-orange", "Poupança", kz(sum(state.receitas) - sum(state.despesas)))}
        ${stat("🎯", "bg-blue fg-blue", "Objetivos", "4 ativos")}
      </div>
      <div class="card" style="margin-top:14px"><div class="li" style="padding:0">
        <div class="li__ico bg-blue fg-blue">🤖</div><div class="li__body">
        <div class="li__title">Recomendações da IA</div>
        <div class="li__sub">A família poupou 12% acima da meta. Sugerimos reforçar o fundo "Casa Própria" com o excedente.</div></div></div>
      </div>
    </div>`,
  });

  /* --- Jornada 5 + 6 · Sonhos & Desafio --------------------------------- */
  S.sonhos = () => ({
    title: "Sonhos", root: true,
    html: `<div class="pad">
      <div class="card" data-nav="desafio" style="background:linear-gradient(150deg,#E8742C,#D2631C);color:#fff">
        <div class="li" style="padding:0"><div class="li__ico" style="background:rgba(255,255,255,.2)">🏆</div>
        <div class="li__body"><div class="li__title" style="color:#fff">Desafio 1 Milhão</div>
        <div class="li__sub" style="color:rgba(255,255,255,.85)">Plano inteligente para chegar a 1.000.000 Kz</div></div>
        <div class="li__chev" style="color:#fff">›</div></div>
      </div>
      <div class="row-between sec-title"><span>Sonhos Familiares</span><a class="link" data-nav="meta">+ Nova meta</a></div>
      ${state.sonhos.map(goalCard).join("")}
      <button class="btn btn--ghost" style="margin-top:14px" data-nav="simulador">🧮 Simulador de Poupança</button>
    </div>`,
  });

  S.meta = () => ({
    title: "Definir Meta",
    html: `<div class="pad">
      <div class="chips" style="margin-bottom:18px">
        ${["🏠 Casa", "🚗 Viatura", "🎓 Universidade", "🌍 Viagem", "🏪 Negócio"].map((o, i) => `<button class="chip${i === 0 ? " is-on" : ""}" data-toggle>${o}</button>`).join("")}
      </div>
      <div class="field"><label>Valor da meta</label><div class="input-kz"><input type="tel" inputmode="numeric" value="8.000.000"/></div></div>
      <div class="field"><label>Prazo</label><select><option>12 meses</option><option selected>24 meses</option><option>36 meses</option><option>60 meses</option></select></div>
      <div class="card" style="text-align:center;background:var(--blue-100)">
        <div class="stat__label">Contribuição mensal sugerida</div>
        <div style="font-family:Montserrat;font-weight:800;font-size:26px;color:var(--blue-800)">333.333 Kz</div>
      </div>
      <button class="btn btn--primary" style="margin-top:18px" data-toast="Meta criada com sucesso!" data-nav="sonhos">Criar Meta</button>
    </div>`,
  });

  S.simulador = () => ({
    title: "Simulador",
    html: `<div class="pad">
      <div class="card"><b style="font-family:Montserrat">Quanto preciso poupar?</b>
        <div class="field" style="margin-top:14px"><label>Objetivo</label><div class="input-kz"><input type="tel" inputmode="numeric" value="4.500.000"/></div></div>
        <div class="field"><label>Em quanto tempo</label><select><option>1 ano</option><option selected>2 anos</option><option>3 anos</option></select></div>
      </div>
      <div class="hero" style="margin-top:14px;text-align:center">
        <div class="hero__label">Precisa poupar por mês</div>
        <div class="hero__value">187.500 Kz</div>
        <div style="font-size:12px;opacity:.8;margin-top:6px">≈ 34% da sua poupança atual</div>
      </div>
    </div>`,
  });

  S.desafio = () => ({
    title: "Desafio 1 Milhão",
    html: `<div class="pad">
      <div class="hero" style="text-align:center;background:linear-gradient(150deg,#E8742C,#D2631C)">
        <div class="hero__label">Meu Objetivo</div>
        <div class="hero__value">1.000.000 Kz</div>
        <div class="prog" style="background:rgba(255,255,255,.25)"><div class="prog__fill" style="width:42%;background:#fff"></div></div>
        <div style="font-size:12px;opacity:.9;margin-top:8px">420.000 Kz alcançados · faltam 580.000 Kz</div>
      </div>
      <button class="btn btn--blue" style="margin-top:16px" data-nav="plano-inteligente">Ver Plano Inteligente ›</button>
    </div>`,
  });

  S["plano-inteligente"] = () => ({
    title: "Plano Inteligente",
    html: `<div class="pad">
      <div class="grid-3">
        ${stat("💵", "bg-blue fg-blue", "Atual", "545k")}
        ${stat("🎯", "bg-green fg-green", "Desejada", "850k")}
        ${stat("⚠️", "bg-orange fg-orange", "Gap", "305k")}
      </div>
      <div class="card" style="margin-top:14px"><b style="font-family:Montserrat">Como fechar o gap</b>
        <p style="font-size:13px;color:var(--ink-2);margin:8px 0 0">Aumentar a receita do negócio em 305.000 Kz/mês fecha o objetivo em 6 meses.</p>
      </div>
      <button class="btn btn--primary" style="margin-top:16px" data-nav="plano-crescimento">Plano de Crescimento ›</button>
    </div>`,
  });

  S["plano-crescimento"] = () => ({
    title: "Plano de Crescimento",
    html: `<div class="pad">
      <div class="sec-title" style="margin-top:0">Sugestões para aumentar a receita</div>
      <div class="list">
        ${listItem({ i: "🏪", c: "bg-orange fg-orange", t: "Expandir Negócio", s: "+150.000 Kz/mês potencial", amt: "›", chev: false })}
        ${listItem({ i: "🛒", c: "bg-blue fg-blue", t: "Vendas Online", s: "+90.000 Kz/mês", amt: "›", chev: false })}
        ${listItem({ i: "🧰", c: "bg-green fg-green", t: "Serviços", s: "+65.000 Kz/mês", amt: "›", chev: false })}
        ${listItem({ i: "📈", c: "bg-blue fg-blue", t: "Investimentos", s: "+40.000 Kz/mês", amt: "›", chev: false })}
      </div>
    </div>`,
  });

  /* --- Jornada 7 · Empreendedorismo ------------------------------------- */
  S.negocios = () => ({
    title: "Centro de Negócios",
    html: `<div class="pad">
      <div class="sec-title" style="margin-top:0">Ideias de negócio</div>
      <div class="list">
        ${["🍱 Catering", "💇 Salão", "🛒 Loja Online", "💄 Cosméticos", "🌾 Agricultura"].map((o) => {
          const [ic, ...n] = o.split(" ");
          return listItem({ i: ic, c: "bg-orange fg-orange", t: n.join(" "), s: "Plano simplificado disponível", amt: "›", chev: false });
        }).join("")}
      </div>
      <button class="btn btn--blue" style="margin-top:16px" data-nav="plano-negocio">📋 Plano de Negócio</button>
      <button class="btn btn--ghost" style="margin-top:10px" data-nav="marketplace">🛍️ Marketplace MAJU</button>
    </div>`,
  });

  S["plano-negocio"] = () => ({
    title: "Plano de Negócio",
    html: `<div class="pad">
      <div class="card"><b style="font-family:Montserrat">Catering MAJU</b>
        <div class="grid-3" style="margin-top:14px">
          ${stat("💵", "bg-blue fg-blue", "Investimento", "250k")}
          ${stat("💰", "bg-green fg-green", "Lucro/mês", "120k")}
          ${stat("⏱️", "bg-orange fg-orange", "Retorno", "3 meses")}
        </div>
      </div>
      <div class="card" style="margin-top:12px"><div class="row-between"><span class="li__sub">Margem estimada</span><b class="fg-green">48%</b></div>
        <div class="prog prog--green"><div class="prog__fill" style="width:48%"></div></div></div>
      <button class="btn btn--primary" style="margin-top:16px" data-toast="Plano guardado!">Guardar Plano</button>
    </div>`,
  });

  S.marketplace = () => ({
    title: "Marketplace MAJU",
    html: `<div class="pad">
      <div class="chips" style="margin-bottom:14px">
        <button class="chip is-on" data-toggle>Produtos</button>
        <button class="chip" data-toggle>Serviços</button>
        <button class="chip" data-toggle>Parcerias</button>
      </div>
      <div class="grid-2">
        ${prod("🍱", "Marmitas MAJU", "2.500 Kz")}
        ${prod("💄", "Kit Beleza", "8.900 Kz")}
        ${prod("🌾", "Cesto Bio", "5.400 Kz")}
        ${prod("👗", "Moda Local", "12.000 Kz")}
      </div>
    </div>`,
  });
  const prod = (i, t, p) =>
    `<div class="stat"><div class="stat__ico bg-orange fg-orange" style="width:100%;height:70px;font-size:30px">${i}</div>
     <div class="li__title" style="margin-top:8px">${t}</div><div class="li__amt fg-orange" style="text-align:left">${p}</div></div>`;

  /* --- Jornada 8 · Academia --------------------------------------------- */
  S.academia = () => ({
    title: "Academia MAJU",
    html: `<div class="pad">
      ${[["1", "Educação Financeira", false], ["2", "Gestão Familiar", false], ["3", "Empreendedorismo", true], ["4", "Investimentos", true]]
        .map(([n, t, lock]) =>
          `<div class="level${lock ? " is-locked" : ""}" ${lock ? "" : 'data-nav="cursos"'}>
             <div class="level__num">${n}</div>
             <div class="li__body"><div class="li__title">${t}</div>
             <div class="li__sub">${lock ? "🔒 Complete o nível anterior" : "Nível " + n}</div></div>
             <div class="li__chev">${lock ? "🔒" : "›"}</div></div>`).join("")}
    </div>`,
  });

  S.cursos = () => ({
    title: "Curso · Nível 1",
    html: `<div class="pad">
      <div class="card" style="background:var(--blue-100);text-align:center">
        <div style="font-size:40px">🎬</div><b style="font-family:Montserrat;display:block;margin-top:6px">Aula 1 · Orçamento 50/30/20</b>
      </div>
      <div class="list" style="margin-top:14px">
        ${listItem({ i: "🎬", c: "bg-blue fg-blue", t: "Vídeo-aula", s: "8 min", amt: "▶", chev: false })}
        ${listItem({ i: "📄", c: "bg-orange fg-orange", t: "Material PDF", s: "Resumo", amt: "⬇", chev: false })}
        ${listItem({ i: "❓", c: "bg-green fg-green", t: "Quiz", s: "5 perguntas", amt: "›", chev: false })}
        ${listItem({ i: "🏅", c: "bg-amber fg-orange", t: "Certificado", s: "Ao concluir", amt: "🔒", chev: false })}
      </div>
      <button class="btn btn--primary" style="margin-top:16px" data-toast="Aula iniciada!">Começar Aula</button>
    </div>`,
  });

  /* --- Jornada 9 · IA --------------------------------------------------- */
  S["chat-ia"] = () => ({
    title: "MAJU IA",
    html: `<div class="pad"><div class="chat">
      <div class="bubble bubble--ai">Olá, ${state.profile.name.split(" ")[0]}! Sou a sua assistente financeira. Como posso ajudar hoje?</div>
      <div class="bubble bubble--me">Posso comprar uma viatura?</div>
      <div class="bubble bubble--ai">Com a sua poupança atual de 78.000 Kz/mês, uma viatura de 4.500.000 Kz é viável em 24 meses sem comprometer as outras metas. Quer que eu crie um plano? 🚗</div>
      </div>
      <div class="chat-suggest">
        <button data-toast="A analisar...">Quanto devo poupar?</button>
        <button data-toast="A analisar...">Como reduzir gastos?</button>
        <button data-nav="assistente">Análise automática</button>
      </div>
    </div>`,
  });

  S.assistente = () => ({
    title: "Assistente Familiar",
    html: `<div class="pad">
      <div class="list">
        ${listItem({ i: "📊", c: "bg-blue fg-blue", t: "Análise automática", s: "Gastos 8% acima em transporte", amt: "›", chev: false })}
        ${listItem({ i: "🔔", c: "bg-orange fg-orange", t: "Alerta", s: "Fatura de energia vence em 3 dias", amt: "›", chev: false })}
        ${listItem({ i: "💡", c: "bg-green fg-green", t: "Sugestão", s: "Renegociar o crédito BAI poupa 60k", amt: "›", chev: false })}
      </div>
    </div>`,
  });

  /* --- Jornada 10 · Património ------------------------------------------ */
  S.patrimonio = () => ({
    title: "Meus Activos",
    html: `<div class="pad">
      <div class="hero"><div class="hero__label">Património Líquido</div><div class="hero__value">${kz(sum(state.activos) - 1290000)}</div>
        <div style="font-size:12px;opacity:.8;margin-top:6px">Activos ${kz(sum(state.activos))} − Passivos 1.290.000 Kz</div></div>
      <div class="list" style="margin-top:14px">
        ${state.activos.map((a) => listItem({ i: a.i, c: "bg-green fg-green", t: a.t, amt: kz(a.v) })).join("")}
      </div>
      <button class="btn btn--ghost" style="margin-top:14px" data-nav="evolucao">📈 Evolução Patrimonial</button>
    </div>`,
  });

  S.evolucao = () => ({
    title: "Evolução Patrimonial",
    html: `<div class="pad"><div class="card">
      <div class="row-between"><b style="font-family:Montserrat">Património por ano</b><span class="badge badge--green">+34%</span></div>
      ${barChart([14, 16, 18, 21, 24], ["2021", "2022", "2023", "2024", "2025"], "#1F5AA8")}
      <div class="li__sub" style="text-align:center;margin-top:8px">Em milhões de Kwanzas</div>
    </div></div>`,
  });

  /* --- Jornada 11 · Microcrédito ---------------------------------------- */
  S.score = () => ({
    title: "Score MAJU",
    html: `<div class="pad">
      <div class="card score">
        <div class="score__num">742<span class="score__max"> / 1000</span></div>
        <div class="prog prog--green"><div class="prog__fill" style="width:74%"></div></div>
        <div class="score__label">Score Familiar · Bom</div>
      </div>
      <div class="card" style="margin-top:12px"><p style="font-size:13px;color:var(--ink-2);margin:0">O seu histórico de poupança consistente e baixo endividamento elevam o score. Mantenha as metas em dia para subir a Excelente.</p></div>
      <button class="btn btn--primary" style="margin-top:16px" data-nav="elegibilidade">Ver Elegibilidade ›</button>
    </div>`,
  });

  S.elegibilidade = () => ({
    title: "Elegibilidade",
    html: `<div class="pad"><div class="list">
      ${listItem({ i: "💳", c: "bg-green fg-green", t: "Microcrédito", s: "Até 1.500.000 Kz", amt: "Elegível", amtClass: "amt-pos" })}
      ${listItem({ i: "🛡️", c: "bg-blue fg-blue", t: "Seguro Familiar", s: "Plano Essencial", amt: "Elegível", amtClass: "amt-pos" })}
      ${listItem({ i: "📈", c: "bg-orange fg-orange", t: "Investimento", s: "A partir de 50.000 Kz", amt: "Elegível", amtClass: "amt-pos" })}
    </div>
    <button class="btn btn--primary" style="margin-top:16px" data-toast="Pedido submetido!">Solicitar Microcrédito</button>
    </div>`,
  });

  /* --- Jornada 12 · Mais / Config --------------------------------------- */
  S.mais = () => ({
    title: "Mais", root: true,
    html: `<div class="pad">
      <div class="sec-title" style="margin-top:0">Desafios & Negócios</div>
      <div class="list menu">
        ${menuRow("🏆", "Desafio 1 Milhão", "desafio")}
        ${menuRow("🏪", "Centro de Negócios", "negocios")}
        ${menuRow("🛍️", "Marketplace", "marketplace")}
      </div>
      <div class="sec-title">Aprender & Crescer</div>
      <div class="list menu">
        ${menuRow("🎓", "Academia MAJU", "academia")}
        ${menuRow("🤖", "MAJU IA", "chat-ia")}
      </div>
      <div class="sec-title">Património & Crédito</div>
      <div class="list menu">
        ${menuRow("🏠", "Meus Activos", "patrimonio")}
        ${menuRow("⭐", "Score MAJU", "score")}
      </div>
      <div class="sec-title">Conta</div>
      <div class="list menu">
        ${menuRow("⚙️", "Configurações", "config")}
      </div>
    </div>`,
  });
  const menuRow = (i, t, nav) =>
    `<div class="li" data-nav="${nav}"><div class="li__ico">${i}</div><div class="li__body"><div class="li__title">${t}</div></div><div class="li__chev">›</div></div>`;

  S.config = () => ({
    title: "Configurações",
    html: `<div class="pad">
      <div class="card" style="text-align:center">
        <div class="avatar" style="width:70px;height:70px;font-size:26px;margin:6px auto 10px;background:#1F5AA8">MS</div>
        <b style="font-family:Montserrat">${state.profile.name}</b>
        <div class="li__sub">${state.profile.persona} · ${state.profile.civil}</div>
      </div>
      <div class="list" style="margin-top:14px">
        ${menuRow("👤", "Perfil", "config")}
        ${menuRow("👨‍👩‍👧", "Família", "familia")}
        ${menuRow("🔔", "Notificações", "config")}
        ${menuRow("🔒", "Segurança · MFA / OTP", "config")}
        ${menuRow("🌐", "Idioma · Português", "config")}
      </div>
      <button class="btn btn--outline" style="margin-top:16px;color:var(--red-500)" data-nav="splash">Terminar Sessão</button>
    </div>`,
  });

  /* --- Forms (Nova Receita / Nova Despesa) ------------------------------ */
  S["nova-receita"] = () => ({
    title: "Nova Receita",
    html: `<div class="pad">
      <div class="field"><label>Descrição</label><input id="f-desc" placeholder="Ex: Salário, Negócio…"/></div>
      <div class="field"><label>Valor</label><div class="input-kz"><input id="f-val" type="tel" inputmode="numeric" placeholder="0"/></div></div>
      <div class="field"><label>Categoria</label><select id="f-cat"><option>Salário</option><option>Negócio</option><option>Freelance</option><option>Comissões</option></select></div>
      <button class="btn btn--primary" data-add="receita">Guardar Receita</button>
    </div>`,
  });

  S["nova-despesa"] = () => ({
    title: "Nova Despesa",
    html: `<div class="pad">
      <div class="field"><label>Descrição</label><input id="f-desc" placeholder="Ex: Alimentação…"/></div>
      <div class="field"><label>Valor</label><div class="input-kz"><input id="f-val" type="tel" inputmode="numeric" placeholder="0"/></div></div>
      <div class="field"><label>Categoria</label><select id="f-cat"><option>Alimentação</option><option>Transporte</option><option>Habitação</option><option>Educação</option><option>Saúde</option><option>Telecomunicações</option></select></div>
      <button class="btn btn--primary" data-add="despesa">Guardar Despesa</button>
    </div>`,
  });

  /* ============================================================== ROUTER === */
  const TAB_OF = {
    home: "home", financas: "financas", receitas: "financas", despesas: "financas",
    fluxo: "financas", dividas: "financas", "nova-receita": "financas", "nova-despesa": "financas",
    familia: "familia", convite: "familia", conselho: "familia",
    sonhos: "sonhos", meta: "sonhos", simulador: "sonhos", desafio: "sonhos",
    "plano-inteligente": "sonhos", "plano-crescimento": "sonhos",
  };
  let history = [];

  function render(id) {
    const def = (S[id] || S.home)();
    const scr = $("#screen"), hdr = $("#appHeader"), tab = $("#tabBar");
    scr.innerHTML = def.html;
    scr.scrollTop = 0;

    if (def.chrome === false) {
      hdr.classList.add("hidden");
      tab.classList.add("hidden");
    } else {
      hdr.classList.remove("hidden");
      tab.classList.remove("hidden");
      $("#headerTitle").textContent = def.title || "MAJU";
      $("#backBtn").style.visibility = def.root ? "hidden" : "visible";
      // highlight active tab
      const root = TAB_OF[id] || "mais";
      tab.querySelectorAll(".tab").forEach((t) => t.classList.toggle("is-active", t.dataset.screen === root));
    }
  }

  function navigate(id, { replace } = {}) {
    if (!replace && history[history.length - 1] !== id) history.push(id);
    render(id);
  }

  function goBack() {
    history.pop();
    const prev = history[history.length - 1] || "home";
    render(prev);
  }

  /* ----------------------------------------------------- Event delegation --- */
  document.addEventListener("click", (e) => {
    const nav = e.target.closest("[data-nav]");
    const pick = e.target.closest("[data-pick]");
    const tgl = e.target.closest("[data-toggle]");
    const cat = e.target.closest("[data-cat]");
    const add = e.target.closest("[data-add]");
    const tst = e.target.closest("[data-toast]");

    if (pick) {
      pick.parentElement.querySelectorAll("[data-pick]").forEach((c) => c.classList.remove("is-on"));
      pick.classList.add("is-on");
      state.profile[pick.dataset.pick] = pick.dataset.val;
      return;
    }
    if (tgl) { tgl.classList.toggle("is-on"); }
    if (cat) { cat.classList.toggle("is-on"); }
    if (tst) toast(tst.dataset.toast);

    if (add) {
      const v = parseInt(($("#f-val").value || "0").replace(/\D/g, ""), 10) || 0;
      const desc = $("#f-desc").value || $("#f-cat").value;
      if (add.dataset.add === "receita")
        state.receitas.push({ t: desc, s: $("#f-cat").value, v, i: "💵", c: "bg-green fg-green" });
      else
        state.despesas.push({ t: desc, v, i: "🧾", c: "bg-red fg-red" });
      toast("Guardado com sucesso!");
      goBack();
      return;
    }

    if (nav) { navigate(nav.dataset.nav); return; }

    if (e.target.closest("#backBtn")) goBack();
    if (e.target.closest("#profileBtn")) navigate("config");
  });

  // Bottom tab navigation
  $("#tabBar").addEventListener("click", (e) => {
    const tab = e.target.closest(".tab");
    if (!tab) return;
    history = [];           // tabs reset the stack
    navigate(tab.dataset.screen);
  });

  /* ----------------------------------------------------------------- Boot --- */
  navigate("splash");
})();
