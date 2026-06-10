import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/assets_repository.dart';
import '../domain/asset.dart';

final assetsRepositoryProvider = Provider<AssetsRepository>((ref) {
  if (Env.hasBackend) {
    return SupabaseAssetsRepository(Supabase.instance.client);
  }
  return InMemoryAssetsRepository();
});

final assetsProvider = FutureProvider<List<Asset>>((ref) {
  return ref.watch(assetsRepositoryProvider).fetch();
});

final patrimonySummaryProvider = Provider<AsyncValue<PatrimonySummary>>((ref) {
  return ref.watch(assetsProvider).whenData(PatrimonySummary.from);
});

/// Maps an asset category to a Material icon.
IconData assetIcon(String category) => switch (category) {
      'imovel' => Icons.home_outlined,
      'veiculo' => Icons.directions_car_outlined,
      'negocio' => Icons.storefront_outlined,
      'poupanca' => Icons.savings_outlined,
      'divida' => Icons.credit_card,
      _ => Icons.account_balance_outlined,
    };
