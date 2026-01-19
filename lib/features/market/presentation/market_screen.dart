import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/market/domain/market_model.dart';
import 'package:chain_flow/features/market/presentation/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketAsync = ref.watch(filteredCoinProvider);

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: AppColors.primaryBlack,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Market",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            titlePadding: EdgeInsets.only(left: 16, bottom: 60),
          ),
          pinned: true,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) =>
                      ref.read(markerSearchProvider.notifier).state = value,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Search Coins...",
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      fillColor: AppColors.secondaryBlack,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              )),
        ),
        marketAsync.when(
            data: (coins) => SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => _CoinRow(coin: coins[index]),
                    childCount: coins.length)),
            error: (e, st) => Center(
                  child: Text(
                    "Error $e",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            loading: () => const SliverFillRemaining(
                    child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGold,
                  ),
                )))
      ]),
    );
  }
}

class _CoinRow extends StatelessWidget {
  final CoinEntity coin;
  const _CoinRow({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coin.symbol,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(
                  "Vol: \$${_formatVolume(coin.volume)}",
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("\$${coin.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(
                "${coin.percentChange >= 0 ? '+' : ''}${coin.percentChange}%",
                style: TextStyle(
                    color: coin.percentChange >= 0
                        ? AppColors.greenGain
                        : AppColors.redLoss,
                    fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000000)
      return '${(volume / 1000000000).toStringAsFixed(2)}B';
    if (volume >= 1000000) return '${(volume / 1000000).toStringAsFixed(2)}M';
    return volume.toStringAsFixed(0);
  }
}
