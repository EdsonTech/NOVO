import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/ai_repository.dart';

/// Picks the Edge Function (live) or mock AI implementation based on config.
final aiRepositoryProvider = Provider<AiRepository>((ref) {
  if (Env.hasBackend) {
    return SupabaseAiRepository(Supabase.instance.client);
  }
  return MockAiRepository();
});
