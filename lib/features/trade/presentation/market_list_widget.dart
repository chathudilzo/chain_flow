import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/market/presentation/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketListWidget extends ConsumerWidget {
  final Function(String symbol) onSelected;
  const MarketListWidget({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketAsync = ref.watch(filteredCoinProvider);
    return marketAsync.when(
        data: (coins) => ListView.builder(
            itemCount: coins.length,
            itemBuilder: (context, index) {
              final coin = coins[index];
              return ListTile(
                onTap: () {
                  onSelected(coin.symbol);
                },
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondaryBlack,
                  child: Text(
                    coin.symbol,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Text(
                  "Vol: ${coin.volume.toStringAsFixed(0)}",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("\$${coin.price.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white)),
                    Text(
                      "${coin.percentChange}%",
                      style: TextStyle(
                          color: coin.percentChange >= 0
                              ? AppColors.greenGain
                              : AppColors.redLoss,
                          fontSize: 12),
                    ),
                  ],
                ),
              );
            }),
        error: (e, st) => Center(
              child: Text(
                "Error $e",
                style: TextStyle(),
              ),
            ),
        loading: () => Center(
              child: CircularProgressIndicator(),
            ));
  }
}
