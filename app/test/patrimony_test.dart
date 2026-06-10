import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju_app/src/features/patrimony/data/assets_repository.dart';
import 'package:maju_app/src/features/patrimony/domain/asset.dart';
import 'package:maju_app/src/features/patrimony/presentation/patrimony_providers.dart';

void main() {
  test('PatrimonySummary nets assets against liabilities', () {
    const items = [
      Asset(id: '1', title: 'Casa', category: 'imovel', value: 12000000, isLiability: false),
      Asset(id: '2', title: 'Empréstimo', category: 'divida', value: 1200000, isLiability: true),
    ];
    final s = PatrimonySummary.from(items);
    expect(s.assets, 12000000);
    expect(s.liabilities, 1200000);
    expect(s.net, 10800000);
  });

  test('InMemory assets repository adds an asset', () async {
    final repo = InMemoryAssetsRepository();
    final before = (await repo.fetch()).length;
    await repo.add(const Asset(id: '', title: 'Moto', category: 'veiculo', value: 900000, isLiability: false));
    expect((await repo.fetch()).length, before + 1);
  });

  test('offline mode selects the in-memory assets repository', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(assetsRepositoryProvider), isA<InMemoryAssetsRepository>());
  });
}
