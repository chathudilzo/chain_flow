import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/trade/domain/trade_model.dart';
import 'package:chain_flow/features/trade/presentation/sentiment_bar.dart';
import 'package:chain_flow/features/trade/presentation/trade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderBookPanel extends ConsumerWidget {
  final String symbol;
  const OrderBookPanel({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderBookAsync = ref.watch(orderBookProvider(symbol));
    return orderBookAsync.when(
        data: (data) {
          final asks = data['asks']!.reversed.toList();
          final bids = data['bids']!;

          double maxVolume = 0;
          for (var e in [...asks, ...bids]) {
            if (e.quantity > maxVolume) maxVolume = e.quantity;
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price",
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 10)),
                    Text("Amount",
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 10)),
                  ],
                ),
              ),
              _buildList(asks.take(10).toList(), AppColors.redLoss, maxVolume),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  asks.isNotEmpty ? asks.last.price.toStringAsFixed(2) : "0.00",
                  style: TextStyle(color: AppColors.greenGain, fontSize: 18),
                ),
              ),
              _buildList(
                  bids.take(10).toList(), AppColors.greenGain, maxVolume),
              SizedBox(
                height: 12,
              ),
              SentimentBar(buyPercent: _calculateSentiment(bids, asks))
            ],
          );
        },
        error: (e, st) => Center(
              child: Text("Error $e"),
            ),
        loading: () => Center(
              child: CircularProgressIndicator(),
            ));
  }

  Widget _buildList(
      List<OrderBookEntry> entries, Color color, double maxVolume) {
    return Column(
      children: entries
          .map((e) => _OrderRow(
                price: e.price,
                amount: e.quantity,
                color: color,
                totalVolumeRatio: maxVolume > 0 ? e.quantity / maxVolume : 0,
              ))
          .toList(),
    );
  }

  double _calculateSentiment(
      List<OrderBookEntry> bids, List<OrderBookEntry> asks) {
    if (bids.isEmpty || asks.isEmpty) return 0.5;
    double totalBids = bids.take(5).fold(0, (sum, e) => sum + e.quantity);
    double totalAsks = asks.take(5).fold(0, (sum, e) => sum + e.quantity);
    return totalBids / (totalBids + totalAsks);
  }
}

class _OrderRow extends StatelessWidget {
  final double price;
  final double amount;
  final Color color;
  final double totalVolumeRatio;
  const _OrderRow(
      {super.key,
      required this.price,
      required this.amount,
      required this.color,
      required this.totalVolumeRatio});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        FractionallySizedBox(
          widthFactor: totalVolumeRatio,
          child: Container(
            height: 20,
            color: color.withOpacity(0.15),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price.toStringAsFixed(2),
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                amount.toStringAsFixed(4),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        )
      ],
    );
  }
}
