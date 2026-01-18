import 'package:chain_flow/features/market/data/market_repository_impl.dart.dart';
import 'package:chain_flow/features/market/domain/market_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketRepoProvider = Provider((ref) => MarketRepositoryImpl());

final allCoinProvider = StreamProvider.autoDispose<List<CoinEntity>>((ref) {
  return ref.watch(marketRepoProvider).watchAllPrices();
});

final markerSearchProvider = StateProvider<String>((ref) => "");

final filteredCoinProvider = Provider<AsyncValue<List<CoinEntity>>>((ref) {
  final allCoinAsync = ref.watch(allCoinProvider);
  final searchQuery = ref.watch(markerSearchProvider).toLowerCase();

  return allCoinAsync.whenData((coins) {
    if (searchQuery.isEmpty) return coins;
    return coins
        .where((coin) => coin.symbol.toLowerCase().contains(searchQuery))
        .toList();
  });
});
