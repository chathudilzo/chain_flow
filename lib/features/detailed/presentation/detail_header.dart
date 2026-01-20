import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/detailed/domain/coin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailHeader extends StatelessWidget {
  final CoinTickerStats stats;
  const DetailHeader({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final color =
        stats.priceChangePercent >= 0 ? AppColors.greenGain : AppColors.redLoss;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stats.lastPrice.toStringAsFixed(2),
                style: TextStyle(
                    color: color, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "${stats.priceChangePercent >= 0 ? '+' : ''}${stats.priceChangePercent}%",
                style: TextStyle(color: color, fontSize: 14),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  _statItem("24h High", stats.high24h.toStringAsFixed(2)),
                  _statItem("24h Low", stats.low24h.toStringAsFixed(2)),
                ],
              ),
              Column(
                children: [
                  _statItem("24h Vol(USDT)", _formatVol(stats.volUsdt)),
                  _statItem("24h Vol(Coin)", _formatVol(stats.volCoin)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            "$label",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _formatVol(double vol) => vol > 1000000
      ? "${(vol / 1000000).toStringAsFixed(2)}M"
      : vol.toStringAsFixed(0);
}
