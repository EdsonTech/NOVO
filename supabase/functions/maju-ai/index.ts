// MAJU IA — Supabase Edge Function (Deno).
//
// Proxies Azure OpenAI server-side so the API key NEVER reaches the Flutter
// client. Two actions:
//   - scan_receipt: vision model reads a receipt image → structured JSON
//   - chat:         financial Q&A grounded in the family context
//
// Deploy:  supabase functions deploy maju-ai
// Secrets: supabase secrets set AZURE_OPENAI_ENDPOINT=... AZURE_OPENAI_KEY=... \
//                               AZURE_OPENAI_DEPLOYMENT=gpt-4o
//
// Auth: the function runs with the caller's JWT; Supabase verifies it.

const ENDPOINT = Deno.env.get("AZURE_OPENAI_ENDPOINT")!;
const API_KEY = Deno.env.get("AZURE_OPENAI_KEY")!;
const DEPLOYMENT = Deno.env.get("AZURE_OPENAI_DEPLOYMENT") ?? "gpt-4o";

// Canonical MAJU expense categories. MUST stay in sync with the Dart side:
// app/lib/src/features/ai/domain/category_classifier.dart (CategoryClassifier.categories).
const CATEGORIES = [
  "Alimentação", "Transporte", "Habitação",
  "Educação", "Saúde", "Telecomunicações", "Outros",
];

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, "content-type": "application/json" },
  });
}

async function azureChat(messages: unknown[], jsonMode = false): Promise<string> {
  const url =
    `${ENDPOINT}/openai/deployments/${DEPLOYMENT}/chat/completions?api-version=2024-08-01-preview`;
  const res = await fetch(url, {
    method: "POST",
    headers: { "api-key": API_KEY, "content-type": "application/json" },
    body: JSON.stringify({
      messages,
      temperature: 0.1,
      ...(jsonMode ? { response_format: { type: "json_object" } } : {}),
    }),
  });
  if (!res.ok) throw new Error(`Azure OpenAI ${res.status}: ${await res.text()}`);
  const data = await res.json();
  return data.choices?.[0]?.message?.content ?? "";
}

async function scanReceipt(imageBase64: string) {
  const content = await azureChat([
    {
      role: "system",
      content:
        "És um extrator de comprovantes para Angola. Devolve SÓ JSON com as chaves: " +
        "merchant (string), amount (número em Kwanza, sem separadores), date (ISO 8601), " +
        `category (uma de: ${CATEGORIES.join(", ")}), type ('expense'|'income'), ` +
        "confidence (0..1), raw_text (string). Não inventes valores.",
    },
    {
      role: "user",
      content: [
        { type: "text", text: "Extrai os dados deste comprovante." },
        { type: "image_url", image_url: { url: `data:image/jpeg;base64,${imageBase64}` } },
      ],
    },
  ], true);

  // Model output can be malformed/truncated even in JSON mode — never throw.
  let parsed: Record<string, unknown>;
  try {
    parsed = JSON.parse(content);
  } catch {
    return {
      merchant: "Comprovante",
      amount: 0,
      date: new Date().toISOString(),
      category: "Outros",
      type: "expense",
      confidence: 0,
      raw_text: content,
    };
  }
  // Authoritative server-side coercion/validation.
  const amt = Number(String(parsed.amount ?? "").replace(/[^\d.]/g, ""));
  parsed.amount = Number.isFinite(amt) ? amt : 0;
  if (!CATEGORIES.includes(parsed.category as string)) parsed.category = "Outros";
  if (parsed.type !== "income" && parsed.type !== "expense") parsed.type = "expense";
  return parsed;
}

async function chat(question: string, context: unknown) {
  const answer = await azureChat([
    {
      role: "system",
      content:
        "És a MAJU IA, assistente financeira de famílias angolanas. Responde em " +
        "português (pt-AO), de forma curta, prática e empática. Moeda: Kwanza (Kz). " +
        `Contexto do agregado: ${JSON.stringify(context ?? {})}`,
    },
    { role: "user", content: question },
  ]);
  return { answer };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  try {
    const { action, image_base64, question, context } = await req.json();
    switch (action) {
      case "scan_receipt":
        return json(await scanReceipt(image_base64));
      case "chat":
        return json(await chat(question, context));
      default:
        return json({ error: "unknown action" }, 400);
    }
  } catch (e) {
    // Log details server-side only; never echo internals to the client.
    console.error("maju-ai error:", e instanceof Error ? e.message : e);
    return json({ error: "ai_unavailable" }, 500);
  }
});
