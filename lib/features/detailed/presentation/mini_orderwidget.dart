import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/trade/domain/trade_model.dart';
import 'package:chain_flow/features/trade/presentation/trade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MiniOrderBook extends ConsumerWidget {
  final String symbol;
  const MiniOrderBook({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderBookSync = ref.watch(orderBookProvider(symbol));
    return orderBookSync.when(
        data: (data) {
          final asks = data["asks"];
          final bids = data["bids"];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildMiniSide(
                        bids!.take(6).toList(), AppColors.greenGain)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildMiniSide(
                        asks!.take(6).toList(), AppColors.redLoss)),
              ],
            ),
          );
        },
        error: (e, _) => Center(
              child: Text(
                "Error: $e",
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
        loading: () => Center(
              child: CircularProgressIndicator(),
            ));
  }

  Widget _buildMiniSide(List<OrderBookEntry> entries, Color color) {
    return Column(
      children: entries
          .map((e) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.price.toStringAsFixed(2),
                        style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                    Text(e.quantity.toStringAsFixed(4),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
