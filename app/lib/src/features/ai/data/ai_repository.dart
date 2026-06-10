import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../finances/domain/transaction.dart';
import '../domain/category_classifier.dart';
import '../domain/receipt_scan.dart';

/// Contract for MAJU IA: receipt extraction + financial Q&A.
/// Implementations are chosen at runtime (see ai_providers.dart).
abstract class AiRepository {
  /// Extracts a structured [ReceiptScan] from a receipt image.
  Future<ReceiptScan> scanReceipt(Uint8List imageBytes);

  /// Answers a financial question (chat). [context] carries family figures.
  Future<String> ask(String question, {Map<String, dynamic>? context});
}

/// ---- Supabase Edge Function implementation ---------------------------------
/// Calls the `maju-ai` function, which proxies Azure OpenAI (vision + chat)
/// server-side so the API key never reaches the client.
class SupabaseAiRepository implements AiRepository {
  SupabaseAiRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<ReceiptScan> scanReceipt(Uint8List imageBytes) async {
    final res = await _client.functions.invoke(
      'maju-ai',
      body: {
        'action': 'scan_receipt',
        'image_base64': base64Encode(imageBytes),
      },
    );
    final scan = ReceiptScan.fromJson(_asMap(res.data));
    // Never trust the model's category blindly — normalise it.
    return scan.copyWith(
      category: CategoryClassifier.normalise(scan.category, scan.merchant),
    );
  }

  @override
  Future<String> ask(String question, {Map<String, dynamic>? context}) async {
    final res = await _client.functions.invoke(
      'maju-ai',
      body: {'action': 'chat', 'question': question, 'context': context},
    );
    return _asMap(res.data)['answer'] as String? ?? '';
  }

  /// `functions.invoke` may return an already-decoded Map or a JSON String
  /// depending on the response content-type. Handle both.
  Map<String, dynamic> _asMap(dynamic data) {
    final decoded = data is String ? jsonDecode(data) : data;
    return (decoded as Map).cast<String, dynamic>();
  }
}

/// ---- Mock implementation (offline/dev) -------------------------------------
/// Simulates extraction without any backend, so the receipt → lançamento flow
/// is fully demoable. Classification uses the local [CategoryClassifier].
class MockAiRepository implements AiRepository {
  int _i = 0;

  static const _samples = [
    ('Supermercado Kero', 12500, 'Alimentação'),
    ('Pumangol', 9000, 'Transporte'),
    ('Farmácia Popular', 4300, 'Saúde'),
    ('Unitel Recarga', 2000, 'Telecomunicações'),
  ];

  @override
  Future<ReceiptScan> scanReceipt(Uint8List imageBytes) async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    final (merchant, amount, _) = _samples[_i++ % _samples.length];
    // Classify locally to mirror what the real pipeline normalises to.
    final category = CategoryClassifier.classify(merchant);
    return ReceiptScan(
      merchant: merchant,
      amount: amount,
      date: DateTime.now(),
      category: category,
      type: TxType.expense,
      confidence: 0.92,
      rawText: 'Comprovante simulado · $merchant',
    );
  }

  @override
  Future<String> ask(String question, {Map<String, dynamic>? context}) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return 'Com a sua poupança atual, esse objetivo é viável. '
        'Posso preparar um plano detalhado se quiser. 💡\n'
        '(resposta simulada — ligue o Azure OpenAI via Edge Function "maju-ai")';
  }
}
