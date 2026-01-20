import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/detailed/presentation/detail_header.dart';
import 'package:chain_flow/features/detailed/presentation/detailed_providers.dart';
import 'package:chain_flow/features/detailed/presentation/mini_orderwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_chart/interactive_chart.dart';

class CoinDetailScreen extends ConsumerWidget {
  final String symbol;
  const CoinDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickerAsync = ref.watch(CoinTickerProvider(symbol));
    final chartAsync = ref.watch(candleStreamProvider(symbol));
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
          backgroundColor: Colors.transparent, title: Text("$symbol/USDT")),
      body: Column(
        children: [
          tickerAsync.when(
              data: (stats) => DetailHeader(stats: stats),
              error: (_, __) => Text(
                    "Error Loading stats",
                    style: TextStyle(color: Colors.red),
                  ),
              loading: () => LinearProgressIndicator()),
          Expanded(
              flex: 3,
              child: chartAsync.when(
                  data: (candles) => InteractiveChart(
                        candles: candles,
                        style: ChartStyle(
                            priceGainColor: AppColors.greenGain,
                            priceLossColor: AppColors.redLoss,
                            volumeColor: Colors.transparent),
                      ),
                  error: (_, __) => Center(
                        child: Text("Chart Error"),
                      ),
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: AppColors.divider,
              height: 1,
            ),
          ),
          Expanded(
              flex: 1,
              child: chartAsync.maybeWhen(
                  orElse: () => SizedBox(),
                  data: (candles) => InteractiveChart(
                        candles: candles,
                        style: ChartStyle(
                            volumeColor: Colors.white.withOpacity(0.2),
                            priceGainColor: Colors.transparent,
                            priceLossColor: Colors.transparent),
                      ))),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(indicatorColor: AppColors.primaryGold, tabs: [
                  _TabItem(label: "Order Book", isActive: true),
                  _TabItem(label: "MarketTrades", isActive: false),
                ]),
                SizedBox(
                  height: 200,
                  child: TabBarView(children: [
                    MiniOrderBook(symbol: symbol),
                    Center(
                      child: Text(
                        "Market Trade List",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ]),
                )

                //_TabItem(label: "Info", isActive: false)
              ],
            ),
          ),
          _buildStickyBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlack,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_border, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: _btn("BUY", AppColors.greenGain, () {}),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _btn("SELL", AppColors.redLoss, () {}),
          ),
        ],
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TabItem({
    super.key,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary),
          ),
          if (isActive)
            Container(
              height: 2,
              width: 20,
              color: AppColors.primaryGold,
              margin: EdgeInsets.only(top: 4),
            )
        ],
      ),
    );
  }
}
