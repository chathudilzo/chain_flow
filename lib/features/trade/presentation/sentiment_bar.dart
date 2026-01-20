import 'package:chain_flow/app_colors.dart';
import 'package:flutter/material.dart';

class SentimentBar extends StatelessWidget {
  final double buyPercent;
  const SentimentBar({super.key, required this.buyPercent});

  @override
  Widget build(BuildContext context) {
    final greenWeight = buyPercent.clamp(0.05, 0.95);
    final redWeight = 1.0 - greenWeight;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Row(
              children: [
                Expanded(
                    flex: (greenWeight * 100).toInt(),
                    child: Container(
                      height: 4,
                      color: AppColors.greenGain,
                    )),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                    flex: (redWeight * 100).toInt(),
                    child: Container(
                      height: 4,
                      color: AppColors.redLoss,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
