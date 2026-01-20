import 'package:chain_flow/app_colors.dart';
import 'package:chain_flow/features/trade/presentation/trade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradePanel extends ConsumerWidget {
  final String symbol;
  final bool isBuy;
  const TradePanel({super.key, required this.symbol, required this.isBuy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionTabs(ref, isBuy),
          const SizedBox(
            height: 16,
          ),
          _buildNumericInput(
              label: "Price",
              suffix: "USDT",
              controller: TextEditingController(text: "42150.00")),
          SizedBox(
            height: 12,
          ),
          _buildNumericInput(
              label: "Amount",
              suffix: symbol,
              controller: TextEditingController()),
          SizedBox(
            height: 16,
          ),
          _buildPercentageSelector(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Available",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text("0.00 USDT",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          Spacer(),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isBuy ? AppColors.greenGain : AppColors.redLoss,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isBuy ? "Buy $symbol" : "Sell $symbol",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Widget _buildPercentageSelector() {
    return Row(
      children: ["25%", "50%", "75%", "100%"].map((percent) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            percent,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumericInput(
      {required String label,
      required String suffix,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        SizedBox(
          height: 12,
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
              suffixText: suffix,
              filled: true,
              fillColor: AppColors.secondaryBlack,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none)),
        )
      ],
    );
  }

  Widget _buildActionTabs(WidgetRef ref, bool isBuy) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
          color: AppColors.secondaryBlack,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          _tabItem(ref, "Buy", true, isBuy),
          _tabItem(ref, "Sell", false, !isBuy)
        ],
      ),
    );
  }

  Widget _tabItem(WidgetRef ref, String label, bool targetState, bool active) {
    return Expanded(
        child: InkWell(
            onTap: () =>
                ref.read(tradeTypeProvider.notifier).state = targetState,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: active
                      ? (targetState ? AppColors.greenGain : AppColors.redLoss)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                label,
                style: TextStyle(
                    color: active ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold),
              ),
            )));
  }
}
