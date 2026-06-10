import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/asset.dart';

/// Contract for patrimony persistence. Same swap pattern as the other features.
abstract class AssetsRepository {
  Future<List<Asset>> fetch();
  Future<Asset> add(Asset asset);
}

/// ---- Supabase implementation (table `assets`) ------------------------------
class SupabaseAssetsRepository implements AssetsRepository {
  SupabaseAssetsRepository(this._db);
  final SupabaseClient _db;

  @override
  Future<List<Asset>> fetch() async {
    final rows = await _db.from('assets').select().order('created_at');
    return rows.map(Asset.fromMap).toList();
  }

  @override
  Future<Asset> add(Asset asset) async {
    final row = await _db.from('assets').insert(asset.toMap()).select().single();
    return Asset.fromMap(row);
  }
}

/// ---- In-memory implementation (offline/mock) -------------------------------
class InMemoryAssetsRepository implements AssetsRepository {
  final List<Asset> _items = [
    const Asset(id: '1', title: 'Casa', category: 'imovel', value: 12000000, isLiability: false),
    const Asset(id: '2', title: 'Terreno', category: 'imovel', value: 4500000, isLiability: false),
    const Asset(id: '3', title: 'Viatura', category: 'veiculo', value: 3200000, isLiability: false),
    const Asset(id: '4', title: 'Negócio', category: 'negocio', value: 2800000, isLiability: false),
    const Asset(id: '5', title: 'Poupanças', category: 'poupanca', value: 1650000, isLiability: false),
    const Asset(id: '6', title: 'Empréstimo BAI', category: 'divida', value: 1200000, isLiability: true),
  ];

  @override
  Future<List<Asset>> fetch() async => List.unmodifiable(_items);

  @override
  Future<Asset> add(Asset asset) async {
    final created = Asset(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: asset.title,
      category: asset.category,
      value: asset.value,
      isLiability: asset.isLiability,
    );
    _items.add(created);
    return created;
  }
}
