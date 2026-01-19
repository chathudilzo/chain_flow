import 'package:chain_flow/features/market/domain/market_model.dart';
import 'package:chain_flow/features/market/presentation/market_provider.dart';
import 'package:chain_flow/features/wallet/domain/asset_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBalancesProvider = Provider<Map<String, double>>((ref) {
  return {"BTC": 0.25, "ETH": 2.5, "SOL": 50.0};
});

final liveAssetProvider = Provider<List<AssetEntity>>((ref) {
  final balance = ref.watch(userBalancesProvider);
  final marketDataAsync = ref.watch(allCoinProvider);

  return marketDataAsync.maybeWhen(
      data: (coins) {
        return balance.entries.map((entry) {
          final liveCoin = coins.firstWhere(
            (c) => c.symbol == entry.key,
            orElse: () => CoinEntity(
                symbol: entry.key,
                price: 0,
                percentChange: 0,
                high: 0,
                low: 0,
                volume: 0),
          );
          return AssetEntity(
              symbol: entry.key,
              amount: entry.value,
              currentPrice: liveCoin.price);
        }).toList();
      },
      orElse: () => []);
});

final liveTotalBalanceProvider = Provider<double>((ref) {
  final asset = ref.watch(liveAssetProvider);
  return asset.fold(0.0, (sum, asset) => sum + asset.totalValue);
});
