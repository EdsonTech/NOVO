/// Local, deterministic fallback classifier. Maps free text (merchant name or
/// raw OCR) to one of MAJU's expense categories. Used to:
///  - normalise / sanity-check the model's category, and
///  - classify offline (mock mode) without any network call.
abstract class CategoryClassifier {
  /// Canonical MAJU expense categories. MUST stay in sync with the Edge
  /// Function whitelist: supabase/functions/maju-ai/index.ts (CATEGORIES).
  static const categories = <String>[
    'Alimentação',
    'Transporte',
    'Habitação',
    'Educação',
    'Saúde',
    'Telecomunicações',
    'Outros',
  ];

  static const _keywords = <String, List<String>>{
    'Alimentação': ['supermercado', 'kero', 'mercado', 'restaurante', 'padaria', 'talho', 'shoprite', 'alimenta', 'comida', 'café'],
    'Transporte': ['taxi', 'táxi', 'combustível', 'gasolina', 'gasóleo', 'sonangol', 'pumangol', 'transporte', 'uber', 'candongueiro'],
    'Habitação': ['renda', 'arrendamento', 'condomínio', 'casa', 'mobília', 'ferragem'],
    'Educação': ['escola', 'colégio', 'propina', 'universidade', 'livro', 'material escolar', 'creche'],
    'Saúde': ['farmácia', 'clínica', 'hospital', 'consulta', 'medicamento', 'saúde'],
    'Telecomunicações': ['unitel', 'movicel', 'africell', 'internet', 'recarga', 'saldo', 'tv', 'dstv', 'zap'],
  };

  /// Returns the best-matching category for [text], or 'Outros'.
  static String classify(String text) {
    final t = text.toLowerCase();
    for (final entry in _keywords.entries) {
      if (entry.value.any(t.contains)) return entry.key;
    }
    return 'Outros';
  }

  /// True if [category] is a recognised MAJU category.
  static bool isKnown(String category) => categories.contains(category);

  /// Normalises a model-provided category: keep it if known, else re-classify
  /// from the merchant text.
  static String normalise(String modelCategory, String merchant) {
    if (isKnown(modelCategory)) return modelCategory;
    return classify('$modelCategory $merchant');
  }
}
